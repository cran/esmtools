# Test case 1: Valid template name and directory creation
test_that("Valid template name and directory creation", {
  # Define a temporary directory for testing
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))

  # Call use_template with a valid template name
  use_template("advanced_preprocess_report", output_dir = temp_dir, overwrite = FALSE)

  # Check if the directory was created
  file <- file.path(gsub("\\\\", "/", temp_dir), "advanced_preprocess_report.Rmd")
  expect_true(file.exists(file))
})

# Test case 2: Invalid template name
test_that("Invalid template name", {
  # Define a temporary directory for testing
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))

  # Call use_template with an invalid template name
  expect_error(use_template("non_existent_template", output_dir = temp_dir, overwrite = FALSE))
})


# Test case 3: Don't overwrite existing template directory
test_that("Don't overwrite existing template directory", {
  # Define a temporary directory for testing
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))

  # Create a directory with the same name as the template
  use_template("advanced_preprocess_report", output_dir = temp_dir)

  # Call use_template without overwrite
  expect_error(template_name("advanced_preprocess_report", output_dir = temp_dir, overwrite = FALSE))
})
