setwd(normalizePath(dirname(R.utils::commandArgs(asValues=TRUE)$"f")))
source("../../scripts/h2o-r-test-setup.R")
######################################################################
# Test for https://github.com/h2oai/private-h2o-3/issues/472
# In R, predict fails with NPE when newdata is set to a sliced frame
######################################################################




test.hex.207 <- function() {
  Log.info("Importing ecology_model.csv...")
  tr <- h2o.importFile(normalizePath(locate("smalldata/gbm_test/ecology_model.csv")), destination_frame = "tr")
  
  myX <- setdiff(colnames(tr), c("Angaus", "Site"))
  myY <- "Angaus"
  Log.info(paste("Run GBM on ecology_model.csv with Y:", myY, "\tX:", paste(myX, collapse = ", ")))
  tru.gbms <- h2o.gbm(x = myX, y = myY, training_frame = tr, distribution = "gaussian", ntrees = 400, nbins = 20, min_rows = 1, max_depth = 4, learn_rate = 0.01, validation_frame = tr)
  
  Log.info(paste("Predict on columns", paste(3:8, collapse = ", "), "of ecology_model.csv"))
  predict(object = tru.gbms, tr[,3:8])
  
}

doTest("Predict fails with NPE when test data is a sliced frame", test.hex.207)
