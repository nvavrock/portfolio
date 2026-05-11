# README: R for Data Science – Module 4 Workflow & Style Validation

## Project: The Nate Standard (Code Integrity)
This module establishes the **Governing Style Laws** for this repository. Beyond the foundational principles of Chapter 4, this project implements "Elite" engineering standards, ensuring all scripts are not just functional, but are high-integrity data products ready for external analysis.

---

## The Nate Style Laws (Operational Guardrails)

### 1. Cyclic Integer Engine (Feature Extraction)
* **Standard:** Mandatory use of integer division `%/%` and modulo `%%`.
* **Logic:** * `time %/% 100`: Isolates the hour component.
    * `time %% 100`: Isolates the minute component.
    * **Advanced Wrap:** `(time %/% 100) %% 24` ensures midnight departures (`2400`) are normalized to the `0` hour block for continuous 24-hour cycle analysis.

### 2. Vertical Alignment (Elastic Tabstops)
* **Standard:** Assignment operators (`=`) within data transformation blocks must be vertically aligned.
* **Logic:** Eliminates visual "noise" and makes typos in complex `mutate` calls immediately obvious to the human eye.

### 3. Argument-Per-Line Rule
* **Standard:** Multi-parameter function calls must place each argument on a new line.
* **Logic:** Facilitates precise Git version control; changes to a single parameter appear as distinct, clean commits in the GitHub history.

### 4. Artifact Exit Logic
* **Standard:** Every analysis script must terminate with a `write_csv()` call.
* **Logic:** To ensure this repository serves as a **Data Provider**, we provide a serialized `.csv` output for every module, allowing downstream users to analyze the refined data without re-running the source code.

---

## Technical Verification & Parity
To verify the **Cyclic Normalization**, this module produces a verification CSV that handles the midnight transition anomaly.

| Raw Integer | Extraction Logic | Resulting Hour |
| :--- | :--- | :--- |
| `0815` | `(815 %/% 100) %% 24` | `8` |
| `2400` | `(2400 %/% 100) %% 24` | `0` |



---

## Artifact Inventory
| Artifact Name | Type | Technical Function |
| :--- | :--- | :--- |
| `ch4_standardized_analysis.R` | Script | Master analysis engine enforcing all style laws. |
| `standardized_flight_times.csv` | Data | **Refined Artifact**: Cleaned time-series data for repository users. |

---

## Compliance Reference
All future modules (beginning with Chapter 5) must adhere to these documented guardrails.

**Lead Engineer:** Nate Vavrock  
**Status:** Standards Finalized.