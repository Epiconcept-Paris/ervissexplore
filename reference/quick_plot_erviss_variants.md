# Quick plot of ERVISS variants data

Convenience function that fetches and plots ERVISS variant data in one
step. For more control, use
[`get_erviss_variants`](get_erviss_variants.md) followed by
[`plot_erviss_variants`](plot_erviss_variants.md).

## Usage

``` r
quick_plot_erviss_variants(
  csv_file = NULL,
  date_min,
  date_max,
  variant = "",
  countries = "",
  min_value = 0,
  indicator = "",
  date_breaks = "1 month",
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

- variant:

  Character vector of variant names to filter. Use "" (default) to
  include all variants.

- countries:

  Character vector of country names to filter. Use "" (default) to
  include all countries.

- min_value:

  Minimum value threshold to include in the results (default: 0)

- indicator:

  Type of indicator: "proportion" or "detections". Use "" (default) to
  include all indicators.

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

A ggplot2 object showing variant proportions over time by country

## Examples

``` r
if (FALSE) { # \dontrun{
# Quick visualization of latest variant data
quick_plot_erviss_variants(
  date_min = as.Date("2024-06-01"),
  date_max = as.Date("2024-12-31"),
  variant = c("XFG", "LP.8.1"),
  date_breaks = "1 month"
)
} # }
```
