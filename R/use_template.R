#' Import esmtools RMarkdown Templates
#'
#' The `use_template()` function allows you to copy esmtools RMarkdown templates
#' from the package to your working directory for further customization and usage.
#'
#' @param template_name A character string specifying the name of the template to be copied.
#'                      Valid options are "preprocess_esm", "advanced_preprocess_esm", and "data_characteristics_report".
#' @param output_dir A mandatory character string specifying the directory where the template should be copied.
#' @param overwrite Logical indicating whether to overwrite existing files with the same name in the output directory.
#'                  Default is `FALSE`.
#'
#' @return Invisible `NULL`
#'
#' @examples
#' if (interactive()) {
#'   # Copy and paste the "preprocess_esm" template to the current working directory
#'   use_template("preprocess_esm")
#'
#'   # Copy and paste the "advanced_preprocess_esm" template to a specific directory
#'   use_template("advanced_preprocess_esm", output_dir = "/path/to/templates")
#'
#'   # Copy and paste the "data_characteristics_report" template to the current working directory
#'   # and overwrite existing file (if any).
#'   use_template("data_characteristics_report", overwrite = TRUE)
#' }
#' @import fs
#' @export

use_template <- function(template_name, output_dir, overwrite = FALSE) {
  templates_path <- system.file("rmarkdown", "templates", package = "esmtools")
  # templates_path <- path_package(package = "esmtools", "inst", "rmarkdown", "templates")
  available_templates <- list.files(templates_path)

  if (missing(output_dir)) {
    stop("You must specify an output directory ('output_dir'). If you want to write in the working directory, specify output_dir = getwd().")
  }

  if (!template_name %in% available_templates) {
    stop("Invalid template name. Available templates: ", paste(available_templates, collapse = ", "))
  }

  # template_path <- system.file("rmarkdown", "templates", template_name, package = "esmtools")
  template_path <- file.path(templates_path, template_name, "skeleton", "skeleton.Rmd")

  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  target_dir <- file.path(output_dir, paste0(template_name, ".Rmd"))
  # target_dir <- gsub("\\\\", "/", target_dir)

  if (file.exists(target_dir) && !overwrite) {
    stop("Template directory already exists. Set `overwrite = TRUE` to overwrite existing files.")
  }

  if (file.exists(target_dir) && overwrite) {
    unlink(target_dir, recursive = TRUE)
  }

  suppressWarnings(file.copy(template_path, target_dir, recursive = TRUE, overwrite = overwrite))

  invisible(NULL)
}
