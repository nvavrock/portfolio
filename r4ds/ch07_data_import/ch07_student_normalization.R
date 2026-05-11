# ==============================================================================
# PROJECT: R for Data Science Technical Refinement
# MODULE:  Chapter 07 - Data Import (Student Enrollment Normalization)
# AUTHOR:  Nate Vavrock
# GUARDRAILS: Architectural Foundation | Interface Standards | Output
# ==============================================================================

library(tidyverse)
library(janitor)

# ---- I. ARCHITECTURAL FOUNDATION (The Logic) ---------------------------------
# Guardrail 2: Engineering Rigor
# Logic: Using the local ch07_students.csv. No skip is required because the 
#        file begins directly with the header row. 

students_raw <- readr::read_csv(
  file = "ch07_data_import/ch07_students.csv",
  na   = c("NA", "N/A", "", "five") # 'five' included to handle age coercion
)

# ---- II. THE NATE STANDARD (The Interface) -----------------------------------
# Guardrail 3: Vertical Alignment of '='
# Logic: janitor::clean_names() ensures 'meal_plan' is available for mutation.

students_refined <- students_raw |> 
  janitor::clean_names() |> 
  dplyr::mutate(
    meal_plan = factor(meal_plan),
    age       = as.integer(age),
    full_name = stringr::str_to_title(full_name)
  )
  # |> 
  # dplyr::filter(!is.na(age)) ### This line has been comment out because age
                               ### has no effect on the production.png. We know
                               ### each student is a student because of the id.
                               ### Guardrails [2:3] have been updated to fix
                               ### this problem.
  
  
# ---- III. ARTIFACT & OUTPUT (The Deliverables) -------------------------------
# Guardrail 6 & 8: Contrast Standard | Source Annotation

production_plot <- students_refined |> 
  ggplot2::ggplot(aes(x = meal_plan, fill = meal_plan)) +
  ggplot2::geom_bar(show.legend = FALSE) +
  # Okabe-Ito Palette: Vermillion (#D55E00) for high contrast
  ggplot2::scale_fill_manual(values = c("#D55E00", "#56B4E9", "#009E73")) +
  ggplot2::labs(
    title    = "Student Enrollment: Meal Plan Distribution",
    subtitle = "Normalized administrative data analysis",
    x        = "Assigned Meal Plan",
    y        = "Student Count",
    # Guardrail 8: Strictly formatted Source | Name
    caption  = "Source: R4DS Student CSV Repository | Nate Vavrock"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title   = element_text(face = "bold", size = 14),
    plot.caption = element_text(face = "italic", color = "grey30")
  )

# ---- IV. SERIALIZATION -------------------------------------------------------
# Guardrail 9: Mandatory Exit Logic using ch07 notation

# Export high-resolution production asset
ggplot2::ggsave(
  filename = "ch07_data_import/student_enrollment_production.png", 
  plot     = production_plot, 
  dpi      = 300
)

# Export refined dataset
readr::write_csv(students_refined, "ch07_data_import/ch07_normalized_students.csv")