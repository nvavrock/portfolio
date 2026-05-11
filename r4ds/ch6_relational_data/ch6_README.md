# Module 6: Advanced Data Tidying (Clinical Translation)

## Objective
To implement advanced **Data Tidying** protocols with a specific emphasis on **Semantic Decoding** of clinical Tuberculosis (TB) identifiers into stakeholder-ready intelligence.

## Engineering Standards

### 1. Semantic Decoding (Guardrail 5)
* **Tactic**: Technical clinical identifiers (`sp`, `sn`, `ep`, `rel`) have been programmatically mapped to professional terminology using `dplyr::case_match`.
* **Logic**: This prevents "shorthand leaks" where raw data codes compromise the readability of production-ready assets.
* **Mappings**:
    * `sp` -> "Smear Positive"
    * `sn` -> "Smear Negative"
    * `ep` -> "Extrapulmonary"
    * `rel` -> "Relapse"

### 2. Structural Normalization
* **Decomposition**: Utilized `tidyr::pivot_longer` with `names_sep = "_"` to split multi-variable column headers into `method`, `gender`, and `age`.
* **Regex Refinement**: Age cohorts were standardized using string replacement to ensure consistent hyphenation (e.g., transforming `014` to `0-14`).

## Artifact Inventory
| Artifact Name | Technical Function |
| :--- | :--- |
| `ch6_translated_tb.csv` | Normalized and semantically decoded TB dataset. |
| `tb_clinical_production.png` | Production Asset featuring domain-specific labeling and mandatory source annotation. |

## Production Metrics
* **Visual Standards**: Utilizes high-contrast **Vermillion (#D55E00)** and **Sky Blue (#56B4E9)** for gender-based differentiation.
* **Data Lineage**: Mandatory caption included: "Source: WHO Global Tuberculosis Report | Nate Vavrock".