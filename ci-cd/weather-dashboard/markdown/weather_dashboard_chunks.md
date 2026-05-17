# Weather Dashboard Pipeline Breakdown

There isn’t a “10 equal parts” definition in the repo itself — `cicd_pipeline.md` and `project_sketch.md` describe 5 phases. Below is a sensible 10-step timeline for the full weather-dashboard pipeline, and where **chunk 1** lands in the tree.

---

## How to Read “10 Equal Parts”

Treat the end-to-end flow as **10 sequential slices** (~10% each). Chunk 1 is the **origin of the pipeline**: the thing that exists before CI, containers, cloud, or K8s run.

| Chunk | Stage | Where it lives in `weather-dashboard/` |
| :---: | --- | --- |
| **1** | Application source (pipeline input) | `app/` — especially `app/app.py`, `app/requirements.txt` |
| **2** | Tests / quality gate | `app/tests/`, `pyproject.toml` |
| **3** | Container image definition | `Dockerfile` (repo root) |
| **4** | CI automation (trigger → build → push) | *Not present* — no `.github/workflows/` yet |
| **5** | IaC / cloud VMs | `terraform/` |
| **6** | K3s cluster bootstrap | `scripts/` (`k3s-*-install.sh`, `k3s-bootstrap.md`) |
| **7** | Workload deploy | `k8s/deployment.yaml`, `k8s/service.yaml` |
| **8** | External routing | `k8s/ingress.yaml`, `k8s/kustomization.yaml` |
| **9** | App + cluster metrics wiring | Prometheus metrics in `app/app.py`; `k8s/servicemonitor.yaml` |
| **10** | Dashboards & observability stack | `observability/` |

So **the first chunk is in `weather-dashboard/app/`** — the Flask weather API and HTML shell that everything downstream packages and deploys.

---

## What Chunk 1 Actually Is (Conceptually)

Per your docs, the pipeline starts when **code changes** drive automation:

### `cicd_pipeline.md` (Lines 30-31)
1. **Pipeline Initialization:** The CI/CD process triggers on code changes.
2. **Containerization:** The application is packaged into Docker images.

In the repo today, that “initialization” artifact is **the app source**, not a workflow file:
* **Entry point:** `weather-dashboard/app/app.py`
* **Dependencies:** `weather-dashboard/app/requirements.txt`
* **Tests (next slice):** `weather-dashboard/app/tests/`

`project_sketch.md` calls this step **“Local Dev: Build the app”** — the same position as chunk 1 in the table above.

---

## If You Meant Only the CI/CD Pipeline (Section 1)

Splitting *just* CI/CD into 10 equal steps, chunk 1 would be **“trigger on `git push`”** → typically `.github/workflows/*.yml`. That folder *does not exist* in this repo yet; the nearest implemented stand-in is still `app/` (the code CI would build on push).

### Quick Map
* **Chunk 1 (0–10%)** → `weather-dashboard/app/`
* **Chunk 2 (10–20%)** → `weather-dashboard/app/tests/`
* **Chunk 3 (20–30%)** → `weather-dashboard/Dockerfile`
* **Chunk 4 (30–40%)** → *(missing)* `.github/workflows/`
* ...
* **Chunk 10 (90–100%)** → `weather-dashboard/observability/`

***

*If you had a different “10 parts” scheme in mind (e.g., per the five `cicd_pipeline.md` sections, or a diagram you’re using), say which one and we can remap chunk 1 exactly to that.*
