library(ggplot2)

setwd('/Users/r_klabacka/OneDrive - Utah Tech University/KLab/Research/2023_WhiptailNmtVariation/whiptail_dge_tissues_data')

dat_all <- read.csv('all_variants.csv')

dat_mt <- read.csv('rd_mito_variants_updated.csv')
dat_mt_sites_withdups <- dat_mt %>% select(Chromosome, Position, RefAD, AltAD, DeltaAD, GeneType)
dat_mt_sites <- dat_mt_sites_withdups %>% distinct()

dat_nonmt <- read.csv('rd_no_mito_variants_updated.csv')
dat_nonmt_sites_withdups <-  dat_nonmt %>% select(Chromosome, Position, RefAD, AltAD, DeltaAD, GeneType)
dat_nonmt_sites <- dat_nonmt_sites_withdups %>% distinct()
dat_nonmt_sites$GeneType <- "NonMito"

dat <- rbind(dat_mt_sites, dat_nonmt_sites)

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

ggsave("Figures/dat_boxplots.png", plot = dat_boxplots, width = 6, height = 8, dpi = 300)

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

ggsave("Figures/dat_jitterplots.png", plot = dat_jitterplots, width = 6, height = 8, dpi = 300)

dat_Mt <- dat[dat$GeneType %in% c("Mito"), ]
dat_NonMt <- dat[dat$GeneType %in% c("Non-Mito"), ]

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

ggsave("Figures/dat_Mt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)

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

ggsave("Figures/dat_NonMt_distributions.png", plot = dat_Mt_distributions, width = 6, height = 8, dpi = 300)
