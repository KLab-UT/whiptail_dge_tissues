library('ggplot2')
library('dplyr')
# Adjust path as needed
setwd('~/Library/CloudStorage/OneDrive-UtahTechUniversity/School/Research/BioGrid_Interactions')
dat <- read.csv("final_interactions_with_type.csv")

lm_results <- lm(DeltaAD~GeneType, data = dat)

dat_boxplots <- ggplot(dat, aes(x = GeneType, y = DeltaAD)) +
  geom_boxplot(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
       x = "Gene Type",
       y = "Allele-biased Expression") +
  coord_cartesian(ylim = c(-200, 250)) +  # Set minimum y-axis limit to -10000
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )
dat_boxplots

ggsave("3_MITO_DGE/Figures/dat_boxplots.png", plot = dat_boxplots, width = 6, height = 8, dpi = 300)

dat_jitterplots <- ggplot(dat, aes(x = GeneType, y = DeltaAD)) +
  geom_jitter(color = "#00D8C4", width = 0.2, size = 2) +  # Jitter plot with custom color and size
  labs(title = "Jitter Plot of DeltaAD by GeneType",
       x = "Gene Type",
       y = "Allele-biased Expression") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )

dat_jitterplots
ggsave("3_MITO_DGE/Figures/dat_jitterplots.png", plot = dat_jitterplots, width = 6, height = 8, dpi = 300)


dat_Mt <- dat[dat$GeneType %in% c("Mito"), ]
dat_NonMt <- dat[dat$GeneType %in% c("Other"), ]

dat_Mt_distributions <- ggplot(dat_Mt) +
  geom_density(aes(x = log(RefAD), fill = "RefAD"), color = "black", alpha = 0.5) +
  geom_density(aes(x = log(AltAD), fill = "AltAD"), color = "black", alpha = 0.5) +
  scale_fill_manual(values = c("RefAD" = "#00D8C4", "AltAD" = "#FFE812")) +  # Custom colors
  labs(title = "Overlay of Mito RefAD and AltAD Distributions", x = "Value", y = "Density", fill = "Legend") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size (though x-axis title is removed)
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%, if there's a title
  )

ggsave("3_MITO_DGE/Figures/dat_Mt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)

dat_Mt_distributions <- ggplot(dat_NonMt) +
  geom_density(aes(x = log(RefAD), fill = "RefAD"), color = "black", alpha = 0.5) +
  geom_density(aes(x = log(AltAD), fill = "AltAD"), color = "black", alpha = 0.5) +
  scale_fill_manual(values = c("RefAD" = "#00D8C4", "AltAD" = "#FFE812")) +  # Custom colors
  labs(title = "Overlay of Non-Mito RefAD and AltAD Distributions", x = "Value", y = "Density", fill = "Legend") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size (though x-axis title is removed)
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%, if there's a title
  )

ggsave("3_MITO_DGE/Figures/dat_NonMt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)


dat_tissue_boxplots <- ggplot(dat, aes(x = Tissue, y = DeltaAD)) +
  geom_boxplot(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by Tissue",
       x = "Tissue",
       y = "Allele-biased Expression") +
  coord_cartesian(ylim = c(-200, 250)) +  # Set minimum y-axis limit to -10000
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )
dat_tissue_boxplots
ggsave("3_MITO_DGE/Figures/dat_tissue_boxplots.png", plot = dat_tissue_boxplots, width = 6, height = 8, dpi = 300)

# Compare mito genes that interact vs those that don't
dat_Mito <- dat[dat$GeneType == "Mito", ]


lm_results <- lm(DeltaAD~Interaction_Binary, data = dat_Mito)

dat_Mito$Interaction_Binary <- as.factor(dat_Mito$Interaction_Binary)
dat_boxplots <- ggplot(dat_Mito, aes(x = Interaction_Binary, y = DeltaAD)) +
  geom_violin(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
       x = "Gene Type",
       y = "Allele-biased Expression") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )
dat_boxplots

# Compare different types of interacting genes
dat_Interact <- dat_subset <- dat[dat$Interaction_Type != "", ]


lm_results <- lm(DeltaAD~Interaction_Type, data = dat_Interact)

dat_boxplots <- ggplot(dat_Interact, aes(x = Interaction_Type, y = DeltaAD)) +
  geom_boxplot(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
       x = "Gene Type",
       y = "Allele-biased Expression") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )
dat_boxplots

# Compare different types of interacting proteins
dat_P <- dat_Interact[dat_Interact$Interaction_Type == "P", ]


lm_results <- lm(DeltaAD~SubLocalization, data = dat_P)

dat_boxplots <- ggplot(dat_P, aes(x = SubLocalization, y = DeltaAD)) +
  geom_boxplot(outlier.shape = NA, fill = "#00D8C4") +  # Add boxplot without outliers
  labs(title = "Boxplot with Distribution of DeltaAD by GeneType",
       x = "Gene Type",
       y = "Allele-biased Expression") +
  theme_classic() +
  theme(
    legend.position = "none",        # Remove the legend
    axis.title.y = element_text(size = 1.5 * 11),  # Increase y-axis title font size by 50%
    axis.text = element_text(size = 1.5 * 11),     # Increase axis text font size by 50%
    axis.title.x = element_text(size = 1.5 * 11),  # Increase x-axis title font size
    plot.title = element_text(size = 1.5 * 14)     # Increase plot title font size by 50%
  )
dat_boxplots
