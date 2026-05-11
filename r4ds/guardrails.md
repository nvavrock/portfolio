# Repository Guardrails: Operational Protocol
**Lead Engineer:** Nate Vavrock  
**Version:** 2.5 (Standardized Serialization & Layman Labeling)

To maintain the **Technical Refinement** standard of the `r-for-data-science` repository, all contributions, scripts, and documentation must adhere to the following operational constraints.

## I. ARCHITECTURAL FOUNDATION (The Logic)
### 1. Syntax & Architecture
* **Zero-Padded Notation:** All directory and file references must use two-digit padding (e.g., `ch06`, `ch07`) to ensure alphanumeric sorting integrity.
* **Native Pipe Mandate:** Exclusively utilize the native R pipe (`|>`). Use of the `magrittr` pipe (`%>%`) is prohibited.
* **Namespace Explicitly:** Use the `pkg::function()` convention for secondary packages.

### 2. Resilient Engineering (Rigor)
* **Defensive Ingestion:** Inspect raw files for metadata. Use `skip = N` only when structural noise precedes the header row.
* **Selective Preservation:** Do not delete entire records due to secondary variable failures. If a Primary Key and Target Variable are valid, the record must be preserved.
* **Type Repair over Deletion:** Structural errors (e.g., `age = "five"`) should be programmatically repaired during the `mutate` phase rather than filtered out.
* **Dynamic Asset Mapping:** Production assets must be derived programmatically from data dimensions (e.g., `length(unique(data))`) to prevent "Dead Code".
* **Vector Slicing:** Color vectors must be sliced to the exact length of data categories (e.g., `palette[1:n]`).

## II. THE NATE STANDARD (The Interface)
### 3. Visual Styling & Accessibility
* **The 2-and-4 Indentation Rule:** Use **2 spaces** for primary pipe levels and **4 spaces** for internal function arguments.
* **Vertical Alignment:** Assignment operators (`=`) within multi-line functions must be vertically aligned.
* **Accessibility Hierarchy:** Plot titles and axis titles must be darkened (`color = "black"`) and bolded (`face = "bold"`) for high contrast.
* **Column Guide Compliance:** Code must respect the 80-character vertical margin.
* **Snake_Case Convention:** All variables and file names must follow `snake_case`.



### 4. Semantic Decoding & Layman Labeling
* **Label Humanization:** Technical shorthand (e.g., `hwy`, `displ`) must be translated into layman terms (e.g., "Highway MPG", "Engine Size") for all production assets.
* **Unit Clarity:** Labels must include the unit suffix (e.g., "300ci" or "2.0L") where applicable.
* **Metadata Standard:** Titles and subtitles must explicitly state the subject matter and reflect dynamic metadata (e.g., "N = 6").

## III. ARTIFACT & OUTPUT (The Deliverables)
### 5. Visual Documentation
* **Ghost Faceting:** For multi-group comparisons, use a background "ghost" layer (the full dataset in grey) to maintain population context.
* **Contrast Standard:** Use the Okabe-Ito palette, prioritizing Vermillion (`#D55E00`) over Yellow for visibility.
* **Serialization:** Production assets must be saved with a `_production` suffix.



### 6. Standardized Serialization
* **Naming Convention:** CSV outputs must be zero-padded and prefixed by the chapter, matching the source dataset name (e.g., `ch09_mpg.csv`).
* **Artifact Exit Logic:** Every script must conclude with a `write_csv()` block and a high-resolution (300 DPI) `ggsave()` block.
* **Directory Scoping:** Save all artifacts within the zero-padded chapter directory.
* **Mandatory Source Annotation:** Every production viz must include a caption formatted as: "Source: [Data Origin] | Nate Vavrock".

---
**Status:** Active | **Approved by:** Nate Vavrock