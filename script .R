#___________________-----
# Setup-----

# I really love R----
########### BIO DSB workshop ----
a <- 1
b <- 2
c <- 3
#___________----------
#MODEL DECISIONS----
library(ggplot2) # creat elegant data visualisations


########### Introduction-----


########## Body 
######## Facts and Figures 
######________Conclusion_______
#####
# I really love R
# _______________----

# 📦 PACKAGES ----

library(ggplot2) # create elegant data visualisations
library(palmerpenguins) # Palmer Archipelago Penguin Data

# ______________----
# DATA VISUAL ----

plot_1 <- ggplot(data = penguins, # calls ggplot function, data is penguins
                 aes(x = bill_length_mm, # sets x axis as bill length
                     y = bill_depth_mm)) + # sets y axis value as bill depth
  geom_point(aes(colour=species)) # geometric to plot

# ______________----

plot_1 <-b
  