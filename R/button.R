#' Create an HTML button with optional toggleable content
#'
#' This function generates an HTML button with optional toggleable content. 
#' When used in an RMarkdown document, the content following the button will be hidden 
#' by default and can be toggled on and off by clicking the button.
#' To use it, simply call the function within inline R code, do not call this function within a chunk.
#' 
#'
#' @param text The text to display on the button. Default is "Description".
#'
#' @return A character string containing the HTML code for the button and optional 
#'         toggleable content. In RMarkdown, this will be displayed as an HTML button.
#'         In regular R scripts, this function will return an empty string.
#'
#' @examples
#' # In RMarkdown, use inline code (e.g., `r button()` and `r endbutton()`)
#' # to create a toggleable button.
#' 
#' if (interactive()) {
#'   button("Supplementary materials")
#'   # Hidden content goes here.
#'   endbutton()
#' }
#'
#' @export
button <- function(text = "Description") {
  rmd <- !is.null(getOption("knitr.in.progress"))
  
  if (rmd) {
    paste0("\n<div class='esmtools-container'>\n<button class='esmtools-btn' onclick='esmtools_toggleContent(this)'>", text, "</button>\n<p>\n<div style='display:none;'>\n")
  } else {
    paste0("\n::: {.callout-note collapse='true'}\n<p>## ", text, "</p>\n\n")
  }
}




#' End the HTML button container
#'
#' This function ends the HTML container for the button and optional toggleable content 
#' created using the 'button()' function. When used in an RMarkdown document, 
#' it closes the container and ensures proper rendering.
#' To use it, simply call the function within inline R code, do not call this function within a chunk.
#'
#' @return A character string containing the closing HTML tags for the button container. 
#'         In RMarkdown, this will ensure that the content following the button is properly 
#'         displayed. In regular R scripts, this function will return an empty string.
#'
#' @examples
#' # In RMarkdown, use inline code (e.g., `r button()` and `r endbutton()`)
#' # to create a toggleable button.
#' 
#' if (interactive()) {
#'   button("Supplementary materials")
#'   # Hidden content goes here.
#'   endbutton()
#' }
#'
#' @export
endbutton <- function() {
  rmd <- !is.null(getOption("knitr.in.progress"))
  
  if (rmd) {
    "<p>\n</div>\n</div>\n</p>\n"
  } else {
    "\n:::\n\n"
  }
}
