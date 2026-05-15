# Observability (Prometheus + Grafana)

This folder documents how to add **cluster metrics** and **application metrics** for the weather dashboard after K3s is running.

## Prerequisites

- `kubectl` configured against your K3s cluster
- [Helm](https://helm.sh/) v3

## Install kube-prometheus-stack

Pick a Helm release name (examples below use **`prom`**). Install the chart:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

helm upgrade --install prom prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.service.type=LoadBalancer
```

> On K3s you can also port-forward Grafana instead of creating a cloud load balancer:
>
> ```bash
> kubectl -n monitoring port-forward svc/prom-grafana 3000:80
> ```

Default Grafana credentials are often `admin` / `prom-operator` (see chart notes for your release).

## Scrape the Flask `/metrics` endpoint

The Prometheus Operator CRDs must exist **before** you apply the `ServiceMonitor`.

1. Ensure the app is deployed (`kubectl get pods -l app=weather-dashboard`).
2. Align the `release` label on [`../k8s/servicemonitor.yaml`](../k8s/servicemonitor.yaml) with your Helm release name (`prom` → label `release: prom` if that is how your chart instance is labeled). The chart commonly sets `release: <helm-release-name>` on Prometheus CRs.
3. Apply:

```bash
kubectl apply -f cicd/weather-dashboard/k8s/servicemonitor.yaml
```

If Prometheus does not pick up the `ServiceMonitor`, inspect Prometheus CR selectors in the `monitoring` namespace and adjust labels accordingly.

## OpenWeather API key in the cluster

Create a Kubernetes Secret referenced by the Deployment:

```bash
kubectl create secret generic weather-openweather \
  --from-literal=OPENWEATHER_API_KEY="$OPENWEATHER_API_KEY"
```

Then restart the deployment:

```bash
kubectl rollout restart deployment/weather-dashboard
```

## Grafana dashboard import

Import [`grafana-dashboard-weather.json`](grafana-dashboard-weather.json) via **Dashboards → Import** in Grafana.

The dashboard expects Prometheus metrics emitted by the Flask app:

- `weather_http_requests_total`
- `weather_http_request_duration_seconds_bucket` (histogram)
