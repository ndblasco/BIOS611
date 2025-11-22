library(tidyverse)

FG_Percentage <- analysisdf |>
  filter(Pos == "K") |>
  group_by(year) |>
  summarise(
    `FgMade_0-19`   = sum(`FgMade_0-19`),
    `FgMiss_0-19` = sum(`FgMiss_0-19`),
    `FgMade_20-29`   = sum(`FgMade_20-29`),
    `FgMiss_20-29` = sum(`FgMiss_20-29`),
    `FgMade_30-39`   = sum(`FgMade_30-39`),
    `FgMiss_30-39` = sum(`FgMiss_30-39`)
  ) |>
  mutate(
    `0-19`  = `FgMade_0-19`  / (`FgMade_0-19`  + `FgMiss_0-19`),
    `20-29` = `FgMade_20-29` / (`FgMade_20-29` + `FgMiss_20-29`),
    `30-39` = `FgMade_30-39` / (`FgMade_30-39` + `FgMiss_30-39`)
  ) |>
  select(year, `0-19`, `20-29`, `30-39`) |>
  pivot_longer(
    cols = c(`0-19`, `20-29`, `30-39`),
    names_to = "Range",
    values_to = "FG_Pct"
  ) |>
  ggplot(aes(x = year, y = FG_Pct, color = Range)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c(
      "0-19" = "#1f77b4",   # darkest blue
      "20-29" = "#4a90e2",  # medium blue
      "30-39" = "#a3c4f3"   # lightest blue
    )
  ) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = pretty) +
  labs(
    title = "NFL Field Goal Percentage Over Time by Distance",
    x = "Season",
    y = "FG Accuracy",
    color = "Distance Range (yds)"
  ) +
  theme_minimal(base_size = 14)

ggsave("figures/FG_Percentage.png", width = 8, height = 5)
