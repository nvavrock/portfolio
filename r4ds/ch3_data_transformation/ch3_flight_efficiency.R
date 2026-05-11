# ==============================================================================
# PROJECT: R for Data Science Technical Refinement
# MODULE:  Chapter 3 - Data Transformation (Flight Performance Engine)
# AUTHOR:  Nate Vavrock
# LICENSE: MIT License (c) 2026 Nate Vavrock. See root LICENSE for terms.
# SOURCE:  Derived from foundational logic by Wickham et al. (R4DS 2e)
# ==============================================================================

library(nycflights13)
library(tidyverse)

# ------------------------------------------------------------------------------
# DATA EXTRACTION & INTEGRITY CHECK
# Standard: Explicit handling of missing values (NAs) to prevent propagation 
# in statistical summaries.
# ------------------------------------------------------------------------------
performance_validation <- flights |> 
  filter(
    !is.na(dep_delay), 
    !is.na(arr_delay), 
    !is.na(air_time)
  ) |> 
  
  # ------------------------------------------------------------------------------
# FEATURE ENGINEERING: NORMALIZED PERFORMANCE METRICS
# Logic: 'gain' measures the delta between departure and arrival delays.
# Normalization: gain_per_hour accounts for flight duration variance.
# ------------------------------------------------------------------------------
mutate(
  gain = dep_delay - arr_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
) |> 
  
  # ------------------------------------------------------------------------------
# AGGREGATION: CARRIER-LEVEL PERFORMANCE BENCHMARKING
# Standard: Grouped summarization using native pipe architectural transformation.
# ------------------------------------------------------------------------------
group_by(carrier) |> 
  summarize(
    avg_gain      = mean(gain),
    total_flights = n(),
    .groups       = "drop"
  ) |> 
  
  # ------------------------------------------------------------------------------
# OPTIMIZATION: PERFORMANCE RANKING
# Logic: Sort in descending order of average time recovery efficiency.
# ------------------------------------------------------------------------------
arrange(desc(avg_gain))

# ------------------------------------------------------------------------------
# ASSET SERIALIZATION
# Outcome: Persists refined data to high-integrity CSV format.
# ------------------------------------------------------------------------------
write_csv(performance_validation, "ch3_data_transformation/top_carrier_efficiency.csv")