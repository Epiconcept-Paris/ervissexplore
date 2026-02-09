# Valid data types for ERVISS
ERVISS_TYPES <- c(
  "positivity",
  "variants",
  "ili_ari_rates",
  "sari_rates",
  "sari_positivity",
  "nonsentinel_severity",
  "nonsentinel_tests"
)

#' Get ERVISS data URL
#'
#' Builds the URL to download ERVISS data, either the latest batch
#' or a specific snapshot.
#'
#' @param type Type of data. One of: "positivity", "variants", "ili_ari_rates",
#'   "sari_rates", "sari_positivity", "nonsentinel_severity", "nonsentinel_tests".
#' @param use_snapshot Logical. If TRUE, returns a snapshot URL; if FALSE (default),
#'   returns the URL for the latest data.
#' @param snapshot_date Date of the snapshot to retrieve (required if use_snapshot = TRUE).
#'   Must be a Date object.
#'
#' @return A character string containing the URL
#'
#' @export
#' @examples
#' # Get latest positivity data URL
#' get_erviss_url("positivity")
#'
#' # Get latest variants data URL
#' get_erviss_url("variants")
#'
#' # Get latest ILI/ARI rates data URL
#' get_erviss_url("ili_ari_rates")
#'
#' # Get snapshot URL
#' get_erviss_url("variants", use_snapshot = TRUE, snapshot_date = as.Date("2023-11-24"))
get_erviss_url <- function(
  type = ERVISS_TYPES,
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  type <- match.arg(type)

  switch(
    type,
    positivity = get_sentineltests_positivity_url(use_snapshot, snapshot_date),
    variants = get_erviss_variants_url(use_snapshot, snapshot_date),
    ili_ari_rates = get_ili_ari_rates_url(use_snapshot, snapshot_date),
    sari_rates = get_sari_rates_url(use_snapshot, snapshot_date),
    sari_positivity = get_sari_positivity_url(use_snapshot, snapshot_date),
    nonsentinel_severity = get_nonsentinel_severity_url(
      use_snapshot,
      snapshot_date
    ),
    nonsentinel_tests = get_nonsentinel_tests_url(use_snapshot, snapshot_date)
  )
}

#' Get ERVISS data
#'
#' Retrieves and filters data from the ERVISS (European Respiratory
#' Virus Surveillance Summary). This is a generic function that can retrieve
#' any of the available data types.
#'
#' @param type Type of data. One of: "positivity", "variants", "ili_ari_rates",
#'   "sari_rates", "sari_positivity", "nonsentinel_severity", "nonsentinel_tests".
#' @param csv_file Path to a local CSV file or URL containing the ERVISS data.
#'   If NULL (default), data is fetched from the official ERVISS repository.
#' @param date_min Start date of the period (Date object)
#' @param date_max End date of the period (Date object)
#' @param pathogen Character vector of pathogen names to filter. Used for types:
#'   "positivity", "sari_positivity", "nonsentinel_severity", "nonsentinel_tests".
#'   Use "" (default) to include all pathogens.
#' @param variant Character vector of variant names to filter. Only used for
#'   type = "variants". Use "" (default) to include all variants.
#' @param indicator Character vector of indicators to filter. The available values
#'   depend on the data type. Use "" (default) to include all indicators.
#' @param age Character vector of age groups to filter. Used for types:
#'   "ili_ari_rates", "sari_rates", "sari_positivity", "nonsentinel_severity",
#'   "nonsentinel_tests". Use "" (default) to include all age groups.
#' @param countries Character vector of country names to filter.
#'   Use "" (default) to include all countries.
#' @param min_value Minimum value threshold (default: 0).
#'   Only used for type = "variants".
#' @param use_snapshot Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
#'   fetches the latest data. Ignored if csv_file is provided.
#' @param snapshot_date Date of the snapshot to retrieve.
#'   Required if use_snapshot = TRUE and csv_file is NULL.
#'
#' @return A data.table containing the filtered data.
#'
#' @export
#' @examples
#' \dontrun{
#' # Get positivity data
#' data <- get_erviss_data(
#'   type = "positivity",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2",
#'   countries = "France"
#' )
#'
#' # Get ILI consultation rates
#' data <- get_erviss_data(
#'   type = "ili_ari_rates",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   indicator = "ILIconsultationrate",
#'   age = "total"
#' )
#'
#' # Get non-sentinel severity data
#' data <- get_erviss_data(
#'   type = "nonsentinel_severity",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2",
#'   indicator = "hospitaladmissions"
#' )
#' }
get_erviss_data <- function(
  type = ERVISS_TYPES,
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  variant = "",
  indicator = "",
  age = "",
  countries = "",
  min_value = 0,
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  type <- match.arg(type)

  switch(
    type,
    positivity = get_sentineltests_positivity(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      pathogen = pathogen,
      indicator = indicator,
      countries = countries,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    ),
    variants = get_erviss_variants(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      variant = variant,
      countries = countries,
      min_value = min_value,
      indicator = indicator,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    ),
    ili_ari_rates = get_ili_ari_rates(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      indicator = indicator,
      age = age,
      countries = countries,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    ),
    sari_rates = get_sari_rates(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      age = age,
      countries = countries,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    ),
    sari_positivity = get_sari_positivity(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      pathogen = pathogen,
      indicator = indicator,
      age = age,
      countries = countries,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    ),
    nonsentinel_severity = get_nonsentinel_severity(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      pathogen = pathogen,
      indicator = indicator,
      age = age,
      countries = countries,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    ),
    nonsentinel_tests = get_nonsentinel_tests(
      csv_file = csv_file,
      date_min = date_min,
      date_max = date_max,
      pathogen = pathogen,
      indicator = indicator,
      age = age,
      countries = countries,
      use_snapshot = use_snapshot,
      snapshot_date = snapshot_date
    )
  )
}

#' Plot ERVISS data
#'
#' Creates a ggplot2 visualization of ERVISS data, with facets by country.
#' This is a generic function that can plot any of the available data types.
#'
#' @param data A data.table or data.frame containing ERVISS data, typically output from
#'   \code{\link{get_erviss_data}}.
#' @param type Type of data. One of: "positivity", "variants", "ili_ari_rates",
#'   "sari_rates", "sari_positivity", "nonsentinel_severity", "nonsentinel_tests".
#' @param date_breaks A string specifying the date breaks for the x-axis
#'   (e.g., "1 month", "2 weeks"). If NULL, a sensible default is chosen based
#'   on the data type.
#' @param date_format A string specifying the date format for x-axis labels
#'   (e.g., `"%b %Y"` for "Jan 2024")
#'
#' @return A ggplot2 object
#'
#' @export
#' @examples
#' \dontrun{
#' # Plot positivity data
#' data <- get_erviss_data("positivity",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-06-30"),
#'   pathogen = "SARS-CoV-2"
#' )
#' plot_erviss_data(data, type = "positivity")
#'
#' # Plot ILI/ARI rates
#' data <- get_erviss_data("ili_ari_rates",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-06-30"),
#'   indicator = "ILIconsultationrate"
#' )
#' plot_erviss_data(data, type = "ili_ari_rates")
#' }
plot_erviss_data <- function(
  data,
  type = ERVISS_TYPES,
  date_breaks = NULL,
  date_format = "%b %Y"
) {
  type <- match.arg(type)

  # Set default date_breaks based on type
  if (is.null(date_breaks)) {
    date_breaks <- switch(type, positivity = "2 weeks", "1 month")
  }

  switch(
    type,
    positivity = plot_erviss_positivity(data, date_breaks, date_format),
    variants = plot_erviss_variants(data, date_breaks, date_format),
    ili_ari_rates = plot_ili_ari_rates(data, date_breaks, date_format),
    sari_rates = plot_sari_rates(data, date_breaks, date_format),
    sari_positivity = plot_sari_positivity(data, date_breaks, date_format),
    nonsentinel_severity = plot_nonsentinel_severity(
      data,
      date_breaks,
      date_format
    ),
    nonsentinel_tests = plot_nonsentinel_tests(data, date_breaks, date_format)
  )
}

#' Quick plot of ERVISS data
#'
#' Convenience function that fetches and plots ERVISS data in one step.
#' This is a generic function that can handle any of the available data types.
#' For more control, use \code{\link{get_erviss_data}} followed by
#' \code{\link{plot_erviss_data}}.
#'
#' @inheritParams get_erviss_data
#' @param date_breaks A string specifying the date breaks for the x-axis
#'   (e.g., "1 month", "2 weeks"). If NULL, a sensible default is chosen based
#'   on the data type.
#' @param date_format A string specifying the date format for x-axis labels
#'   (e.g., `"%b %Y"` for "Jan 2024")
#'
#' @return A ggplot2 object showing the data over time by country
#'
#' @import ggplot2
#' @import data.table
#' @export
#' @examples
#' \dontrun{
#' # Quick visualization of positivity data
#' quick_plot_erviss_data(
#'   type = "positivity",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   pathogen = "SARS-CoV-2"
#' )
#'
#' # Quick visualization of ILI rates
#' quick_plot_erviss_data(
#'   type = "ili_ari_rates",
#'   date_min = as.Date("2024-01-01"),
#'   date_max = as.Date("2024-12-31"),
#'   indicator = "ILIconsultationrate"
#' )
#' }
quick_plot_erviss_data <- function(
  type = ERVISS_TYPES,
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  variant = "",
  indicator = "",
  age = "",
  countries = "",
  min_value = 0,
  date_breaks = NULL,
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
) {
  type <- match.arg(type)

  data <- get_erviss_data(
    type = type,
    csv_file = csv_file,
    date_min = date_min,
    date_max = date_max,
    pathogen = pathogen,
    variant = variant,
    indicator = indicator,
    age = age,
    countries = countries,
    min_value = min_value,
    use_snapshot = use_snapshot,
    snapshot_date = snapshot_date
  )

  plot_erviss_data(
    data = data,
    type = type,
    date_breaks = date_breaks,
    date_format = date_format
  )
}
