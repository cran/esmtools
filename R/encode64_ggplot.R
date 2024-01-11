#' Transform a ggplot object to an image file to a data URI element to be later integrated in a datatable (DT package)
#' @param p A ggplot object
#' @param height A number to define the height of the plot in pixel
#' @param width A number to define the width of the plot in pixel
#' @param res A number to define the resolution of the output plot
#' @param kable_out Logical indicating whether to the transform plots for an integration in a kable
#' @return A data URI element
#' @import base64enc 
#' @import knitr
#' @import grDevices
#' @noRd
encode64_ggplot <- function(p, width = 100, height = 100, res = 100, kable_out = TRUE) {
  if (kable_out) {
    #   if(!"./.esmtools_temp_plot" %in% list.dirs()) dir.create(".esmtools_temp_plot")
    #   fn = paste0(".esmtools_temp_plot/image", runif(1)*10000000000, ".png")
    #   png(fn, width=width, height=height)
    #   print(p)
    #   dev.off()

    fn <- tempfile(fileext = ".png")
    png(fn, width = width, height = height)
    print(p)
    dev.off()
    base64_image <- base64encode(fn)
    out <- sprintf('<img src="data:image/png;base64,%s" alt="Embedded Image">', base64_image)
  } else {
    fn <- tempfile(fileext = ".png")
    png(fn, width = width, height = height)
    print(p)
    dev.off()
    out <- sprintf('<img src="%s"/>', image_uri(fn))
  }
  unlink(fn)
  return(out)
}


#' Set up general theme for ggplot
#' @return A ggplot theme
#' @noRd
theme_64 <- function() {
  theme(
    panel.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.grid = element_blank(), panel.border = element_blank(),
    legend.background = element_rect(fill = "transparent"),
    legend.box.background = element_rect(fill = "transparent"),
    axis.line = element_blank(), axis.text = element_blank(),
    axis.title = element_blank(), axis.ticks = element_blank()
  )
}



#' Create a plot for each dataframe in a list
#' @param list_df A list of dataframe
#' @param type The plot type which can be line, histogram, boxplot
#' @param size_plot A number to define the size in pixel of the output plot
#' @param res A number to define the resolution of the output plot
#' @param kable_out Logical indicating whether to the transform plots for an integration in a kable
#' @param min_max_regularize Whether to regularize the x-axis limits across plots based on the global minimum and maximum values. Default is TRUE.
#' @return A array of ggplot in data URI format to be integrated in datatable or kable.
#' @import ggplot2
#' @noRd
plot_64 <- function(list_df, type, size_plot = 150, res = 300, 
                    kable_out = TRUE, min_max_regularize = TRUE){
  min_max <- min_max(list_df)
  plots_tm <- sapply(list_df, function(x) {
    if (type=="line") p = line_64(x)
    if (type=="histogram") p = histogram_64(x)
    if (type=="boxplot") p = boxplot_64(x)

    if (min_max_regularize) {
      p <- p + scale_y_continuous(limits = c(min_max[1], min_max[2]))
    }

    suppressWarnings(encode64_ggplot(p, width = size_plot, height = size_plot * .7, res = res, kable_out = kable_out))
  })
}


#' Create a line plot
#'
#' This function generates a line plot using ggplot2.
#'
#' @param x A dataframe containing the data for plotting.
#' @return A ggplot object representing the line plot.
#' @noRd
line_64 <- function(x, val="val", beepnr="beepnr") {
  ggplot(data=x, aes(y = val, x = beepnr)) +
      geom_line() +
      theme_64()
}


#' Create a histogram
#'
#' This function generates a histogram using ggplot2.
#'
#' @param x A dataframe containing the data for plotting.
#' @return A ggplot object representing the histogram.
#' @noRd
histogram_64 <- function(x, val="val") {
  ggplot(data=x, aes(x=val)) +
    geom_histogram(bins = 30) +
    theme_64()
}


#' Create a boxplot
#'
#' This function generates a boxplot using ggplot2.
#'
#' @param x A dataframe containing the data for plotting.
#' @return A ggplot object representing the boxplot.
#' @noRd
boxplot_64 <- function(x, val="val") {
  ggplot(data=x, aes(x=val)) +
    geom_boxplot() +
    theme_64()
}
