#' Get Context of Rows
#'
#' This function extracts specific rows from a data frame along with their context, based on a given range.
#' It can take either a vector of row numbers or a boolean vector as input. Additionally, the function allows
#' specifying the direction of the context (above, below, or both) and marks each row as either targeted or context.
#'
#' @param data A data frame from which rows and their context will be extracted.
#' @param input A numeric vector of row numbers or a logical vector. If a logical vector is given, the function
#'        will extract rows where the vector is TRUE.
#' @param context An integer specifying the number of rows above and/or below the target row to include as context.
#'        Default is 1.
#' @param direction A character string specifying the direction of context to include. Valid options are "up" for
#'        rows above, "down" for rows below, and "both" for both directions. Default is "both".
#'
#' @return A dataframe containing the targeted rows and their contextual rows. An additional column
#'         '.RowType' indicates whether it is a row given as input ("->") or part of the context ("").
#'
#' @examples
#' # Example dataframe
#' data <- data.frame(matrix(rnorm(100), ncol = 5))
#'
#' # Get context for rows 8 and 15 (using row numbers)
#' result <- controws(data, c(8, 15), 1, "both")
#' result
#'
#' @export

controws <- function(data, input, context = 1, direction = "both") {
# Stop conditions
  if (!is.numeric(input) && !is.logical(input)) {
    stop("Input must be a numeric vector of row numbers or a logical vector.")
  }
  if (is.numeric(input) && any(input < 1 | input > nrow(data))) {
    stop("Row numbers must be within the valid range of the data frame.")
  }
  if (context < 0) {
    stop("Context must be a non-negative integer.")
  }
  if (!direction %in% c("up", "down", "both")) {
    stop("Direction must be 'up', 'down', or 'both'.")
  }

  # Convert boolean vector to row numbers if necessary
  if (is.logical(input)) {
    input <- which(input)
  }

  # Initialize result data frame
  result <- data.frame()

  # Process each row number
  for (row in input) {
    start_row <- ifelse(direction %in% c("down", "both"), max(row - context, 1), row)
    end_row <- ifelse(direction %in% c("up", "both"), min(row + context, nrow(data)), row)

    # Extract context rows
    temp_data <- data[start_row:end_row, ]

    # Add a new column to indicate targeted or context rows
    temp_data$.RowType <- ifelse(start_row:end_row == row, "->", "")

    # Combine with the result
    result <- rbind(result, temp_data)
  }

  # Adjust the order of columns to have .RowType as the first column
  result <- result[, c(".RowType", names(data))]

  return(result)
}
