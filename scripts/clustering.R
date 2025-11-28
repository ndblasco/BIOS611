library(tidyverse)
library(kableExtra)
library(plotly)

analysisdf <- read_csv("data/analysis_df.csv")

offense <- analysisdf |>
  filter(Pos %in% c("RB", "WR", "TE")) 

cluster_features <- offense |>
  dplyr::select(RushingYDS, RushingTD, TouchCarries,
         ReceivingRec, ReceivingYDS, ReceivingTD,
         Targets, ReceptionPercentage, RzTarget, RzTouch, RzG2G,
         Fum, FumTD)

cluster_scaled <- scale(cluster_features)

set.seed(54321) 
kmeans_result <- kmeans(cluster_scaled, centers = 4, nstart = 25)
offense$Cluster <- factor(kmeans_result$cluster)

pca_res <- prcomp(cluster_scaled)
pca_df <- data.frame(PC1 = pca_res$x[,1],
                     PC2 = pca_res$x[,2],
                     Cluster = offense$Cluster,
                     Pos = offense$Pos,
                     PlayerName = offense$PlayerName,
                     Year = offense$year)

plot_ly(
  pca_df,
  x = ~PC1,
  y = ~PC2,
  color = ~Cluster,
  symbol = ~Pos,
  mode = "markers",
  type = "scatter",
  text = ~paste(
    "Player:", PlayerName,
    "<br>Year:", Year,
    "<br>Cluster:", Cluster,
    "<br>Pos:", Pos
  ),
  hoverinfo = "text",
  marker = list(size = 8, opacity = 0.7)
) %>%
  layout(
    title = "K-means Clusters of Offensive Players (Interactive)",
    xaxis = list(title = "PC1"),
    yaxis = list(title = "PC2")
  )


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
