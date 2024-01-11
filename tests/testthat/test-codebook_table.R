
path_original <- system.file("extdata", "cbook_part1.xlsx", package = "esmtools")
library(readxl)
original_codebook <- read_excel(path_original)

# Test case 1: Check if the function return correct table (kable)
# save_kable_fun <- function(code, width = 400, height = 400) {
#   path <- tempfile(fileext = ".png")
#   code %>% kableExtra::save_kable(path)
#   path
# }

# esmdata_sim$end = as.POSIXct(esmdata_sim$end, origin="1970-01-01")
# save(esmdata_sim, file="data/esmdata_sim.rda")

test_that("Right kable output", {

  expect_no_error(codebook_table(df=esmdata_sim, origin_cbook = original_codebook))

  # result <- codebook_table(df=esmdata_sim, origin_cbook = original_codebook)
  # Check if the output
  # announce_snapshot_file(name = "kable.png")
  # expect_snapshot_file(save_kable_fun(result), "kable.png")
})




# Test case 2: Check if the function return correct table (DT)
save_DT_fun <- function(code, width = 400, height = 400) {
  path <- tempfile(fileext = ".html")
  code %>% DT::saveWidget(path)
  path
}

test_that("Right DT table output", {

  expect_no_error(codebook_table(df=esmdata_sim, origin_cbook = original_codebook, kable_out = FALSE))

  # result <- codebook_table(esmdata_sim, origin_cbook = original_codebook, kable_out = FALSE)
  # # Check if the output
  # announce_snapshot_file(name = "dtable.html")
  # expect_snapshot_file(save_DT_fun(result), "dtable.html")
})
