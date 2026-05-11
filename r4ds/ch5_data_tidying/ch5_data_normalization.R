# ==============================================================================
# PROJECT: R for Data Science Technical Refinement
# MODULE:  Chapter 5 - Data Tidying (Structural Normalization)
# AUTHOR:  Nate Vavrock
# GUARDRAILS: Native Pipe | Vertical Alignment | Validation Logic | Visual Proof
# ==============================================================================

library(tidyverse)

# ---- 1.0 Data Ingestion & Structural Normalization ---------------------------
# Logic: Transforming wide WHO data into a long, machine-operable format.
who_normalized <- tidyr::who2 |> 
  tidyr::pivot_longer(
    cols      = !(country:year),
    names_to  = c("diagnosis", "gender", "age"), 
    names_sep = "_",
    values_to = "count"
  ) |> 
  
  # ---- 2.0 Semantic Refinement (The Nate Standard) ---------------------------
# Logic: Regex-based normalization of age-group strings for readability.
dplyr::filter(!is.na(count)) |> 
  dplyr::mutate(
    age   = stringr::str_replace(age, "^0", "0-"),
    age   = stringr::str_replace(age, "(\\d{2})(\\d{2})", "\\1-\\2"),
    age   = stringr::str_replace(age, "65", "65+"),
    count = as.integer(count)
  )

# ---- 3.0 Visual Integrity Validation -----------------------------------------
# Standard: Fixed scales for magnitude comparison and tilted labels.
normalization_validation_plot <- who_normalized |> 
  dplyr::filter(country %in% c("Afghanistan", "Brazil", "China")) |> 
  ggplot2::ggplot(aes(x = age, y = count, fill = gender)) +
  ggplot2::geom_col() +
  
  # Logic: Fixed scales for Global Scale Verification across facets.
  ggplot2::facet_wrap(~country, scales = "fixed") + 
  
  ggplot2::scale_fill_manual(values = c("#E69F00", "#56B4E9")) + 
  ggplot2::labs(
    title    = "Structural Normalization Validation: WHO Global Health (Tuberculosis cases)",
    subtitle = "Verification of Tidy Data Architecture and Normalized Age-Group Categorization",
    x        = "Normalized Age Cohort",
    y        = "Validated Case Count (Fixed Scale)",
    caption  = "Artifact: ch5_normalized_who.csv | Lead Engineer: Nate Vavrock"
  ) +
  ggplot2::theme_minimal() +
  
  # ---- 3.1 Aesthetic Hardening -----------------------------------------------
# Logic: 45-degree tilt for categorical legibility.
ggplot2::theme(
  axis.text.x      = element_text(angle = 45, vjust = 1, hjust = 1),
  panel.grid.minor = element_blank(),
  plot.title       = element_text(face = "bold", size = 14),
  axis.text        = element_text(color = "#000000")
)

# ---- 4.0 Artifact Exit Logic -------------------------------------------------
# Outcome: Persistent CSV and high-res validation image.
ggplot2::ggsave(
  filename = "ch5_data_tidying/normalization_validation.png",
  plot     = normalization_validation_plot,
  dpi      = 300,
  width    = 10,
  height   = 7
)

readr::write_csv(who_normalized, "ch5_data_tidying/ch5_normalized_who.csv")