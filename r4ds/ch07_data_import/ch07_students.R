students <- read_csv("https://pos.it/r4ds-students-csv", na = c("N/A", ""))

students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )
    
readr::write_csv(students, "ch07_data_import/ch07_students.csv")