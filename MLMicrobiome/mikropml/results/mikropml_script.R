# Mikropml script using Random Forest
data <- read.csv(#YOURFILEPATHHERE)
data$dx <- factor(data$dx)
# script to run the pipeline using the random forest model, with 5 folds (specifically for my analysis)
rf_results <- run_ml(
  dataset = dat,
  method = "rf",
  outcome_colname = "dx",
  training_frac = 0.80,
  kfold = 5,
  seed = 123,
  find_feature_importance = TRUE,
  calculate_performance = TRUE
)

# Save fitted results
saveRDS(
  rf_results,
  "YOURFILEPATHHERE/results/mikropml_random_forest_model.rds"
)

capture.output(
  str(rf_results, max.level = 2),
  file = "YOURFILEPATHHERE/results/mikropml_model_summary.txt"
)


