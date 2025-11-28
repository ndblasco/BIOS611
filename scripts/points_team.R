library(tidyverse)
analysisdf <- read_csv("data/analysis_df.csv")

df_team <- analysisdf |>
  filter(TotalPoints != 0) |>
  filter(!is.na(Team)) |>
  group_by(Team) |>
  summarize(
    avg_points = mean(TotalPoints, na.rm = TRUE),
    n_seasons = n()
  ) |>
  arrange(desc(avg_points))

points_team <- ggplot(df_team, aes(x = reorder(Team, avg_points), y = avg_points)) +
  geom_col(fill = "#4a90e2") +
  coord_flip() +
  labs(
    title = "Average Fantasy Points by Team (2015–2024)",
    x = "Team",
    y = "Average Fantasy Points Per Player Season"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold")
  )

# Save the figure
ggsave(filename = "figures/points_team.png",
  plot = points_team,
  width = 8,
  height = 6,
  dpi = 300
)
