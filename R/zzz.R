#' Function execution when importing package
#'
#' It is used to execute code and perform actions that need to be done when the package is loaded into the R session
#' @import knitr
#' @return NULL
#' @noRd
.onLoad <- function(libname, pkgname) {

  # .esmtools.env <- new.env()
  # Set up environment to store variables used in the package
  assign(".esmtools.env", new.env(), envir = asNamespace(pkgname))
  .esmtools.env$.esm_count <- list()
  .esmtools.env$.esmtools_code <- 0
  .esmtools.env$.json_created <- NULL

  # Run whenever knitting a document
  if (!is.null(getOption("knitr.in.progress"))) {
    ############
    #### Import css and js code
    ############


    # #' @keywords internal
    # #' Internal flag to control code import
    # #'
    # #' This flag controls the import of code in the package. It's an internal
    # #' variable and users don't need to interact with it directly.
    # .esmtools_code <- 0 # Explicit declaration
    # .esmtools_code <<- .esmtools_code #Assign a value

    # Create opt chunk: import code
    knit_hooks$set(esmtools_import_code = function(before) {
      if (before) {
        add_script_to_rmd()
      } else {
        if (.esmtools.env$.esmtools_code == 0) {
          .esmtools.env$.esmtools_code <- 1
          add_script_to_rmd()
        }
      }
    })
    # Set global option to TRUE to import code
    opts_chunk$set(esmtools_import_code = TRUE)
  }
}
