# R for Data Science: Technical Refinement & Architectural Hardening

## The Vision: Beyond Syntax
This repository is an intensive **expansion and refinement** of the curriculum presented in **"R for Data Science (2e)" by Hadley Wickham, Mine Çetinkaya-Rundel, and Garrett Grolemund**. 

While the source text provides the foundational "how-to," this project implements a "production-ready" layer—transforming instructional exercises into hardened, defensive, and accessible data engineering pipelines.

---

## Global Engineering Standards
Every module in this repository is built to exceed standard instructional benchmarks through four "Refinement Pillars":

1.  **Modern Syntax (Native Pipe `|>`):** Global transition from `magrittr` to native R piping to reduce overhead and future-proof the codebase.
2.  **Universal Design (Accessibility):** All visualizations are engineered using CVD-safe palettes (modified Okabe-Ito) and high-contrast typography (#000000).
3.  **Defensive Programming:** Implementation of explicit data-integrity checks (NA filtering) and automated filesystem verification (`dir.exists`) to prevent silent failures.
4.  **Reproducibility Hardening:** Strict "No-Persistence" workspace policy to ensure all results are generated programmatically from raw state.

Detailed naming, serialization, and review rules live in [`guardrails.md`](./guardrails.md).

---

## Repository Layout

Chapter work lives in zero-padded directories (`ch01_…` through `ch08_…`) so modules sort cleanly and match the two-digit chapter prefix on artifacts. Each folder holds its own README (or chapter notes), R scripts, and generated data or figures where applicable.

---

## Repository Roadmap

### [Ch 1: Visualization refinement](./ch01_penguin_dimensions/)
* **Objective:** Extend the `palmerpenguins` analysis beyond the textbook baseline.
* **Key improvement:** Disaggregated regression layers (Simpson’s paradox), CVD-safe palette choices, and CSV export with defensive path handling.

### [Ch 2: Environmental hardening](./ch02_workflows_basics/)
* **Objective:** Lock in a reproducible RStudio workflow.
* **Key improvement:** Native pipe by default, no workspace restore, and consistent snake_case layout for cross-machine runs.

### [Ch 3: Flight performance engine](./ch03_data_transformation/)
* **Objective:** Turn `nycflights13` into auditable carrier metrics.
* **Key improvement:** Normalized recovery-style indices, metadata joins, and a high-DPI dashboard with explicit relational lookups.

### [Ch 4: Workflow & style (Nate Standard)](./ch04_workflow_style/)
* **Objective:** Codify style laws for every later module.
* **Key improvement:** Cyclic time extraction (`%/%` / `%%`), vertical alignment, argument-per-line calls, and mandatory CSV plus `ggsave` exits.

### [Ch 5: Data tidying & validation](./ch05_data_tidying/)
* **Objective:** Normalize WHO tuberculosis structure into tidy long form.
* **Key improvement:** Regex-based age cohort labels, fixed-scale validation facets, and paired CSV plus validation figures.

### [Ch 6: Advanced tidying & clinical translation](./ch06_relational_data/)
* **Objective:** Decode clinical TB codes into stakeholder-ready language.
* **Key improvement:** `case_match` semantic mapping, disciplined `pivot_longer`, and production plots with mandatory source captions.

### [Ch 7: Data import & resilient normalization](./ch07_data_import/)
* **Objective:** Import messy external tables without silently dropping valid rows.
* **Key improvement:** Repair-over-removal typing (e.g. string ages to integers) and preserved census integrity for reporting.

### [Ch 8: Workflow & getting help](./ch08_workflow_getting_help/)
* **Objective:** Treat help requests as reproducible communication artifacts.
* **Key improvement:** `reprex`-style minimal examples, native pipe in shared snippets, and explicit `pkg::function()` references.

---

## Technical Stack
* **Language:** R 4.x+
* **Framework:** Tidyverse (Extended)
* **Standards:** MIT License with full attribution to original authors.

---
**Lead Engineer:** Nate Vavrock  
**Source:** [R for Data Science, 2nd Edition](https://r4ds.hadley.nz/)
