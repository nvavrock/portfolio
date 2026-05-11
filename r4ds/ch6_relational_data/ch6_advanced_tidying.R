# ==============================================================================
# PROJECT: R for Data Science Technical Refinement
# MODULE:  Chapter 6 - Advanced Data Tidying (Clinical Translation)
# AUTHOR:  Nate Vavrock
# GUARDRAILS: Semantic Decoding | Domain-Specific Labeling
# ==============================================================================

library(tidyverse)

# ---- I. ARCHITECTURAL FOUNDATION ---------------------------------------------
who_translated <- tidyr::who2 |> 
  tidyr::pivot_longer(
    cols      = !(country:year),
    names_to  = c("method", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  ) |> 
  dplyr::filter(!is.na(count)) |> 
  
  # ---- II. THE NATE STANDARD (Guardrail 10: Semantic Decoding) --------------
# Logic: Removing clinical shorthand to satisfy production standards.
dplyr::mutate(
  diagnosis_method = dplyr::case_match(
    method,
    "sp"  ~ "Smear Positive",
    "sn"  ~ "Smear Negative",
    "ep"  ~ "Extrapulmonary",
    "rel" ~ "Relapse"
  ),
  # Guardrail 2: Vertical Alignment
  age = stringr::str_replace(age, "^0", "0-"),
  age = stringr::str_replace(age, "(\\d{2})(\\d{2})", "\\1-\\2"),
  age = stringr::str_replace(age, "65", "65+")
)

# ---- III. PRODUCTION ASSET ---------------------------------------------------
# Guardrail 8: Domain-Specific Labeling (TB Context Included)
production_plot <- who_translated |> 
  dplyr::filter(country %in% c("India", "South Africa", "China")) |> 
  ggplot2::ggplot(aes(x = age, y = count, fill = gender)) +
  ggplot2::geom_col() +
  ggplot2::facet_grid(diagnosis_method ~ country) +
  ggplot2::scale_fill_manual(values = c("#D55E00", "#56B4E9"), name = "Gender") +
  ggplot2::labs(
    title    = "Tuberculosis (TB) Incidence by Clinical Diagnosis Method",
    subtitle = "Decoded analysis of Smear, Extrapulmonary, and Relapse cases",
    x        = "Age Cohort",
    y        = "Total Cases",
    # Guardrail 9: Mandatory Source Annotation
    caption  = "Source: WHO Global Tuberculosis Report | Nate Vavrock"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    strip.text  = element_text(face = "bold") 
  )

# ---- IV. SERIALIZATION -------------------------------------------------------
ggplot2::ggsave("ch6_relational_data/tb_clinical_production.png", production_plot, dpi = 300)
readr::write_csv(who_translated, "ch6_relational_data/ch6_translated_tb.csv")