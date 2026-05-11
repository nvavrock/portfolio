library(ggplot2)
library(palmerpenguins)
library(ggthemes)
library(readr)

# Get the full palette and remove the 5th color (yellow)
# The colorblind_pal()(8) is the Okabe-Ito palette; I drop yellow for better contrast
no_yellow <- colorblind_pal()(8)[-5]

ggplot(data = penguins, 
       mapping = aes(x = bill_length_mm, 
                     y = bill_depth_mm, 
                     color = species, 
                     shape = species)) +
  geom_point(alpha = 0.7, size = 2) +          
  geom_smooth(method = "lm", se = FALSE) +     
  scale_color_manual(values = no_yellow) +
  
  # Base theme is called FIRST to set the foundation
  theme_minimal() +  
  
  # Custom theme adjustments are called LAST to override defaults
  theme(
    # 'color = "#000000"' is absolute black (darker than the default grey-black)
    # 'face = "bold"' adds the visual weight
    plot.title = element_text(
      color = "#000000", 
      face = "bold", 
      size = 18, 
      margin = margin(b = 10) # Adds space below title for clarity
    ),
    # Slightly darkening the subtitle to match the theme
    plot.subtitle = element_text(color = "grey10", face = "italic"),
    
    # Darkening axis titles for a cohesive "darker" look
    axis.title = element_text(color = "black", face = "bold")
  ) +
  
  labs(
    title = "Penguin Bill Dimensions by Species",
    subtitle = "Positive correlation emerges when grouped by species",
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = "Species",
    shape = "Species",
    caption = "Source: palmerpenguins R package"  
  )

# Define the directory name
target_dir <- "data_exports"

# Check for existence; if FALSE, create the directory
if (!dir.exists(target_dir)) {
  dir.create(target_dir)
}

# Execute export to the verified directory
write_csv(penguins, file.path(target_dir, "penguins_data.csv"))

# Define the source and the destination
source_file <- "data_exports/penguins_data.csv"
destination_path <- "C:/Users/me/rStudio/r_for_data-science/ch1_penguin_dimensions"

# Perform the copy operation
# 'overwrite = TRUE' ensures it updates if the file already exists there
file.copy(from = source_file, to = destination_path, overwrite = TRUE)
