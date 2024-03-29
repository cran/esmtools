% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/longstring.R
\name{longstring}
\alias{longstring}
\title{Calculate Longstring Value}
\usage{
longstring(x, tolerance = NULL)
}
\arguments{
\item{x}{A vector of values for which the longstring value needs to be calculated.}

\item{tolerance}{An optional parameter indicating the tolerance for considering consecutive values as equal (default is NULL).}
}
\value{
A dataframe containing the following information:
\describe{
\item{val}{The longstring value(s) based on the most frequent value(s) or the unique value(s).}
\item{longstr}{The length of the longest run of consecutive values.}
\item{avgstr}{The average length of non-NA runs of consecutive values (not computed when tolerance is used).}
}
}
\description{
This function calculates the longstring value for a given vector of values.
}
\examples{
df <- data.frame(
  rbind(
    c(1, 1, 2, 2, 2, 3, 3, 3, 3),
    c(1, 2, 3, 4, 4, 4, 4, 2, 6)
  )
)
# Example 1: Without tolerance
longstring(df)

# Example 2: With tolerance
longstring(df, tolerance = 1)

}
