# README: R for Data Science – Module 3 Technical Refinement

## Project: The Flight Performance Engine (FPE)
This module documents the **Engineering and Refinement** of data transformation and visualization logic derived from Chapter 3. The objective is to establish a defensive data pipeline that converts raw flight observations into a verified **Normalized Recovery Index**.

---

## Technical Specifications
The following standards were enforced to ensure professional-grade reproducibility and analytical rigor:

### 1. Architectural Standardization (Native Syntax)
* **Standard:** Implementation of the native R pipe `|>` for all functional chaining.
* **Logic:** Optimization of the internal R syntax tree to minimize package overhead and ensure future-proof code execution.

### 2. Relational Normalization
* **Standard:** Separation of concerns via a standalone metadata reference ([`carrier_metadata.csv`](./carrier_metadata.csv)).
* **Implementation:** Utilization of `left_join` logic to enrich primary metrics with legal corporate identifiers, ensuring "Don't Repeat Yourself" (DRY) principles are maintained across the repository.

### 3. Metric Engineering: Normalized Recovery Index
* **Calculated Metric:** $Gain = \text{Departure Delay} - \text{Arrival Delay}$
* **Technical Interpretation:** * **Positive Gain:** Represents "Time Recovery" where pilots/dispatch successfully mitigated delays during transit.
    * **Negative Gain:** Represents "Additional Operational Loss," indicating systemic inefficiencies or holding patterns incurred post-departure.

### 4. Accessibility & Universal Design
* **Standard:** Mandatory use of the **Okabe-Ito Palette** for color-blind accessibility.
* **Output:** High-resolution (300 DPI) serialization of the `carrier_performance_viz.png` dashboard.

---

## Artifact Inventory
| Artifact Name | Type | Technical Function |
| :--- | :--- | :--- |
| `ch3_flight_efficiency.R` | Script | Primary transformation pipeline & logic assertions. |
| `ch3_flight_viz.R` | Script | Visualization engine using relational metadata joins. |
| `top_carrier_efficiency.csv` | Data | Serialized performance indices for carrier benchmarking. |
| `carrier_metadata.csv` | Metadata | Relational lookup for legal corporate entities. |
| `carrier_performance_viz.png` | Asset | High-integrity analytic dashboard. |

---

## Technical Reference
For specific corporate entity definitions (e.g., mapping `MQ` to `Envoy Air`), refer to the microdata source in [`carrier_metadata.csv`](./carrier_metadata.csv).

---

## Methodology Reference
Derived from *R for Data Science (2e)*. Hardened and refactored for professional application by Nate Vavrock.