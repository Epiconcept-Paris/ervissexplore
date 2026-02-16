# Quick plot of ERVISS positivity data

Convenience function that fetches and plots ERVISS positivity data in
one step. For more control, use
[`get_sentineltests_positivity`](get_sentineltests_positivity.md)
followed by [`plot_erviss_positivity`](plot_erviss_positivity.md).

## Usage

``` r
quick_plot_erviss_positivity(
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  indicator = "",
  countries = "",
  date_breaks = "2 weeks",
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
)
```

## Arguments

- csv_file:

  Path to a local CSV file or URL containing the ERVISS data. If NULL
  (default), data is fetched from the official ERVISS repository.

- date_min:

  Start date of the period (Date object)

- date_max:

  End date of the period (Date object)

- pathogen:

  Character vector of pathogen names to filter. Use "" (default) to
  include all pathogens.

- indicator:

  Character vector of indicators to filter: "positivity", "detections",
  "tests", or any combination. Use "" (default) to include all
  indicators.

- countries:

  Character vector of country names to filter. Use "" (default) to
  include all countries.

- date_breaks:

  A string specifying the date breaks for the x-axis (e.g., "1 month",
  "2 weeks")

- date_format:

  A string specifying the date format for x-axis labels (e.g., `"%b %Y"`
  for "Jan 2024")

- use_snapshot:

  Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
  fetches the latest data. Ignored if csv_file is provided.

- snapshot_date:

  Date of the snapshot to retrieve. Required if use_snapshot = TRUE and
  csv_file is NULL.

## Value

A ggplot2 object showing positivity over time by country and pathogen

## Examples

``` r
# \donttest{
# Quick visualization of latest data
quick_plot_erviss_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  date_breaks = "1 month"
)

# }
```
