library(dplyr)
library(ggplot2)


save_plot_helper <- function(save_plot, output_folder, file_name, p, figsize) {
  if (save_plot) {
    if (!dir.exists(output_folder)) {
      dir.create(output_folder, recursive = TRUE)
    }
    
    full_path <- file.path(output_folder, file_name)
    
    ggplot2::ggsave(
      filename = full_path,
      plot = p,
      width = figsize[1],
      height = figsize[2]
    )
  }
}

plot_missings_countries <- function(
  countries_with_NA, save_plot = TRUE, output_folder = "plots",
  file_name = "missing_values_plot.png", figsize = c(6, 8)
) {
  p <- countries_with_NA |>
    dplyr::filter(has_missing == TRUE) |>
    ggplot2::ggplot(ggplot2::aes(
      x = reorder(unit, missing_count),
      y = missing_count
    )) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::theme_classic() +
    ggplot2::labs(
      x = "Country",
      y = "Count of Missing Values"
    )

  print(p)

  save_plot_helper(save_plot, output_folder, file_name, p, figsize)

  invisible(p)
}

plot_vdem <- function(res, func, file_name,
                      save_plot = TRUE, output_folder = "plots",
                      figsize = c(6, 8)) {
  p <- res |> func()

  print(p)

  save_plot_helper(save_plot, output_folder, file_name, p, figsize)

  invisible(p)
}
