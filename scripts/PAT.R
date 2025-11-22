library(tidyverse)

PAT_Percentage <- analysisdf |>
  filter(Pos == "K")|>
  group_by(year) |>
  summarise(
    PAT_Made = sum(PatMade),
    PAT_Missed = sum(PatMissed),
    PAT_Att = PAT_Made + PAT_Missed,
    PAT_Pct = PAT_Made / PAT_Att
    )|>
  ggplot(aes(x = year, y = PAT_Pct)) +
  geom_line(size = 1.2, color = "#4a90e2") +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = pretty) +
  labs(
    title = "NFL Extra-Point Percentage Over Time",
    x = "Season",
    y = "PAT Accuracy"
  ) +
  theme_minimal()

ggsave("figures/PAT_Percentage.png", width = 8, height = 5)
   


  