# ==============================================================================
# PROJECT: R for Data Science Technical Refinement
# MODULE:  Chapter 3 - Data Visualization (Performance Dashboard)
# AUTHOR:  Nate Vavrock
# LICENSE: MIT License (c) 2026 Nate Vavrock. See root LICENSE for terms.
# SOURCE:  Derived from foundational logic by Wickham et al. (R4DS 2e)
# ==============================================================================

library(tidyverse)

# ------------------------------------------------------------------------------
# DATA INGESTION & RELATIONAL JOIN
# Standard: Importing refined artifacts and merging with relational metadata.
# Logic: 'left_join' ensures that performance metrics are enriched with 
# human-readable carrier names without losing flight data integrity.
# ------------------------------------------------------------------------------
efficiency_data <- read_csv("ch3_data_transformation/top_carrier_efficiency.csv") |> 
  left_join(read_csv("ch3_data_transformation/carrier_metadata.csv"), by = "carrier")

# ------------------------------------------------------------------------------
# DATA VISUALIZATION SPECIFICATIONS
# Standard: Universal Design / High-Contrast / Ordinal Performance Benchmarking
# Refinement: Utilize fct_reorder on legal names to maximize stakeholder readability.
# ------------------------------------------------------------------------------
performance_plot <- efficiency_data |> 
  mutate(name = fct_reorder(name, avg_gain)) |> 
  ggplot(aes(x = avg_gain, y = name)) +
  
  # Structural Component: Vertical Bar Layer
  # Color Specification: #0072B2 (Color-Blind Friendly Blue - Okabe-Ito Palette)
  geom_col(fill = "#0072B2") + 
  
  # Semantic Documentation
  labs(
    title = "Flight Performance: Time Recovery by Carrier",
    subtitle = "Average minutes recovered in-flight (NYC Departures, 2013)",
    x = "Average Minutes Gained (Departure Delay - Arrival Delay)",
    y = "Carrier",
    caption = "Data Source: nycflights13 | Metadata: carrier_metadata.csv\nRefinement & Engineering: Nate Vavrock"
  ) +
  
  # Aesthetic Standards: High-Contrast Minimalist Interface
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", color = "#000000"),
    axis.text = element_text(color = "#000000"),
    plot.caption = element_text(face = "italic", size = 8)
  )

# ------------------------------------------------------------------------------
# ARTIFACT SERIALIZATION
# Output: High-resolution rasterization (300 DPI) for technical documentation.
# ------------------------------------------------------------------------------
ggsave(
  filename = "ch3_data_transformation/carrier_performance_viz.png",
  plot = performance_plot,
  width = 9, # Expanded width to accommodate full airline names
  height = 6, 
  dpi = 300
)