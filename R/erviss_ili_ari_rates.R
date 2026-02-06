#' Get ERVISS ILI/ARI consultation rates data
#'
#' Retrieves and filters ILI (Influenza-Like Illness) and ARI (Acute Respiratory
#' Infection) consultation rates from the ERVISS (European Respiratory Virus
#' Surveillance Summary) for a specified date range, indicator(s), age group(s),
#' and country(ies).
#'
#' @param csv_file Path to a local CSV file or URL containing the ERVISS data.
#'   If NULL (default), data is fetched from the official ERVISS repository.
#' @param date_min Start date of the period (Date object)
#' @param date_max End date of the period (Date object)
#' @param indicator Character vector of indicators to filter:
#'   "ILIconsultationrate", "ARIconsultationrate", or both.
#'   Use "" (default) to include all indicators.
#' @param age Character vector of age groups to filter (e.g., "0-4", "5-14",
#'   "15-64", "65+", "total").
#'   Use "" (default) to include all age groups.
#' @param countries Character vector of country names to filter.
#'   Use "" (default) to include all countries.
#' @param use_snapshot Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
#'   fetches the latest data. Ignored if csv_file is provided.
#' @param snapshot_date Date of the snapshot to retrieve.
#'   Required if use_snapshot = TRUE and csv_file is NULL.
#'
#' @return A data.table containing the filtered ILI/ARI rates data with columns:
#'   survtype, countryname, date, indicator, age, value.
#'
#' @export
#' @examples
#' \dontrun{
#' # Get ILI consultation rates for France
#' data <- get_ili_ari_rates(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   indicator = "ILIconsultationrate",
#'   countries = "France"
#' )
#'
#' # Get both ILI and ARI rates for all countries
#' data <- get_ili_ari_rates(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31")
#' )
#' }
get_ili_ari_rates <- function(
  csv_file = NULL,
  date_min,
  date_max,
  indicator = "",
  age = "",
  countries = "",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  if (is.null(csv_file)) {
    csv_file <- get_ili_ari_rates_url(use_snapshot, snapshot_date)
  }
  assert_file_or_url(csv_file, "csv_file")
  assert_date(date_min, "date_min")
  assert_date(date_max, "date_max")

  dt <- data.table::fread(csv_file)
  dt[, date := yearweek_to_date(yearweek)]

  if (any(indicator != "")) {
    indicator_filter <- indicator
    dt <- dt[indicator %chin% indicator_filter]
  }

  if (any(age != "")) {
    age_filter <- age
    dt <- dt[age %chin% age_filter]
  }

  if (any(countries != "")) {
    dt <- dt[countryname %chin% countries]
  }

  dt[date >= date_min & date <= date_max]
}

#' Plot ERVISS ILI/ARI consultation rates data
#'
#' Creates a ggplot2 visualization of ILI/ARI consultation rates, with facets
#' by country and colored by age group.
#'
#' @param data A data.table or data.frame containing ILI/ARI rates data, typically
#'   output from \code{\link{get_ili_ari_rates}}. Must contain columns: date, value,
#'   age, countryname.
#' @param date_breaks A string specifying the date breaks for the x-axis
#'   (e.g., "1 month", "2 weeks")
#' @param date_format A string specifying the date format for x-axis labels
#'   (e.g., `"%b %Y"` for "Jan 2024")
#'
#' @return A ggplot2 object
#'
#' @export
#' @examples
#' \dontrun{
#' data <- get_ili_ari_rates(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-06-30"),
#'   indicator = "ILIconsultationrate"
#' )
#' plot_ili_ari_rates(data, date_breaks = "1 month")
#' }
plot_ili_ari_rates <- function(
  data,
  date_breaks = "2 weeks",
  date_format = "%b %Y"
) {
  ggplot(data, aes(x = date, y = value, color = age)) +
    geom_line() +
    xlab("") +
    ylab("Consultation rate") +
    facet_wrap(~countryname, scales = "free", ncol = 3) +
    scale_x_date(date_breaks = date_breaks, date_labels = date_format) +
    scale_colour_viridis_d(name = "Age group") +
    theme_erviss()
}

#' Quick plot of ERVISS ILI/ARI consultation rates data
#'
#' Convenience function that fetches and plots ERVISS ILI/ARI consultation rates
#' data in one step.
#' For more control, use \code{\link{get_ili_ari_rates}} followed by
#' \code{\link{plot_ili_ari_rates}}.
#'
#' @inheritParams get_ili_ari_rates
#' @inheritParams plot_ili_ari_rates
#'
#' @return A ggplot2 object showing ILI/ARI consultation rates over time
#'   by country and age group
#'
#' @import ggplot2
#' @import data.table
#' @export
#' @examples
#' \dontrun{
#' # Quick visualization of ILI rates
#' quick_plot_ili_ari_rates(
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   indicator = "ILIconsultationrate",
#'   date_breaks = "1 month"
#' )
#' }
quick_plot_ili_ari_rates <- function(
  csv_file = NULL,
  date_min,
  date_max,
  indicator = "",
  age = "",
  countries = "",
  date_breaks = "2 weeks",
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  data <- get_ili_ari_rates(
    csv_file,
    date_min,
    date_max,
    indicator,
    age,
    countries,
    use_snapshot,
    snapshot_date
  )

  plot_ili_ari_rates(data, date_breaks, date_format)
}
