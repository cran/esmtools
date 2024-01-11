# This file is automatically run before and after every test to check if a test did not accidently
# change anything permanently, e.g. options or left open connections.
# See https://www.tidyverse.org/blog/2023/10/testthat-3-2-0/#state-inspector
set_state_inspector(function() {
  list(
    options = options(),
    envvars = Sys.getenv(),
    connections = getAllConnections(),
    workdir = getwd(),
    tempfiles = list.files(tempdir())
  )
})
