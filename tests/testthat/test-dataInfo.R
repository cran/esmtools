sample_data <- data.frame(
  ID = rep(1:10, each = 2),
  Name = rep(c("Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Hannah", "Ivy", "Jack"), each = 2),
  valid = rep(c(1, 0), 10),
  sent = seq(as.POSIXct("2023-09-05 01:00:00"), by = "days", length.out = 20)
)

temp_dir <- tempfile()
path_file <- paste0(gsub("\\\\", "/", temp_dir), "/test.csv")
on.exit(unlink(temp_dir, recursive = TRUE))
dir.create(temp_dir)
write.csv(sample_data, path_file, row.names = FALSE)


# Test case 1: Basic info without reading the data
test_that("Basic info without reading the data", {
  result <- dataInfo(file_path = path_file)
  result <- as.list(result)

  df_info <- file.info(path_file)

  # Expected result
  expect_true(result$Path == rownames(df_info))
  expect_true(result$'Creation time' == as.character(df_info$ctime))
  expect_true(result$'Update time' == as.character(df_info$mtime))
  expect_true(result$Size == paste0(base::round(df_info$size / 1000, 2), " Kb"))
})

# Test case 2: Reading the data and extracting more information
test_that("Reading the data and extracting more information", {
  result <- dataInfo(
    file_path = path_file, read_fun = read.csv, idvar = "ID", timevar = "sent", validvar = "valid",
    citation = "citation...", DOI = "DOI...", URL = "URL..."
  )

  df_info <- file.info(path_file)

  # Expected result
  expect_true(result$'ncol' == 4)
  expect_true(result$'nrow' == 20)
  expect_true(result$'Number participants' == 10)
  expect_true(result$'Average number obs' == 2)
  expect_true(result$'Compliance' == .5)
  expect_true(result$'Period' == "from 2023-09-05 01:00:00 to 2023-09-24 01:00:00")
  expect_true(result$'Variables' == "ID, Name, valid, sent")
  expect_true(result$'Citation' == "citation...")
  expect_true(result$'URL' == "URL...")
  expect_true(result$'DOI' == "DOI...")
})
