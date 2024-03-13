# Test case 1: Default behavior
test_that("Default values", {
  result <- txt()
  expect_equal(result, "\n<span class='text_issue'> Issue 1:</span> ")
})

# Test case 2: Custom values
test_that("Custom values", {
  result <- txt(id = "custom_test2", title = "Custom", text = "Custom Text", count = FALSE)
  expect_equal(result, "\n<span class='custom_test2'> Custom:</span> Custom Text")
})

# Test case 3: Counting behavior
test_that("Counting behavior", {
  result1 <- txt(id = "custom_test3") 
  result2 <- txt(id = "custom_test3")
  expect_equal(result1, "\n<span class='custom_test3'> Issue 1:</span> ")
  expect_equal(result2, "\n<span class='custom_test3'> Issue 2:</span> ")
})

# Test case 4: JSON export with params$json_esm + check JSON
# test_that("JSON export with params$json_esm", {
#   temp_file <- tempfile("file", fileext = "_list.json")
#   print(temp_file)
#   params <- list(json_esm = "custom_test4, other_id", create_privacy = TRUE)
#   result <- txt(id = "custom_test4", title = "Custom Title", text = "Custom Text", output_file = temp_file)
#   # json_file <- paste0(gsub("\\\\", "/", temp_file), "_list.json")
#   json_test <- jsonlite::read_json(temp_file, simplifyVector = FALSE)
#   expect_equal(json_test$"Custom Title 1", "Custom Text")
# })

