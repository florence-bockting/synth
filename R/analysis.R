library(dplyr)
library(tidysynth)
library(tidyr)


create_panel <- function(time_period, vdem_dataset) {
  vdem_dataset |>
    dplyr::select(
      country_name,
      year,
      v2x_libdem,
      v2x_polyarchy,
      v2x_freexp_altinf
    ) |>
    dplyr::rename(
      unit = country_name,
      time = year,
      outcome = v2x_libdem
    ) |>
    dplyr::filter(dplyr::between(time, time_period[1], time_period[2]))
}


completeness_check <- function(vdem_panel, time_period) {
  vdem_panel |>
    tidyr::complete(unit, time = time_period[1]:time_period[2]) |>
    dplyr::group_by(unit) |>
    dplyr::summarise(
      has_missing = any(is.na(outcome)),
      missing_count = sum(is.na(outcome)),
      missing_years = list(time[is.na(outcome)])
    )
}


generate_synth_control <- function(
  vdem_panel, country, intervention_year, time_period,
  time_period_optim, list_countries
) {
  vdem_panel |>
    dplyr::filter(unit %in% list_countries) |>
    tidysynth::synthetic_control(
      outcome = outcome,
      unit = unit,
      time = time,
      i_unit = country,
      i_time = intervention_year,
      generate_placebos = TRUE
    ) |>
    tidysynth::generate_predictor(
      time_window = time_period[1]:time_period[2],
      polyarchy_pre = mean(v2x_polyarchy, na.rm = TRUE),
      media_pre = mean(v2x_freexp_altinf, na.rm = TRUE)
    ) |>
    tidysynth::generate_weights(
      optimization_window = time_period_optim[1]:time_period_optim[2]
    ) |>
    tidysynth::generate_control()
}
