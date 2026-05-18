"""
Pytest shared setup for weather-dashboard tests.

Pytest is a test runner: it finds functions named test_* and runs them automatically.
This file defines a "fixture" — reusable test setup that runs before each test.
"""

import pytest

# pytest = testing framework; provides fixtures, assertions, and discovery.
from app import app as flask_app

# Import the real Flask application from app.py (same object Gunicorn serves).


@pytest.fixture()
def client():
    """
    Provides a fake web browser (test client) that talks to the app in-memory.

    No real network port is opened; requests go directly to Flask's routing.
    TESTING=True disables some production-only behaviors and enables test helpers.
    """
    flask_app.config["TESTING"] = True
    with flask_app.test_client() as test_client:
        yield test_client
        # `yield` hands test_client to each test function, then runs cleanup after.
