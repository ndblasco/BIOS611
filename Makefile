.PHONY: clean

all: data/df.csv

clean: 
	rm -rf data/*
	rm -rf figures/*

data/df.csv: scripts/create_dataset.R
	Rscript scripts/create_dataset.R


