"""
Tests for simple, always-available endpoints (no external API calls).

These run in CI or locally with: pytest
(from weather-dashboard/, with app/ on PYTHONPATH — see pyproject.toml)
"""


def test_healthz(client):
    """/healthz is what Kubernetes uses to ask: "Is this pod alive and ready?"

    We expect HTTP 200 and a tiny JSON body {"status": "ok"}.
    """
    resp = client.get("/healthz")
    assert resp.status_code == 200
    assert resp.json == {"status": "ok"}


def test_index(client):
    """The home page at / should load and mention the app name in the HTML.

    We check raw bytes (b"...") because / returns HTML, not JSON.
    """
    resp = client.get("/")
    assert resp.status_code == 200
    assert b"Weather dashboard" in resp.data
