# ==============================================================================
# PROJECT: R for Data Science Technical Refinement
# MODULE:  Chapter 4 - Workflow: Code Style (Standardization & Validation)
# AUTHOR:  Nate Vavrock
# LICENSE: MIT License (c) 2026 Nate Vavrock. See root LICENSE for terms.
# ==============================================================================

# ---- 1.0 Environment Setup ---------------------------------------------------
library(nycflights13)
library(tidyverse)

# ---- 2.0 Feature Engineering (The "Back Pocket" Engine) ----------------------
# Standard: Vertical Assignment Alignment and Cyclic Normalization.
# Logic: Using %% 24 to wrap '2400' midnight departures into the '0' hour block.
# ------------------------------------------------------------------------------
flights_standardized <- flights |> 
  filter(!is.na(dep_time)) |> 
  mutate(
    dep_hour   = (dep_time %/% 100) %% 24,
    dep_min    = dep_time %% 100,
    sched_hour = (sched_dep_time %/% 100) %% 24,
    sched_min  = sched_dep_time %% 100,
    .keep      = "used" 
  )

# ---- 3.0 Tabular Verification ------------------------------------------------
# Standard: Exporting a verification subset for "Data/Visual Parity."
# ------------------------------------------------------------------------------
write_csv(
  x    = head(flights_standardized, 100),
  file = "ch4_workflow_style/ch4_time_standardization_verification.csv"
)

# ---- 4.0 Performance Analytics -----------------------------------------------
# Logic: Aggregating by hour with normalized 0-23 range.
# ------------------------------------------------------------------------------
hourly_performance <- flights_standardized |> 
  group_by(dep_hour) |> 
  summarize(
    avg_delay     = mean(dep_min, na.rm = TRUE),
    flight_count  = n(),
    .groups       = "drop"
  )

# ---- 5.0 Visualization -------------------------------------------------------
# Standard: Explicit argument-per-line and high-resolution serialization.
# ------------------------------------------------------------------------------
performance_viz <- hourly_performance |> 
  ggplot(aes(x = dep_hour, y = avg_delay)) +
  geom_line(color = "#0072B2", linewidth = 1) +
  geom_point(color = "#0072B2", size = 2) +
  scale_x_continuous(breaks = seq(0, 23, by = 2)) + 
  labs(
    title    = "Intra-Hour Departure Variance",
    subtitle = "Standardized cyclic time decomposition (NYC 2013)",
    x        = "Hour of Departure (0-23)",
    y        = "Average Minute Component of Departure",
    caption  = "Nate Standard: Cyclic Normalization & Style Validation"
  ) +
  theme_minimal()

ggsave(
  filename = "ch4_workflow_style/standardized_performance.png",
  plot     = performance_viz,
  width    = 8,
  height   = 4,
  dpi      = 300
)