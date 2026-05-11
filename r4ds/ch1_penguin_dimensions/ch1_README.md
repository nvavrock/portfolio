# README: R for Data Science ??? Systematic Review and Iterative Refinement

## Project Overview
This repository documents a secondary, systematic review of the **R for Data Science (R4DS)** curriculum. The objective of this iterative learning process is to reconstruct foundational data visualizations while implementing advanced technical refinements, improved accessibility standards, and a more rigorous coding architecture.

---

## Technical Specification: `ch1_penguin_dimensions_viz.R`
The primary script analyzes morphological correlations in the `palmerpenguins` dataset. This version supersedes prior iterations by incorporating the following technical enhancements:

### 1. Data Sanitization and Integrity
Initial execution identified two observations with null values (`NA`) for primary morphological variables, triggering "non-finite" system warnings in the `stat_smooth()` and `geom_point()` layers.
* **Remediation:** In accordance with Chapter 3 (Data Transformation) protocols, a pre-processing filter (`!is.na()`) was implemented.
* **Result:** This structural adjustment suppresses standard R warnings and ensures that statistical regression models are calculated on a technically sound "complete case" subset.

### 2. Optimization of Color Accessibility
To ensure compliance with Universal Design principles for color vision deficiency (CVD), the script utilizes a modified **Okabe-Ito palette**.
* **Exclusion of Yellow Chrominance:** The palette is programmatically subsetted using the index `[-5]` to remove the yellow hex code (`#F0E442`). 
* **Justification:** This prevents low luminance contrast against white backgrounds, ensuring legibility in professional reporting environments.

### 3. Structural Hierarchical Theming
The visual output employs a layered architecture to enforce strict control over visual hierarchy:
* **Theme Inheritance:** The script initializes with `theme_minimal()` to establish a clean baseline.
* **Attribute Overriding:** Custom `theme()` adjustments are placed **last** in the stack to override default values with absolute black (`#000000`) and bold typography.
* **Visual Anchor:** The title includes a bottom margin (`margin(b = 10)`) to improve vertical whitespace and document scannability.

### 4. Statistical Integrity (Simpson???s Paradox)
To address potential misinterpretation of aggregated data trends, the visualization integrates specific layers to clarify group-wise correlations:
* **Alpha Blending:** `alpha = 0.7` is implemented to manage overplotting and show data density.
* **Grouped Regression:** The use of `geom_smooth(method = "lm")` per species demonstrates that positive correlations emerge only when the data is disaggregated.


### 5. Automated Directory & File Management
The script implements a robust data-handling pipeline to ensure portability and artifact integrity:
* **Directory Initialization:** It utilizes `dir.exists()` and `dir.create()` to ensure the `data_exports` folder is present.
* **Serialization:** Data is exported to `penguins_data.csv` using the `write_csv()` protocol.
* **Migration Logic:** The script automates a file transfer to the centralized project directory: `C:/Users/me/rStudio/r_for_data_science`.
* **Version Currency:** The `file.copy()` operation utilizes the `overwrite = TRUE` parameter to ensure artifact currency.

---

## Methodology and Justification
This "Back to Basics" approach facilitates the transition from functional proficiency to **technical mastery**. By revisiting foundational chapters with a deeper understanding of the `ggplot2` grammar and filesystem operations, this project produces codebases that are robust, accessible, and optimized for professional data pipelines.

---

## Repository Structure
* `ch1_penguin_dimensions_viz.R`: Primary visualization and data migration script.
* `ch1_README.md`: Technical documentation and project methodology.
* `penguins_data.csv`: Standardized data artifact generated for cross-platform accessibility and auditing.

## Dependencies
* `ggplot2`
* `palmerpenguins`
* `ggthemes`
* `readr` (for CSV serialization)