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

---

## Repository Roadmap

### [Ch 1: Visualization Refinement](./ch1_penguin_dimensions/)
* **Objective:** Expanding the `palmerpenguins` analysis.
* **Key Improvement:** Implemented disaggregated regression layers to address Simpson’s Paradox and automated CSV serialization logic.

### [Ch 2: Environmental Hardening](./ch2_workflows/)
* **Objective:** Establishing Operational Standards.
* **Key Improvement:** Hard-coded IDE configurations for native piping and established a POSIX-compliant naming architecture.

### [Ch 3: The Flight Performance Engine](./ch3_data_transformation/)
* **Objective:** Engineering high-integrity metrics from `nycflights13`.
* **Key Improvement:** Developed a normalized "Time Recovery Index" and a defensive pipeline for carrier-level performance auditing.

---

## Technical Stack
* **Language:** R 4.x+
* **Framework:** Tidyverse (Extended)
* **Standards:** MIT License with full attribution to original authors.

---
**Lead Engineer:** Nate Vavrock  
**Source:** [R for Data Science, 2nd Edition](https://r4ds.hadley.nz/)
