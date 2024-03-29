% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_script_to_rmd.R
\name{add_script_to_rmd}
\alias{add_script_to_rmd}
\title{Add Custom CSS and JavaScript to R Markdown Document}
\usage{
add_script_to_rmd()
}
\value{
Returns an text object marked as HTML containing the combined CSS and JavaScript code stored within the inst folder of the package.
}
\description{
This function adds custom CSS and JavaScript code to an R Markdown document.
The function reads CSS and JavaScript code from specific files (e.g., 'button.css'
and 'button.js') located in the "esmtools" package. It then creates appropriate
HTML elements to include the code within the R Markdown document.
This function is automatically called when importing the esmtools package and
rendering the rmarkdown package.
}
\examples{
if (interactive()) {
  add_script_to_rmd()
}

}
