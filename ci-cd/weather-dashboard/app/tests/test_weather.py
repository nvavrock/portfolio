"""
Tests for /api/weather and /metrics.

We avoid calling the real OpenWeather API in tests by:
  - unsetting OPENWEATHER_API_KEY where we expect a config error, or
  - using unittest.mock to fake requests.get responses.
"""

from unittest.mock import patch

# patch = temporarily replace app.requests.get with a controlled fake function.


def test_api_weather_missing_key(client, monkeypatch):
    """
    If OPENWEATHER_API_KEY is not set, the API must fail clearly (503).

    monkeypatch.delenv removes the variable for this test only.
    """
    monkeypatch.delenv("OPENWEATHER_API_KEY", raising=False)
    resp = client.get("/api/weather")
    assert resp.status_code == 503
    body = resp.get_json()
    assert body is not None
    assert "OPENWEATHER_API_KEY" in body.get("error", "")


@patch("app.requests.get")
def test_api_weather_success(mock_get, client, monkeypatch):
    """
    Happy path: key is set, upstream returns 200, we get trimmed JSON back.

    mock_get.return_value is configured to look like a successful requests.Response.
    """
    monkeypatch.setenv("OPENWEATHER_API_KEY", "test-key")
    monkeypatch.setenv("WEATHER_CITY", "TestCity")

    mock_get.return_value.status_code = 200
    mock_get.return_value.json.return_value = {
        "name": "TestCity",
        "sys": {"country": "TC"},
        "weather": [{"description": "clear sky"}],
        "main": {"temp": 12.3, "humidity": 55},
    }

    resp = client.get("/api/weather")
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["city"] == "TestCity"
    assert data["description"] == "clear sky"
    mock_get.assert_called_once()
    # Ensures we actually tried to call OpenWeather once (not zero or twice).


@patch("app.requests.get")
def test_api_weather_upstream_error(mock_get, client, monkeypatch):
    """
    If OpenWeather returns an error (e.g. 401 bad key), we surface 502 to the client.
    """
    monkeypatch.setenv("OPENWEATHER_API_KEY", "test-key")
    mock_get.return_value.status_code = 401
    mock_get.return_value.text = "invalid key"

    resp = client.get("/api/weather")
    assert resp.status_code == 502
    body = resp.get_json()
    assert body["error"] == "openweather_error"


def test_metrics_exposes_prometheus(client):
    """
    /metrics must be reachable and include our custom counter name.

    Prometheus and ServiceMonitor scrape this path in production.
    """
    resp = client.get("/metrics")
    assert resp.status_code == 200
    assert b"weather_http_requests_total" in resp.data
