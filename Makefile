.PHONY: clean

clean: 
	rm -rf figures
	mkdir figures
	rm report.html 

.PHONY: dir

dir:
	mkdir -p figures

data/df.csv: scripts/create_dataset.R
	Rscript scripts/create_dataset.R

data/analysis_df.csv: data/df.csv scripts/data_preprocessing.R
	Rscript scripts/data_preprocessing.R

figures/FantasyPoints_Position.png: data/analysis_df.csv scripts/points_position.R | dir
	Rscript scripts/points_position.R

figures/points_team.png: data/analysis_df.csv scripts/points_team.R | dir
	Rscript scripts/points_team.R

figures/PAT_Percentage.png: data/analysis_df.csv scripts/PAT.R | dir
	Rscript scripts/PAT.R

figures/FG_Percentage.png: data/analysis_df.csv scripts/FG.R | dir
	Rscript scripts/FG.R

figures/ROC.png: data/analysis_df.csv scripts/offense_classification.R | dir
	Rscript scripts/offense_classification.R

figures/cluster_plot.png: data/analysis_df.csv scripts/clustering.R | dir
	Rscript scripts/clustering.R

report.html: report.Rmd  data/df.csv data/analysis_df.csv figures/FantasyPoints_Position.png figures/points_team.png figures/PAT_Percentage.png figures/FG_Percentage.png figures/ROC.png figures/cluster_plot.png scripts/clustering.R scripts/clustering.R scripts/FG.R scripts/PAT.R scripts/points_team.R scripts/points_position.R scripts/data_preprocessing.R scripts/create_dataset.R
	R -e "rmarkdown::render('report.Rmd', output_format='html_document')"



