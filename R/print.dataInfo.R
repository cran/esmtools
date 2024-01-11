#' Print method of the dataInfo object
#'
#' This function provides a customized print method for objects created by the 'dataInfo()' function. 
#' It displays each element of the data information list in a user-friendly format.
#'
#' @param x A list of data information from the 'dataInfo' function.
#' @param ... Dots are for compatibility and not used.
#' @return The function returns the kable object invisibly from the 'dataInfo()' function, allowing for its use in further function calls or 
#'         command chaining without printing the object again.
#' @export
#' @rdname print.dataInfo
print.dataInfo <- function(x, ...) {
  for (el in 1:length(x)) {
    cat(names(x)[el], ":", x[[el]], "\n")
  }
  invisible(x) # Return the object invisibly
}
