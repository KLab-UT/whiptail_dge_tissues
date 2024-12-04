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

#             dat <- read.csv("~/Downloads/combined_variants.csv")
#             
#             # lm_results <- lm(DeltaAD~GeneType, data = dat)
#             
#             dat_boxplots <- ggplot(dat, aes(x = GeneType, y = DeltaAD)) +
#               geom_boxplot(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
#               labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
#                    x = "Gene Type",
#                    y = "Allele-biased Expression") +
#               coord_cartesian(ylim = c(-200, 250)) +  # Set minimum y-axis limit to -10000
#               theme_classic() +
#               theme(
#                 legend.position = "none",        # Remove the legend
#                 axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
#                 axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
#                 axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
#                 plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
#               )
#             dat_boxplots
#             
#             ggsave("../3_MITO_DGE/Figures/dat_boxplots.png", plot = dat_boxplots, width = 6, height = 8, dpi = 300)
#             
#             
#             dat_Mt <- dat[dat$GeneType %in% c("Mito"), ]
#             dat_NonMt <- dat[dat$GeneType %in% c("Other"), ]
#             
#             dat_Mt_distributions <- ggplot(dat_Mt) +
#               geom_density(aes(x = log(RefAD), fill = "RefAD"), color = "black", alpha = 0.5) +
#               geom_density(aes(x = log(AltAD), fill = "AltAD"), color = "black", alpha = 0.5) +
#               xlim(0, 8) +
#               ylim(0, 0.68) +
#               scale_fill_manual(values = c("RefAD" = "#00D8C4", "AltAD" = "#FFE812")) +  # Custom colors
#               labs(title = "Overlay of Mito RefAD and AltAD Distributions", x = "Value", y = "Density", fill = "Legend") +
#               theme_classic() +
#               theme(
#                 legend.position = "none",        # Remove the legend
#                 axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
#                 axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
#                 axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size (though x-axis title is removed)
#               )
#             
#             ggsave("../3_MITO_DGE/Figures/dat_Mt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)
#             
#             dat_NonMt_distributions <- ggplot(dat_NonMt) +
#               geom_density(aes(x = log(RefAD), fill = "RefAD"), color = "black", alpha = 0.5) +
#               geom_density(aes(x = log(AltAD), fill = "AltAD"), color = "black", alpha = 0.5) +
#               xlim(0, 8) +
#               ylim(0, 0.68) +
#               scale_fill_manual(values = c("RefAD" = "#00D8C4", "AltAD" = "#FFE812")) +  # Custom colors
#               labs(title = "Overlay of Non-Mito RefAD and AltAD Distributions", x = "Value", y = "Density", fill = "Legend") +
#               theme_classic() +
#               theme(
#                 legend.position = "none",        # Remove the legend
#                 axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
#                 axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
#                 axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size (though x-axis title is removed)
#               )
#             
#             ggsave("../3_MITO_DGE/Figures/dat_NonMt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)
#             
#             dat_paneled <- grid.arrange(dat_boxplots + labs(x = NULL, title = NULL), dat_NonMt_distributions + labs(x = "Allele Depth", title = NULL), dat_Mt_distributions + labs(x = "Allele Depth", title = NULL), ncol = 3)
#             ggsave("../3_MITO_DGE/Figures/dat_paneled.png", plot = dat_paneled, width = 18, height = 8, dpi = 300)
#             
#             
#             dat_tissue_boxplots <- ggplot(dat, aes(x = Tissue, y = DeltaAD)) +
#               geom_boxplot(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
#               labs(title = "Boxplot with Distribution of DeltaAD by Tissue",
#                    x = "Tissue",
#                    y = "Maternal-biased Expression") +
#               coord_cartesian(ylim = c(-200, 250)) +  # Set minimum y-axis limit to -10000
#               theme_classic() +
#               theme(
#                 legend.position = "none",        # Remove the legend
#                 axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
#                 axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
#                 axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
#                 plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
#               )
#             dat_tissue_boxplots
#             ggsave("../3_MITO_DGE/Figures/dat_tissue_boxplots.png", plot = dat_tissue_boxplots, width = 6, height = 8, dpi = 300)


#lm_results <- lm(DeltaAD~Interaction_Binary, data = dat_Mt)

dat_interactions <- read.csv("../BioGrid_Interactions/final_interactions_with_type.csv")
dat_interactions <- dat_interactions %>%
  mutate(Interaction_Binary = ifelse(Interaction_Binary == 1, "Interacting", "Non-Interacting"))


dat_interactions_jitter <- ggplot(dat_interactions, aes(x = Interaction_Binary, y = DeltaAD)) +
  geom_jitter(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
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

ggsave("../3_MITO_DGE/Figures/dat_interactions_jitter.png", plot = dat_interactions_jitter, width = 6, height = 8, dpi = 300)

# Compare different types of interacting genes
dat_intertype  <- dat_interactions[dat_interactions$Interaction_Type != "", ]


# lm_results <- lm(DeltaAD~Interaction_Type, data = dat_Interact)

dat_intertype_jitter <- ggplot(dat_intertype , aes(x = Interaction_Type, y = DeltaAD)) +
  geom_jitter(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
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


# lm_results <- lm(DeltaAD~SubLocalization, data = dat_P)

dat_subloc_jitter <- ggplot(dat_subloc, aes(x = SubLocalization, y = DeltaAD)) +
  geom_jitter(fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
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


mt_paneled <- grid.arrange(dat_interactions_jitter + labs(x = NULL, title = NULL), dat_intertype_jitter + labs(x = "Allele Depth", title = NULL), dat_subloc_jitter + labs(x = "Allele Depth", title = NULL), ncol = 3)

ggsave("../3_MITO_DGE/Figures/mt_paneled.png", plot = mt_paneled, width = 18, height = 8, dpi = 300)
