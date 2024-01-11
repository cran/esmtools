#' Calculate Longstring Value
#'
#' This function calculates the longstring value for a given vector of values.
#'
#' @param x A vector of values for which the longstring value needs to be calculated.
#' @param tolerance An optional parameter indicating the tolerance for considering consecutive values as equal (default is NULL).
#'
#' @return A dataframe containing the following information:
#' \describe{
#'   \item{val}{The longstring value(s) based on the most frequent value(s) or the unique value(s).}
#'   \item{longstr}{The length of the longest run of consecutive values.}
#'   \item{avgstr}{The average length of non-NA runs of consecutive values (not computed when tolerance is used).}
#' }
#'
#' @examples
#' df <- data.frame(
#'   rbind(
#'     c(1, 1, 2, 2, 2, 3, 3, 3, 3),
#'     c(1, 2, 3, 4, 4, 4, 4, 2, 6)
#'   )
#' )
#' # Example 1: Without tolerance
#' longstring(df)
#'
#' # Example 2: With tolerance
#' longstring(df, tolerance = 1)
#'
#' @export
longstring <- function(x, tolerance = NULL) {
  rle_longstring <- function(x, tolerance = NULL) {
    if (is.null(tolerance)) {
      rle_list <- base::rle(x) # NA are count as 1 each time!!
    } else {
      rle_list <- rle_tolerance(x, tolerance = tolerance)
    }
    # Take longuest
    longstr <- max(rle_list$lengths)

    # Recup values with longuest
    if (longstr > 1) {
      val <- rle_list$values[rle_list$lengths == longstr]
      val <- paste(unique(val), collapse = "_")
    } else if (sum(!is.na(rle_list$values)) > 1) {
      val <- "multi"
    } else if (sum(!is.na(rle_list$values)) == 1) {
      val <- rle_list$values[rle_list$lengths == longstr]
    } else {
      val <- NA
    }

    # Compute average
    avgstr_ <- rle_list$lengths[!is.na(rle_list$values)]
    if (length(avgstr_) != 0) {
      avgstr <- base::round(base::mean(avgstr_), 2)
    } else {
      avgstr <- NA
    }

    # Export
    output <- cbind(val, as.numeric(longstr), as.numeric(avgstr))
  }

  if (!all(sapply(x, is.numeric))) stop("Must contains only numerical values.")
  if (is.null(dim(x))) x <- as.matrix(t(x))

  output <- apply(x, 1, rle_longstring, tolerance = tolerance)
  output <- data.frame(t(output))
  colnames(output) <- c("val", "longstr", "avg_longstr")

  return(output)
}








#' Run-Length Encoding with Tolerance
#'
#' This function performs run-length encoding on a vector of values with tolerance.
#'
#' @param x A vector of numeric values.
#' @param tolerance The tolerance value for considering consecutive values as equal.
#'
#' @return A list with two elements:
#' \describe{
#'   \item{lengths}{A vector indicating the lengths of runs of consecutive values within the tolerance range.}
#'   \item{values}{A vector containing the original values corresponding to each run.}
#' }
#'
#' @noRd

rle_tolerance <- function(x, tolerance) {
  longstr <- c()
  val <- c()
  for (i in 1:length(x)) {
    x_ <- x[i:length(x)]
    tolerance_app <- x_ >= (x[i] - tolerance) & x_ <= (x[i] + tolerance)
    tolerance_app[length(tolerance_app) + 1] <- FALSE
    longstr[i] <- min(which(!tolerance_app)) - 1
    # if (longstr[i] == Inf) longstr[i] <- length(x) - i
    val[i] <- x[i]
  }
  list(lengths = longstr, values = val)
}
