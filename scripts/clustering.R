library(tidyverse)
library(kableExtra)

offense <- analysisdf |>
  filter(Pos %in% c("RB", "WR", "TE")) 

cluster_features <- offense |>
  dplyr::select(RushingYDS, RushingTD, TouchCarries,
         ReceivingRec, ReceivingYDS, ReceivingTD,
         Targets, ReceptionPercentage, RzTarget, RzTouch, RzG2G,
         Fum, FumTD)

cluster_scaled <- scale(cluster_features)

set.seed(54321) 
kmeans_result <- kmeans(cluster_scaled, centers = 5, nstart = 25)
offense$Cluster <- factor(kmeans_result$cluster)

pca_res <- prcomp(cluster_scaled)
pca_df <- data.frame(PC1 = pca_res$x[,1],
                     PC2 = pca_res$x[,2],
                     Cluster = offense$Cluster,
                     Pos = offense$Pos)

cluster_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Cluster, shape = Pos)) +
  geom_point(alpha = 0.7, size = 2) +
  theme_minimal() +
  labs(title = "K-means Clusters of Offensive Players",
       subtitle = "PCA projection of skill player stats",
       x = "PC1", y = "PC2")

ggsave("figures/cluster_plot.png", cluster_plot, width = 8, height = 6)

cluster_summary <- offense |>
  group_by(Cluster) |>
  summarise(
    RushingYDS = mean(RushingYDS, na.rm = TRUE),
    RushingTD = mean(RushingTD, na.rm = TRUE),
    TouchCarries = mean(TouchCarries, na.rm = TRUE),
    ReceivingRec = mean(ReceivingRec, na.rm = TRUE),
    ReceivingYDS = mean(ReceivingYDS, na.rm = TRUE),
    ReceivingTD = mean(ReceivingTD, na.rm = TRUE),
    Targets = mean(Targets, na.rm = TRUE),
    RzTouch = mean(RzTouch, na.rm = TRUE),
    Fum = mean(Fum, na.rm = TRUE)
  )
