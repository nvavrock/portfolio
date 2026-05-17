# =============================================================================
# Weather Dashboard — Dockerfile (recipe for a portable app container)
# =============================================================================
#
# A Dockerfile is step-by-step instructions for Docker to build an "image"
# (a frozen snapshot). Kubernetes (or `docker run`) then starts "containers"
# from that image — each container is a running copy of your app in a small,
# isolated Linux environment.
#
# This file uses a "multi-stage" build: two temporary kitchens (stages),
# but only the final plate (runtime image) is served to production. The first
# stage installs Python packages; the second stage copies only what we need,
# keeping the final image smaller and safer.
#
# Build example (from weather-dashboard/):
#   docker build -t weather-dashboard:latest .
#
# Run example:
#   docker run --rm -p 8080:8080 \
#     -e OPENWEATHER_API_KEY=your_key_here \
#     weather-dashboard:latest
# =============================================================================

# Tell Docker which Dockerfile syntax version to use (enables newer features).
# syntax=docker/dockerfile:1

# -----------------------------------------------------------------------------
# STAGE 1: "builder" — install Python dependencies into a virtual environment
# -----------------------------------------------------------------------------
# We name this stage "builder" so stage 2 can copy files from it with
# COPY --from=builder ...

FROM python:3.12-slim AS builder
# FROM = start from an official base image.
# python:3.12-slim = Debian-based Linux with Python 3.12, minus extra bulk.
# AS builder = label this stage so we can refer to it later.

WORKDIR /build
# WORKDIR = "cd" into this folder inside the container for following steps.
# All RUN/COPY commands below happen relative to /build.

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
# ENV = environment variables inside the image.
# PYTHONDONTWRITEBYTECODE=1 → don't write .pyc bytecode files (slightly smaller image).
# PYTHONUNBUFFERED=1 → print logs immediately (important for `docker logs` / kubectl logs).

RUN python -m venv /venv
# Create a virtual environment at /venv — an isolated folder of Python packages.
# This keeps our app's libraries separate from the system Python.

ENV PATH="/venv/bin:${PATH}"
# Put /venv/bin first on PATH so `pip` and `python` use the venv, not system Python.

COPY app/requirements.txt .
# Copy ONLY requirements.txt first (not the whole app yet).
# Docker caches layers: if requirements.txt hasn't changed, Docker can skip
# re-running pip install on the next build — faster rebuilds when you only
# change app.py.

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt
# pip install reads requirements.txt and downloads:
#   flask, gunicorn, requests, prometheus-client
# --no-cache-dir = don't keep pip's download cache (smaller image).
# Everything lands in /venv — ready to copy to the runtime stage.

# -----------------------------------------------------------------------------
# STAGE 2: "runtime" — lean image that actually runs the web server
# -----------------------------------------------------------------------------
# We start fresh from python:3.12-slim again (we do NOT continue from builder's
# filesystem except for the /venv folder we explicitly copy). That drops build
# tools and pip caches from the final image.

FROM python:3.12-slim AS runtime

WORKDIR /app
# Application files will live under /app in the final container.

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/venv/bin:${PATH}"
# Same Python env vars as builder, and same PATH so gunicorn/python find /venv.

RUN useradd --create-home --uid 10001 --shell /usr/sbin/nologin appuser
# Security: create a non-root Linux user "appuser" (UID 10001).
# Containers should not run as root in production — limits damage if compromised.
# --shell /usr/sbin/nologin = this account cannot SSH/login interactively.

COPY --from=builder /venv /venv
# Multi-stage magic: copy the entire virtualenv from the builder stage.
# We get all installed packages without keeping pip, build caches, or temp files.

COPY app/ ./app/
# Copy our application source (app.py, requirements.txt, tests/, etc.) into /app/app/.
# Note: requirements.txt is copied again here for reference; runtime uses /venv from builder.

USER appuser
# From here on, every process in this image runs as appuser, not root.

EXPOSE 8080
# Documentation for humans/tools: this container listens on port 8080.
# EXPOSE does not publish the port on your host by itself — you still need
# `docker run -p 8080:8080` or a Kubernetes Service to reach it from outside.

WORKDIR /app/app
# Gunicorn will run from the directory that contains app.py.
# The module path "app:app" below means: file app.py, variable named app.

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "4", "app:app"]
# CMD = default command when a container starts (can be overridden in K8s).
#
# gunicorn     = production WSGI server (handles many HTTP connections).
# --bind 0.0.0.0:8080 = listen on all interfaces inside the container, port 8080.
# --workers 2  = two worker processes (use multiple CPU cores / isolate crashes).
# --threads 4  = up to 4 threads per worker for concurrent requests.
# app:app      = import the Flask app from app.py (module "app", object "app").
#
# At runtime you still need OPENWEATHER_API_KEY (and optional WEATHER_CITY)
# passed in via -e flags, docker-compose, or Kubernetes secrets — the Dockerfile
# does not embed secrets (that would be unsafe and bad practice).
