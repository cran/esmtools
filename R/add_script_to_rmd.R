#' Add Custom CSS and JavaScript to R Markdown Document
#'
#' This function adds custom CSS and JavaScript code to an R Markdown document.
#' The function reads CSS and JavaScript code from specific files (e.g., 'button.css'
#' and 'button.js') located in the "esmtools" package. It then creates appropriate
#' HTML elements to include the code within the R Markdown document.
#' This function is automatically called when importing the esmtools package and
#' rendering the rmarkdown package.
#'
#' @return Returns an text object marked as HTML containing the combined CSS and JavaScript code stored within the inst folder of the package.
#'
#' @examples
#' if (interactive()) {
#'   add_script_to_rmd()
#' }
#'
#' @importFrom knitr knit_hooks
#' @importFrom htmltools HTML
#' @export
add_script_to_rmd <- function() {
  # knit_hooks$set(html = function(before, options, envir) {
  # if (before) {
  # if (!is.null(getOption("knitr.in.progress"))){
  # Add css
  css_code_1 <- readLines(system.file("button.css", package = "esmtools"), warn = FALSE)
  css_code_2 <- readLines(system.file("txt.css", package = "esmtools"), warn = FALSE)
  css_code_3 <- readLines(system.file("privacy_mode.css", package = "esmtools"), warn = FALSE)
  css_code <- paste("<style>",
    paste(css_code_1, collapse = "\n"),
    paste(css_code_2, collapse = "\n"),
    paste(css_code_3, collapse = "\n"),
    "</style>",
    sep = "\n"
  )

  # Add js
  js_code_1 <- readLines(system.file("button.js", package = "esmtools"), warn = FALSE)
  js_code <- paste("<script>", paste(js_code_1, collapse = "\n"), "</script>", sep = "\n")

  # Add css
  HTML(paste0(css_code, "\n", js_code))
  # }
}
