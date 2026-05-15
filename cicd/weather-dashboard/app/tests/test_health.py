def test_healthz(client):
    resp = client.get("/healthz")
    assert resp.status_code == 200
    assert resp.json == {"status": "ok"}


def test_index(client):
    resp = client.get("/")
    assert resp.status_code == 200
    assert b"Weather dashboard" in resp.data
