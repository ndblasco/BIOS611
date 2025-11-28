library(tidyverse)
analysisdf <- read_csv("data/analysis_df.csv")

points_position <- analysisdf |>
  filter(TotalPoints != 0)|>
  ggplot(aes(x = Pos, y = TotalPoints, fill = Pos)) +
  geom_boxplot(outlier.size = 0.8, alpha = 0.7) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Distribution of Fantasy Points by Position (Season Totals)",
    x = "Position",
    y = "Total Fantasy Points"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold")
  )

ggsave(filename = "figures/FantasyPoints_Position.png",
  plot = points_position,
  width = 8,
  height = 5,
  dpi = 300
)