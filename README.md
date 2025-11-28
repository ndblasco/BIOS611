# BIOS 611 Project

## Overview
This project generates analysis figures and an HTML report for a data science project focused on NFL and Fantasy Football data from 2015-2024.
All data processing and visualization are done using R. The workflow is automated with a Makefile and containerized using Docker for reproducibility.

## Requirements

- Docker installed on your system.

## How to Reproduce

1. **Clone or download** the repository to your local machine.

2. **Build the Docker image:**

  Open a terminal in the project directory and run:
   
```
docker build -t bios611-project .
```
3. **Run the container interactively with project folder mounted**

```
docker run --rm -it -v ${PWD}:/bios611-project bios611-project /bin/bash
```

4. **Render the final report:**
```
make clean 
make report.html
```
5. After the prompts finish running, the rendered HTML file will be available in the project directory

## Developer Instructions

The project workflow is fully automated using a Makefile: 

- Each target specifies dependencies and commands. 
- CSV datasets are created first.  
- Figure scripts generate PNGs in figures/. 
- report.html is generated last, depending on all data and figures. 
- Note: Each R script reads its required CSVs; Make ensures the correct execution order. 
- You can edit scripts or R Markdown files on the host machine and rerun make report.html inside the container. The mounted volume ensures that outputs are automatically saved to your host. 

## Data Source

Raw NFL and Fantasy Football data is pulled from: https://github.com/hvpkod/NFL-Data/tree/main 

scripts/create_dataset.R handles downloading and preprocessing for use in this project.