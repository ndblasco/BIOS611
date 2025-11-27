library(tidyverse)

df <- read_csv("data/df.csv")

analysis_df <- df |> 
  filter(!Pos %in% c("LB", "DL", "DB")) |>
  dplyr::select(-TacklesTot, -TacklesAst, -TacklesSck, -TacklesTfl,
                -TurnoverInt, -TurnoverFrcFum, -TurnoverFumRec,
                -ScoreIntTd, -ScoreFumTd, -ScoreBlkTd, -ScoreSaf,
                -ScoreDef2ptRet, -Blk, -PDef, -QBHit,
                -ReturnIntYds, -ReturnFumYds, -`FanPtsAgainst-pts`)|>
  mutate(Team = ifelse(Team %in% c("LA", "LAR"), "LAR", Team))|>
  filter(!Team %in% c("FA")) |>
  filter(year != 2025) |>
  filter(TotalPoints > 0) |>
  mutate(across(where(is.numeric), ~replace_na(., 0)))|>
  mutate(
    `FgMiss_0-19`   = replace_na(`FgMiss_0-19`, 0),
    `FgMiss_20-29`  = replace_na(`FgMiss_20-29`, 0),
    `FgMiss_30-39`  = replace_na(`FgMiss_30-39`, 0)
  )

analysis_df$year <- as.integer(analysis_df$year)

write_csv(analysis_df, "data/analysis_df.csv")
analysisdf <- read_csv("data/analysis_df.csv")