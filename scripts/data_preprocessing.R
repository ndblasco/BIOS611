library(tidyverse)

df <- read_csv("data/df.csv")

final <- df |> 
  mutate(Team = ifelse(Team == "LA", "LAR", Team))|>
  filter(!Team %in% c("FA")) %>%
  filter(year != 2025) %>%
  mutate(across(where(is.numeric), ~replace_na(., 0)))|>
  mutate(
    `FgMiss_0-19`   = replace_na(`FgMiss_0-19`, 0),
    `FgMiss_20-29`  = replace_na(`FgMiss_20-29`, 0),
    `FgMiss_30-39`  = replace_na(`FgMiss_30-39`, 0)
  )

final$year <- as.integer(final$year)


write_csv(final, "data/analysis_df.csv")
analysisdf <- read_csv("data/analysis_df.csv")