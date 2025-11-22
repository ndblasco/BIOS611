library(tidyverse)
library(git2r)

# Path to repo
repo_url <- "https://github.com/hvpkod/NFL-Data.git"

# Local path to clone to
local_repo <- "data/nfl_repo"

# Clone the repository
if (!dir.exists(local_repo)) {
  git2r::clone(repo_url, local_repo)
}

# Create list of years
data_folder <- file.path(local_repo, "NFL-data-Players")
year_dirs <- list.dirs(data_folder, recursive = FALSE, full.names = TRUE)

# Function to read a season file if it exists
read_season_files <- function(year_dir) {
  season_files <- list.files(year_dir, pattern = "_season\\.csv$", full.names = TRUE)
  if (length(season_files) == 0) return(NULL)
  
  lapply(season_files, function(file) {
    read_csv(file) |>
      mutate(
        year = basename(year_dir),                    
      )
  }) |>
    bind_rows()
}

# Read and combine all season files
season_data <- lapply(year_dirs, read_season_files) |>
  compact() |>
  bind_rows()

write_csv(season_data, "data/df.csv")