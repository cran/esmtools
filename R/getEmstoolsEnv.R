#' Get the internal package environment
#'
#' This function provides access to the internal environment used by
#' the esmtools package. This environment is used for internal state
#' management and should be used with caution.
#'
#' @return An environment object used internally by the esmtools package.
#' @export
#' @examples
#' esmtools_env <- getEsmtoolsEnv()
#' print(esmtools_env)
getEsmtoolsEnv <- function() {
  return(.esmtools.env)
}
