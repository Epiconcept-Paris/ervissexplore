# Get ERVISS data

Retrieves and filters data from the ERVISS (European Respiratory Virus
Surveillance Summary) for a specified date range, pathogen/variant(s),
and country(ies). This is a generic function that can retrieve either
positivity or variants data.

## Usage

``` r
get_erviss_data(
  type = c("positivity", "variants"),
  csv_file = NULL,
  date_min,
  date_max,
  pathogen = "",
  variant = "",
  countries = "",
  min_value = 0,
  indicator = "proportion",
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

- use_snapshot:

  Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
  fetches the latest data. Ignored if csv_file is provided.

- snapshot_date:

  Date of the snapshot to retrieve. Required if use_snapshot = TRUE and
  csv_file is NULL.

## Value

A data.table containing the filtered data with columns including: date,
value, countryname, and other ERVISS fields.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get positivity data
data <- get_erviss_data(
  type = "positivity",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  countries = "France"
)

# Get variants data
data <- get_erviss_data(
  type = "variants",
  date_min = as.Date("2024-06-01"),
  date_max = as.Date("2024-12-31"),
  variant = c("XFG", "LP.8.1"),
  min_value = 5
)
} # }
```
