from unittest.mock import patch


def test_api_weather_missing_key(client, monkeypatch):
    monkeypatch.delenv("OPENWEATHER_API_KEY", raising=False)
    resp = client.get("/api/weather")
    assert resp.status_code == 503
    body = resp.get_json()
    assert body is not None
    assert "OPENWEATHER_API_KEY" in body.get("error", "")


@patch("app.requests.get")
def test_api_weather_success(mock_get, client, monkeypatch):
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


@patch("app.requests.get")
def test_api_weather_upstream_error(mock_get, client, monkeypatch):
    monkeypatch.setenv("OPENWEATHER_API_KEY", "test-key")
    mock_get.return_value.status_code = 401
    mock_get.return_value.text = "invalid key"

    resp = client.get("/api/weather")
    assert resp.status_code == 502
    body = resp.get_json()
    assert body["error"] == "openweather_error"


def test_metrics_exposes_prometheus(client):
    resp = client.get("/metrics")
    assert resp.status_code == 200
    assert b"weather_http_requests_total" in resp.data
