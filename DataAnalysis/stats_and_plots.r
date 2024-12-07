library('ggplot2')
library('dplyr')
library(gridExtra)

# Capture the directory from the command line arguments
 args <- commandArgs(trailingOnly = TRUE)

 # Check if the directory argument is provided
if (length(args) > 0) {
       setwd(args[1])
   cat("Working directory set to:", getwd(), "\n")
    
} else {
       cat("No directory argument provided. Using default working directory:", getwd(), "\n")
 
}

 cat("Current working directory is:", getwd(), "\n")

# ***   dat <- read.csv("~/Downloads/combined_variants.csv")
# ***   
# ***   compute_sampleDAD <- function(ad_str) {
# ***     # Check if AD is not missing
# ***     if (ad_str != "./.") {
# ***       # Split the AD string by comma
# ***       ad_values <- strsplit(ad_str, ",")[[1]]
# ***       # Convert the values to numeric
# ***       ref_allele_depth <- as.numeric(ad_values[1])
# ***       alt_allele_depth <- as.numeric(ad_values[2])
# ***       # Return the difference
# ***       return(ref_allele_depth - alt_allele_depth)
# ***     } else {
# ***       return(NA)  # Return NA for missing AD data
# ***     }
# ***   }
# ***   
# ***   # Apply the function to the 'GT.PL.DP.SP.AD' column and create the 'sampleDAD' column
# ***   dat$sampleDAD <- sapply(dat$GT.PL.DP.SP.AD, function(x) {
# ***     # Extract the AD part (the last value in the string, after the last colon)
# ***     ad_str <- unlist(strsplit(x, ":"))[length(strsplit(x, ":")[[1]])]
# ***     # Compute the sampleDAD value
# ***     compute_sampleDAD(ad_str)
# ***   })
# ***   
# ***   dat_clean <- na.omit(dat)
# ***   
# ***   
# ***   # lm_results <- lm(sampleDAD~GeneType, data = dat)
# ***   dat$GeneType <- factor(dat$GeneType, levels = c("Other", "Mito"))
# ***   cat("Number of rows in the dataframe:", nrow(dat), "\n")
# ***   cat(table(dat$GeneType))
# ***   
# ***   
# ***   
# ***   dat_boxplots <- ggplot(dat, aes(x = GeneType, y = sampleDAD, fill = GeneType)) +
# ***      geom_boxplot(outlier.shape = NA) +  # Add boxplot without outliers
# ***      scale_fill_manual(values = c("Mito" = "#9CC1B4", "Other" = "#386F9C")) +  # Define colors
# ***      labs(title = "Boxplot with Distribution of sampleDAD by GeneType",
# ***           x = "Gene Type",
# ***           y = "Maternal-biased Expression") +
# ***      coord_cartesian(ylim = c(-20, 20)) +  # Set y-axis limits
# ***      theme_classic() +
# ***      theme(
# ***        legend.position = "none",        # Remove the legend
# ***        axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
# ***        axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
# ***        axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
# ***        plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
# ***      )
# ***   
# ***   ggsave("../3_MITO_DGE/Figures/dat_boxplots.png", plot = dat_boxplots, width = 6, height = 8, dpi = 300)
# ***   
# ***   
# ***   dat_Mt <- dat[dat$GeneType %in% c("Mito"), ]
# ***   dat_NonMt <- dat[dat$GeneType %in% c("Other"), ]
# ***   
# ***   dat_Mt_distributions <- ggplot(dat_Mt) +
# ***     geom_density(aes(x = log(RefAD), fill = "RefAD"), color = "black", alpha = 0.5) +
# ***     geom_density(aes(x = log(AltAD), fill = "AltAD"), color = "black", alpha = 0.5) +
# ***     xlim(0, 8) +
# ***     ylim(0, 0.68) +
# ***     scale_fill_manual(values = c("RefAD" = "#E9807D", "AltAD" = "#8AD2F0")) +  # Custom colors
# ***     labs(title = "Overlay of Mito RefAD and AltAD Distributions", x = "Value", y = "Density", fill = "Legend") +
# ***     theme_classic() +
# ***     theme(
# ***       legend.position = "none",        # Remove the legend
# ***       axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
# ***       axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
# ***       axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size (though x-axis title is removed)
# ***     )
# ***   
# ***   ggsave("../3_MITO_DGE/Figures/dat_Mt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)
# ***   
# ***   dat_NonMt_distributions <- ggplot(dat_NonMt) +
# ***     geom_density(aes(x = log(RefAD), fill = "RefAD"), color = "black", alpha = 0.5) +
# ***     geom_density(aes(x = log(AltAD), fill = "AltAD"), color = "black", alpha = 0.5) +
# ***     xlim(0, 8) +
# ***     ylim(0, 0.68) +
# ***     scale_fill_manual(values = c("RefAD" = "#E9807D", "AltAD" = "#8AD2F0")) +  # Custom colors
# ***     labs(title = "Overlay of Non-Mito RefAD and AltAD Distributions", x = "Value", y = "Density", fill = "Legend") +
# ***     theme_classic() +
# ***     theme(
# ***       legend.position = "none",        # Remove the legend
# ***       axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
# ***       axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
# ***       axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size (though x-axis title is removed)
# ***     )
# ***   
# ***   ggsave("../3_MITO_DGE/Figures/dat_NonMt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)
# ***   
# ***   dat_paneled <- grid.arrange(dat_boxplots + labs(x = NULL, title = NULL), dat_NonMt_distributions + labs(x = "Allele Depth", title = NULL), dat_Mt_distributions + labs(x = "Allele Depth", title = NULL), ncol = 3)
# ***   ggsave("../3_MITO_DGE/Figures/dat_paneled.png", plot = dat_paneled, width = 18, height = 8, dpi = 300)


#   dat_tissue_boxplots <- ggplot(dat, aes(x = Tissue, y = sampleDAD)) +
#     geom_boxplot(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
#     labs(title = "Boxplot with Distribution of sampleDAD by Tissue",
#          x = "Tissue",
#          y = "Maternal-biased Expression") +
#     coord_cartesian(ylim = c(-200, 250)) +  # Set minimum y-axis limit to -10000
#     theme_classic() +
#     theme(
#       legend.position = "none",        # Remove the legend
#       axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
#       axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
#       axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
#       plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
#     )
#   dat_tissue_boxplots
#   ggsave("../3_MITO_DGE/Figures/dat_tissue_boxplots.png", plot = dat_tissue_boxplots, width = 6, height = 8, dpi = 300)


#lm_results <- lm(sampleDAD~Interaction_Binary, data = dat_Mt)

dat_interactions <- read.csv("../BioGrid_Interactions/final_interactions_with_type.csv")

# Apply the function to the 'GT.PL.DP.SP.AD' column and create the 'sampleDAD' column
dat_interactions$sampleDAD <- sapply(dat_interactions$GT.PL.DP.SP.AD, function(x) {
  # Extract the AD part (the last value in the string, after the last colon)
  ad_str <- unlist(strsplit(x, ":"))[length(strsplit(x, ":")[[1]])]
  # Compute the sampleDAD value
  compute_sampleDAD(ad_str)
})


interactions_lm <- lm(sampleDAD~Interaction_Binary, data = dat_interactions)


dat_interactions_violin <- ggplot(dat_interactions, aes(x = Interaction_Binary, y = sampleDAD)) +
  geom_violin(fill = "#9CC1B4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of sampleDAD by GeneType",
       x = "Gene Type",
       y = "Maternal-biased Expression") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )

ggsave("../3_MITO_DGE/Figures/dat_interactions_violin.png", plot = dat_interactions_violin, width = 6, height = 8, dpi = 300)

# Compare different types of interacting genes
dat_intertype  <- dat_interactions[dat_interactions$Interaction_Type != "", ]
dat_intertype$Interaction_Type<- factor(dat_intertype$Interaction_Type, levels = c("P", "R", "D"))


# lm_results <- lm(sampleDAD~Interaction_Type, data = dat_Interact)

dat_intertype_jitter <- ggplot(dat_intertype , aes(x = Interaction_Type, y = sampleDAD)) +
  geom_jitter(outlier.shape = NA, colour = "#9CC1B4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of sampleDAD by GeneType",
       x = "Gene Type",
       y = "Maternal-biased Expression") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )

ggsave("../3_MITO_DGE/Figures/dat_intertype_jitter.png", plot = dat_intertype_jitter, width = 6, height = 8, dpi = 300)

# Compare different types of interacting proteins
dat_subloc <- read.csv("../BioGrid_Interactions/final_interactions_with_SubLocalizations.csv")
dat_subloc <- dat_subloc[dat_subloc$Interaction_Type == "P", ]
dat_subloc$SubLocalization<- factor(dat_subloc$SubLocalization, levels = c("MIM", "MOM", "Matrix", "IMS"))

# Apply the function to the 'GT.PL.DP.SP.AD' column and create the 'sampleDAD' column
dat_subloc$sampleDAD <- sapply(dat_subloc$GT.PL.DP.SP.AD, function(x) {
  # Extract the AD part (the last value in the string, after the last colon)
  ad_str <- unlist(strsplit(x, ":"))[length(strsplit(x, ":")[[1]])]
  # Compute the sampleDAD value
  compute_sampleDAD(ad_str)
})

# lm_results <- lm(sampleDAD~SubLocalization, data = dat_P)

dat_subloc_jitter <- ggplot(dat_subloc, aes(x = SubLocalization, y = sampleDAD)) +
  geom_jitter(colour = "#9CC1B4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of sampleDAD by GeneType",
       x = "Gene Type",
       y = "Maternal-biased Expression") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )

ggsave("../3_MITO_DGE/Figures/dat_subloc_jitter.png", plot = dat_subloc_jitter, width = 6, height = 8, dpi = 300)


mt_paneled <- grid.arrange(dat_interactions_violin + labs(x = NULL, title = NULL), dat_intertype_jitter + labs(x = "Interaction Type (see Fig 4)", title = NULL), dat_subloc_jitter + labs(x = "Sublocalization (see Fig 4)", title = NULL), ncol = 3)

ggsave("../3_MITO_DGE/Figures/mt_paneled.png", plot = mt_paneled, width = 18, height = 8, dpi = 300)
