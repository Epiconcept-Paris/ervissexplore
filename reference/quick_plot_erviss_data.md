# Quick plot of ERVISS data

Convenience function that fetches and plots ERVISS data in one step.
This is a generic function that can handle either positivity or variants
data. For more control, use [`get_erviss_data`](get_erviss_data.md)
followed by [`plot_erviss_data`](plot_erviss_data.md).

## Usage

``` r
quick_plot_erviss_data(
  type = c("positivity", "variants"),
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  variant = "",
  countries = "",
  min_value = 0,
  indicator = "proportion",
  date_breaks = NULL,
  date_format = "%b %Y",
  use_snapshot = FALSE,
  snapshot_date = NULL
)
```

## Arguments

- type:

  Type of data: "positivity" or "variants"

- csv_file:

  Path to a local CSV file or URL containing the ERVISS data. If NULL
  (default), data is fetched from the official ERVISS repository.

- date_min:

  Start date of the period (Date object)

- date_max:

  End date of the period (Date object)

- pathogen:

  Character vector of pathogen names to filter (for type =
  "positivity"). Use "" (default) to include all pathogens. Ignored if
  type = "variants".

- variant:

  Character vector of variant names to filter (for type = "variants").
  Use "" (default) to include all variants. Ignored if type =
  "positivity".

- countries:

  Character vector of country names to filter. Use "" (default) to
  include all countries.

- min_value:

  Minimum value threshold to include in the results (default: 0). Only
  used for type = "variants".

- indicator:

  Type of indicator for variants: "proportion" (default) or
  "detections". Only used for type = "variants".

- date_breaks:

  A string specifying the date breaks for the x-axis (e.g., "1 month",
  "2 weeks"). If NULL, defaults to "2 weeks" for positivity and "1
  month" for variants.

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

A ggplot2 object showing the data over time by country

## Examples

``` r
if (FALSE) { # \dontrun{
# Quick visualization of positivity data
quick_plot_erviss_data(
  type = "positivity",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  date_breaks = "1 month"
)

# Quick visualization of variants data
quick_plot_erviss_data(
  type = "variants",
  date_min = as.Date("2024-06-01"),
  date_max = as.Date("2024-12-31"),
  variant = c("XFG", "LP.8.1")
)
} # }
```
