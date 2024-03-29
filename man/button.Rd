% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/button.R
\name{button}
\alias{button}
\title{Create an HTML button with optional toggleable content}
\usage{
button(text = "Description")
}
\arguments{
\item{text}{The text to display on the button. Default is "Description".}
}
\value{
A character string containing the HTML code for the button and optional
toggleable content. In RMarkdown, this will be displayed as an HTML button.
In regular R scripts, this function will return an empty string.
}
\description{
This function generates an HTML button with optional toggleable content.
When used in an RMarkdown document, the content following the button will be hidden
by default and can be toggled on and off by clicking the button.
To use it, simply call the function within inline R code, do not call this function within a chunk.
}
\examples{
# In RMarkdown, use inline code (e.g., `r button()` and `r endbutton()`)
# to create a toggleable button.

if (interactive()) {
  button("Supplementary materials")
  # Hidden content goes here.
  endbutton()
}

}
