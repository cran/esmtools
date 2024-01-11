#' Display information regarding the dataset in a succinct way.
#'
#' @description
#' The 'dataInfo()' function displays detailed information about a dataset in a similar style as 'sessionInfo()'.
#' It provides various details such as size, creation and update times,
#' number of columns and rows, number of participants, variable names, and more.
#' This information is useful for reproducibility, tracking the dataset, and ensuring transparency in data analysis workflows.
#'
#' @param file_path The path or URL of the dataset file.
#' @param read_fun The function used to read the dataset file.
#' @param idvar The identifier variable(s) in the dataset, represented as a character vector.
#' @param timevar A time variable(s) name in the dataset. Preference is to use the sent timestamp variable (the time when the beep was sent to the participant).
#' @param validvar The validation variable name in the dataset, represented as a numerical vector. If NULL, the function do not display compliance rate information.
#' @param citation A character element to cite the article or document associated with the script.
#' @param URL The citation information for the dataset (article associated), represented as a character string. If NULL, the function will not display the citation information.
#' @param DOI The Digital Object Identifier (DOI) of the dataset, if applicable. If NULL, the function will not display the DOI information.
#' @param path If TRUE, the function will display the path information.
#' @param variables A logical value indicating whether to display the names of the dataset's variables. Set to TRUE to display variable information, and FALSE to omit it. The default is TRUE.
#'
#' @return The 'dataInfo()' function displays detailed information about the dataset. It can also be store as a list in a variable.
#' @details The 'dataInfo()' function provides a comprehensive summary of information about the dataset. The information returned includes:
#'    - Size: The size of the dataset in octets.
#'    - File extension
#'    - Creation and Update Times: The date and time when the data file was created and last updated.
#'    - Number of Columns and Rows
#'    - Number of Participants
#'    - Average Observations per Participant
#'    - Compliance Mean: The mean compliance value for the dataset.
#'    - Data Collection Period: The duration or period during which the data was collected.
#'    - Path: The path or URL of the dataset file.
#'    - Variable Names: The names of the variables in the dataset.
#'    - Associated Links: Any associated URL, DOI, or citation links for the dataset.
#'
#' @returns A kable object that summarizes the information on the data, the current R session, and the article or document associated with the script.
#' @examples
#' library(dplyr)
#' 
#' # Load data
#' file_path <- system.file("extdata", "esmdata_sim.csv", package = "esmtools")
#' 
#' # Create a function to read the data
#' read_fun <- function(x) read.csv2(x) %>% 
#'     mutate(sent = as.POSIXct(as.character(sent), format="%Y-%m-%d %H:%M:%S"))
#' 
#' # Get data information
#' dataInfo(
#'   file_path = file_path, read_fun = read_fun,
#'   idvar = "id", timevar = "sent"
#' )
#' @import lubridate
#' @import tools
#' @importFrom stats ave
#' @export

dataInfo <- function(file_path = NULL, read_fun = NULL,
                     idvar = NULL, timevar = NULL, validvar = NULL,
                     citation = NULL, URL = NULL, DOI = NULL,
                     path = TRUE, variables = TRUE) {
  list_info <- list()

  # Change object format name
  class(list_info) <- "dataInfo"

  # library(tools) # For md5sum function

  if (is.null(file_path)) {
    stop("The path of the dataset (file_path) should be provided.")
  }
  df_info <- file.info(file_path)
  # Path info
  if (path) list_info[["Path"]] <- rownames(df_info)
  # Extension info
  if (path) list_info[["Extension"]] <- file_ext(file_path)
  # Checksums
  # list_info[["Checksums (MD5)"]] <- md5sum(file_path)
  # Size of the dataframe
  list_info[["Size"]] <- paste0(base::round(df_info["size"] / 1000, 2), " Kb")
  # Creation time of the file
  list_info[["Creation time"]] <- as.character(df_info["ctime"][1, 1])
  # Modification time of the file
  list_info[["Update time"]] <- as.character(df_info["mtime"][1, 1])

  if (!is.null(read_fun)) {
    df <- read_fun(file_path)
    # Number of cols
    list_info[["ncol"]] <- ncol(df)
    # Number of rows
    list_info[["nrow"]] <- nrow(df)
    if (!is.null(idvar)) {
      ids <- unique(df[, idvar])
      # Number of participants
      list_info[["Number participants"]] <- length(ids)
      # Average number of obs / participants
      list_info[["Average number obs"]] <- nrow(df) / length(ids)
      # Compliance
      if (!is.null(validvar)) {
        allowed_val <- sum(is.na(df[, validvar]) | is.logical(df[, validvar]) | df[, validvar] %in% c(0, 1)) == nrow(df)
        if (!allowed_val) stop("The 'validvar' variable must consist of only logical (TRUE/FALSE) values, values of 0, 1, or NA.")
        list_info[["Compliance"]] <- base::mean(ave(df[, validvar], df[, idvar], FUN = function(x) sum(x, na.rm = TRUE) / length(x)))
      }
      # Date: from ... to ...
      if (!is.null(timevar)) {
        if (!is.POSIXct(df[, timevar]) | !is.POSIXlt(df[, timevar])) {
          df[, timevar] <- as.POSIXct(df[, timevar])
        }
        list_info[["Period"]] <- paste0(
          "from ", as.character(min(df[, timevar], na.rm = TRUE)),
          " to ", as.character(max(df[, timevar], na.rm = TRUE))
        )
      }
      # Variables names
      if (variables) list_info[["Variables"]] <- paste(names(df), collapse = ", ")
    }
  }

  # Citation
  if (!is.null(citation)) list_info[["Citation"]] <- citation
  # URL
  if (!is.null(URL)) list_info[["URL"]] <- URL
  # DOI
  if (!is.null(DOI)) list_info[["DOI"]] <- DOI


  # Print
  print.dataInfo(list_info)
}
