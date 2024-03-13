#' Custom Text for Rmarkdown with Counting
#'
#' This function generates custom text and provides the option to include an
#' optional count that can be integrated into the text. It creates an HTML
#' span element with a unique identifier (ID). This identifier can be used for
#' customizing the appearance of the text using CSS code. Default identifiers are "text_issue", "text_inspect", "text_mod".
#' To use it, simply call the function within inline code, do not call this function within a chunk.
#'
#' @param id A character string specifying the unique identifier for the HTML span element. Default identifiers are "text_issue", "text_inspect", "text_mod".
#' @param title A character string containing the text to display.
#' @param text Descriptive text.
#' @param count A logical value indicating whether to include a count in the text.
#' @param output_file A character string specifying the json file should be created.
#'                   If not provided, the template will be copied to the current working directory.
#'
#' @return A character string containing the HTML span element with the specified ID and text.
#'
#' @examples
#' if (interactive()) {
#'   # In RMarkdown, use 'r txt()`.
#'   # Do not call this function within a chunk
#' 
#'   txt("text_issue", "Issue", text = "Wrong participant number")
#'   txt("text_mod", "Modification", text = "Change the participant number from 1 to 32", 
#'       count = FALSE)
#' }
#'
#' @import jsonlite
#' @import knitr
#' @export


txt <- function(id = "text_issue", title = "Issue", text = "", count = TRUE, output_file = NULL) {
  
  if (is.null(.esmtools.env$.esm_count[[id]])) {
    .esmtools.env$.esm_count[[id]] <- 1
  } else {
    .esmtools.env$.esm_count[[id]] <- .esmtools.env$.esm_count[[id]] + 1
  }

  # Export in json if param$json_esm exists
  if(exists("params")){
    test_exist <- TRUE
  } else {
    params <- NULL
    test_exist <- FALSE
  }
  
  if(is.null(.esmtools.env$.esm_count[[id]])) number <- 1 else number <- .esmtools.env$.esm_count[[id]]

  if (test_exist && !is.null(params$json_esm)) {
    # Does not rerun for privacy
    # privacy_matter <- (!is.null(params$create_privacy) && (params$create_privacy == TRUE | params$create_privacy != "hide")) | is.null(params$create_privacy)
    # if (privacy_matter) {
      # Split json params
      json_param <- unlist(strsplit(params$json_esm, ","))
      json_param <- gsub(" ", "", json_param)

      if (id %in% json_param | sum(json_param == "all") == 1) {
        # Create file name and path
        if (is.null(output_file)) {
          json_file <- normalizePath(current_input(dir = TRUE))
          json_file <- sub("(?i)\\.rmd$|(?i)\\.qmd$", "", json_file)
          json_file <- paste0(gsub("\\\\", "/", json_file), "_list.json")
        } else if (!endsWith(output_file, ".json")) {
          json_file <- paste0(gsub("\\\\", "/", output_file), "_list.json")
        } else {
          json_file <- gsub("\\\\", "/", output_file)
        }

        # Create or import json list
        if (!file.exists(json_file)) {
          json_data <- list() # Create an empty list for JSON data

          .esmtools.env$.json_created <- TRUE
        } else {
          # Read existing JSON data from the file
          json_data <- read_json(gsub("\\\\", "/", json_file), simplifyVector = FALSE)
        }

        # Add or update the specified key-value pair
        # json_data[[title]][[paste0(title, " ", .esm_count[[id]])]] = unlist(text)
        json_data[[paste0(title, " ", number)]] <- unlist(text)

        # Convert the JSON data to a character string
        json_string <- toJSON(json_data, auto_unbox = TRUE, pretty = TRUE, digits = 3)

        # Write the modified JSON data back to the file
        # output_dir = dirname(output_file)
        # if (!dir.exists(output_dir)) dir.create(output_dir)
        cat(json_string, file = json_file)
      }
    # }
  }

  # Merge occurence and title
  if (count) title <- paste0(title, " ", number)
  paste0("\n<span class='", id, "'> ", title, ":</span> ", text)
}
