"""Minimal weather API + HTML shell for the weather-dashboard demo."""

from __future__ import annotations

import 
import time
from typing import Any

import requests
from flask import Flask, Response, jsonify, render_template_string
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest

OPENWEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"

REQUESTS_TOTAL = Counter(
    "weather_http_requests_total",
    "HTTP requests",
    ["handler", "method", "code"],
)
REQUEST_LATENCY_SECONDS = Histogram(
    "weather_http_request_duration_seconds",
    "HTTP request latency",
    ["handler", "method"],
    buckets=(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0),
)

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


def create_app() -> Flask:
    app = Flask(__name__)

    @app.before_request
    def _start_timer() -> None:
        from flask import g

        g._t0 = time.perf_counter()

    @app.after_request
    def _observe(response: Any) -> Any:
        from flask import g, request

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

    @app.get("/healthz")
    def healthz() -> tuple[dict[str, str], int]:
        return {"status": "ok"}, 200

    @app.get("/metrics")
    def metrics() -> Response:
        data = generate_latest()
        return Response(data, mimetype=CONTENT_TYPE_LATEST)

    @app.get("/")
    def index() -> str:
        return render_template_string(INDEX_HTML)

    @app.get("/api/weather")
    def api_weather() -> tuple[Any, int]:
        key = os.environ.get("OPENWEATHER_API_KEY", "").strip()
        if not key:
            return (
                jsonify(
                    {
                        "error": "OPENWEATHER_API_KEY is not configured",
                        "hint": "Set the secret in Kubernetes or export it locally.",
                    }
                ),
                503,
            )

        city = os.environ.get("WEATHER_CITY", "London").strip() or "London"
        units = os.environ.get("WEATHER_UNITS", "metric").strip() or "metric"

        params = {"q": city, "appid": key, "units": units}
        try:
            r = requests.get(OPENWEATHER_URL, params=params, timeout=10)
        except requests.RequestException as exc:
            return jsonify({"error": "upstream_request_failed", "detail": str(exc)}), 502

        if r.status_code != 200:
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

        data = r.json()
        main = data.get("main") or {}
        weather = (data.get("weather") or [{}])[0]
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


app = create_app()
