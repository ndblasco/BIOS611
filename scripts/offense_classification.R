library(tidyverse)
library(caret)
library(pROC)
library(MASS)
library(gt)
library(kableExtra)

analysisdf <- read_csv("data/analysis_df.csv")

classdf <- analysisdf %>%
  filter(Pos %in% c("RB", "WR")) %>%
  dplyr::select(
    Pos, RushingYDS, RushingTD, TouchCarries,
    ReceivingRec, ReceivingYDS, ReceivingTD,
    Targets, ReceptionPercentage, TouchReceptions, RzTarget, RzTouch, RzG2G,
    Fum, FumTD
  ) %>%
  mutate(Pos = factor(Pos, levels = c("WR", "RB")))

# split into training and test
set.seed(54321)
train_index <- createDataPartition(classdf$Pos, p = 0.7, list = FALSE)

train <- classdf[train_index, ]
test <- classdf[-train_index, ]

# fit model on training
full_model <- glm(Pos ~ RushingYDS + RushingTD + TouchCarries +
               ReceivingRec + ReceivingYDS + ReceivingTD +
               Targets + ReceptionPercentage + TouchReceptions + RzTarget + RzTouch + RzG2G +
               Fum + FumTD,
             data = train,
             family = binomial)

step_model <- stepAIC(full_model, direction = "both", trace = TRUE)

# Make predictions
pred_probs <- predict(step_model, newdata = test, type = "response")
pred_class <- ifelse(pred_probs > 0.5, "RB", "WR") %>% factor(levels = c("RB","WR"))


# Evaluate performance
conf_matrix <- table(Actual = test$Pos, Predicted = pred_class)

conf_gt <- as.data.frame.matrix(conf_matrix) %>%
  rownames_to_column("Actual") %>%
  gt(rowname_col = "Actual") %>%
  tab_header(
    title = "Confusion Matrix"
  ) %>%
  tab_spanner(
    label = "Predicted",
    columns = everything()[-1]
  ) %>%
  fmt_number(
    columns = everything(),
    decimals = 0
  ) %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_title(groups = "title")
  )


png("figures/ROC.png", width = 1200, height = 800)
roc_obj <- roc(response = test$Pos, predictor = pred_probs, levels = c("WR","RB"))
plot(roc_obj, main = "ROC Curve: RB vs WR (Stepwise)", col = "#1f78b4", lwd = 2)
text(0.6, 0.2, labels = paste0("AUC = ", round(auc(roc_obj), 3)), cex = 1.2)
dev.off()