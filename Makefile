.PHONY: clean

clean: 
	PowerShell -Command "if (Test-Path 'data') { Remove-Item -Recurse -Force 'data/*' }"
	PowerShell -Command "if (Test-Path 'figures') { Remove-Item -Recurse -Force 'figures/*' }"

all: data/df.csv

data/df.csv: scripts/create_dataset.R
	Rscript scripts/create_dataset.R


