# Define useful variable
directory <- '~/Desktop/SpeciesDistributionModeling/Maps'

# Set working directory
setwd(directory)

# Install packages
packages <- c('ggplot2', 'xlsx')
install.packages(packages, dependencies = TRUE)
library(ggplot2)
library(xlsx)

# Import distribution data (column names: 'Taxa', 'DNA.preparation', 'Locality', 'Number.of.specimens', 'Latitude', 'Longitude')
distribution.data <- read.xlsx('~/Desktop/SpeciesDistributionModeling/Maps/DistData_FirstPubli.xlsx', sheetIndex = 2, encoding = 'UTF-8', stringsAsFactors = FALSE, header = TRUE)

# Plot the distribution points on an orthographic equidistant world map
world <- map_data('world')
world.map <- ggplot(world, aes(x = long, y = lat)) + geom_polygon(aes(group = group), alpha = 9.25/10) + scale_y_continuous(breaks = (-2:2) * 30) + scale_x_continuous(breaks = (-4:4) * 45) + theme(panel.background = element_rect(fill = 'grey90')) + coord_equal() + borders(colour = 'grey35')

occurrence_map <- world.map + geom_point(data = distribution.data, 
                                        aes (x = Longitude, y = Latitude,
                                             color = distribution.data$Taxa,
                                             size = 0.05), 
                                        shape = 20,
                                        alpha = 0.7)

orthographic_map <- occurrence_map + coord_map('orthographic', orientation = c(46.25, -7.69, 0))

#orthographic_map <- orthographic_map + scale_colour_manual(values = c('midnightblue', 'lightblue2', 'lawngreen', 'firebrick', 'darkorange2', 'purple', 'yellow')) # Uncomment to change the defaults color of the points

orthographic_map <- orthographic_map + theme(legend.text = element_text(face = 'italic')) # Italicize the scientific names in the legend  

orthographic_map <- orthographic_map + guides(size = FALSE, # Remove size from the legend
                                          color = guide_legend(title = expression(paste(italic('Ecrobia'), ' spp. and outgroups')))) # Define the legend title

orthographic_map <- orthographic_map + labs(x = 'Longitude', y = 'Latitude') # Modify axis labels

orthographic_map

# Save distribution map as pdf
pdf('DistMap.pdf', height = 8.26, width = 14.73, pointsize = 10)
orthographic_map
dev.off()