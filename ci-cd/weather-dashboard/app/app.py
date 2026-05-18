"""
Weather Dashboard — main web application file.

Think of this file as the "brain" of a small website that:
  1. Shows a simple home page with links.
  2. Fetches live weather from OpenWeatherMap when someone asks for it.
  3. Reports whether the app itself is healthy (/healthz).
  4. Exposes numbers for monitoring tools like Prometheus (/metrics).

When this program runs (usually via Gunicorn in Docker/Kubernetes), it listens
for HTTP requests — the same kind your browser sends when you visit a URL.
"""

from __future__ import annotations

# --- Standard library (built into Python, no extra install) ---
import os

# `os` lets us read environment variables — configuration values injected at
# runtime (e.g. OPENWEATHER_API_KEY from Kubernetes secrets or your shell).
import time

# High-resolution clock used to measure how long each web request takes.
from typing import Any

# `Any` is a type hint meaning "this value can be almost anything"; used where
# Flask returns mixed types (dict, Response, tuple, etc.).
# --- Third-party packages (installed via requirements.txt) ---
import requests

# `requests` performs outbound HTTP calls — here, to OpenWeatherMap's API.
from flask import Flask, Response, jsonify, render_template_string

# Flask = lightweight web framework: routes URLs to Python functions.
# Response = raw HTTP response object (used for /metrics binary/text body).
# jsonify = wraps a Python dict as JSON with correct Content-Type header.
# render_template_string = turns a string of HTML into a page Flask can return.
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest

# Prometheus client library: collects counters/histograms so monitoring systems
# can scrape /metrics and graph traffic, errors, and response times.

# --- Configuration constants ---

OPENWEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
# Base URL for OpenWeatherMap's "current weather by city name" API.
# We append query parameters (city, API key, units) when we call it.

# --- Monitoring metrics (Prometheus) ---
# These are created once at import time and updated on every HTTP request.
# Operators use them in Grafana dashboards to see load and slowness.

REQUESTS_TOTAL = Counter(
    "weather_http_requests_total",
    "HTTP requests",
    ["handler", "method", "code"],
)
# Counter = only goes up. Each label combination tracks how many requests
# hit which route ("handler"), with which HTTP method (GET, etc.), and
# what status code was returned (200 OK, 502 error, etc.).

REQUEST_LATENCY_SECONDS = Histogram(
    "weather_http_request_duration_seconds",
    "HTTP request latency",
    ["handler", "method"],
    buckets=(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0),
)
# Histogram = buckets request durations (in seconds) so you can see percentiles
# like "95% of requests finished under 0.5s". The bucket tuple defines the
# boundaries Prometheus uses to group observations.

# --- Simple home page HTML (embedded as a string, not a separate file) ---

INDEX_HTML = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Weather dashboard</title>
  <style>
    :root { font-family: system-ui, sans-serif; line-height: 1.4; }
    body { max-width: 40rem; margin: 2rem auto; padding: 0 1rem; }
    code { background: #f4f4f5; padding: 0.1rem 0.3rem; border-radius: 4px; }
  </style>
</head>
<body>
  <h1>Weather dashboard</h1>
  <p>JSON: <a href="/api/weather"><code>/api/weather</code></a></p>
  <p>Health: <a href="/healthz"><code>/healthz</code></a></p>
  <p>Metrics: <a href="/metrics"><code>/metrics</code></a></p>
</body>
</html>
"""
# This is the page users see at "/". Links point to the API, health check,
# and metrics endpoints — handy for manual testing without memorizing URLs.


def create_app() -> Flask:
    """
    Factory that builds and configures the Flask application.

    Using a factory (instead of creating `app` at the top level only) makes
    unit tests easier: tests can call create_app() and get a fresh instance.
    """

    app = Flask(__name__)
    # `__name__` tells Flask where this module lives (for templates/static paths).

    # -------------------------------------------------------------------------
    # Request timing hooks — run automatically around every route
    # -------------------------------------------------------------------------

    @app.before_request
    def _start_timer() -> None:
        """
        Runs immediately BEFORE each incoming request is handled.

        We store the start time on Flask's `g` object (request-local storage)
        so the after_request hook can compute elapsed time later.
        """
        from flask import g

        g._t0 = time.perf_counter()

    @app.after_request
    def _observe(response: Any) -> Any:
        """
        Runs AFTER each request finishes, before the response is sent.

        Records:
          - one increment on REQUESTS_TOTAL (count of requests)
          - one observation on REQUEST_LATENCY_SECONDS (how long it took)

        Then returns the same response unchanged — we're only observing, not
        modifying the body or status unless we chose to.
        """
        from flask import g, request

        # `endpoint` is Flask's internal name for the route function (e.g. "index").
        handler = request.endpoint or "unknown"
        REQUESTS_TOTAL.labels(
            handler=str(handler),
            method=request.method,
            code=str(response.status_code),
        ).inc()
        t0 = getattr(g, "_t0", None)
        if t0 is not None:
            REQUEST_LATENCY_SECONDS.labels(
                handler=str(handler),
                method=request.method,
            ).observe(time.perf_counter() - t0)
        return response

    # -------------------------------------------------------------------------
    # Routes — each @app.get("/path") maps a URL to a Python function
    # -------------------------------------------------------------------------

    @app.get("/healthz")
    def healthz() -> tuple[dict[str, str], int]:
        """
        Liveness/readiness probe endpoint for Kubernetes and load balancers.

        Returns {"status": "ok"} with HTTP 200 if the process is up.
        Does NOT call OpenWeather — so a bad API key won't mark the pod "down".
        """
        return {"status": "ok"}, 200

    @app.get("/metrics")
    def metrics() -> Response:
        """
        Prometheus scrape endpoint.

        Monitoring agents poll this URL periodically. The body is text in
        Prometheus exposition format (metric names, labels, values).
        """
        data = generate_latest()
        return Response(data, mimetype=CONTENT_TYPE_LATEST)

    @app.get("/")
    def index() -> str:
        """
        Home page — renders INDEX_HTML so visitors see links to other endpoints.
        """
        return render_template_string(INDEX_HTML)

    @app.get("/api/weather")
    def api_weather() -> tuple[Any, int]:
        """
        Main feature: fetch current weather and return JSON.

        Flow:
          1. Read API key and optional city/units from environment variables.
          2. If no key → 503 Service Unavailable with a helpful error message.
          3. Call OpenWeatherMap with city name + key + units.
          4. On network failure → 502 Bad Gateway.
          5. On non-200 from OpenWeather → 502 with status and truncated body.
          6. On success → trim the large upstream JSON to a small, stable shape.
        """

        # --- Step 1: configuration from the environment ---
        key = os.environ.get("OPENWEATHER_API_KEY", "").strip()
        if not key:
            # 503 = "I can't do this job right now" (misconfiguration, not user error).
            return (
                jsonify(
                    {
                        "error": "OPENWEATHER_API_KEY is not configured",
                        "hint": "Set the secret in Kubernetes or export it locally.",
                    }
                ),
                503,
            )

        # Defaults: London and metric (°C) unless WEATHER_CITY / WEATHER_UNITS are set.
        city = os.environ.get("WEATHER_CITY", "London").strip() or "London"
        units = os.environ.get("WEATHER_UNITS", "metric").strip() or "metric"

        # OpenWeather expects: city name, appid (API key), and units (metric/imperial).
        params = {"q": city, "appid": key, "units": units}

        # --- Step 2: call the external weather service ---
        try:
            r = requests.get(OPENWEATHER_URL, params=params, timeout=10)
            # timeout=10 seconds: don't hang forever if OpenWeather is slow or down.
        except requests.RequestException as exc:
            # DNS failure, connection refused, timeout, etc.
            return jsonify({"error": "upstream_request_failed", "detail": str(exc)}), 502

        if r.status_code != 200:
            # OpenWeather returned an error (bad city, invalid key, rate limit, etc.).
            return (
                jsonify(
                    {
                        "error": "openweather_error",
                        "status": r.status_code,
                        "body": r.text[:500],
                    }
                ),
                502,
            )

        # --- Step 3: parse and simplify the response ---
        data = r.json()
        main = data.get("main") or {}  # temperature, humidity, pressure, etc.
        weather = (data.get("weather") or [{}])[0]  # description, icon — first item in list

        return (
            jsonify(
                {
                    "city": data.get("name"),
                    "country": (data.get("sys") or {}).get("country"),
                    "description": weather.get("description"),
                    "temp_c": main.get("temp") if units == "metric" else None,
                    "temp": main.get("temp"),
                    "units": units,
                    "humidity": main.get("humidity"),
                }
            ),
            200,
        )

    return app


# Module-level app instance — Gunicorn imports this as `app:app` (module:variable).
app = create_app()
