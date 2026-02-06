# Get ERVISS variants data

Retrieves and filters SARS-CoV-2 variant data from the ERVISS (European
Respiratory Virus Surveillance Summary) for a specified date range,
variant(s), and country(ies).

## Usage

``` r
get_erviss_variants(
  csv_file = NULL,
  date_min,
  date_max,
  variant = "",
  countries = "",
  min_value = 0,
  indicator = "",
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

- use_snapshot:

  Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
  fetches the latest data. Ignored if csv_file is provided.

- snapshot_date:

  Date of the snapshot to retrieve. Required if use_snapshot = TRUE and
  csv_file is NULL.

## Value

A data.table containing the filtered variant data with columns: date,
value, variant, countryname, indicator, and other ERVISS fields.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get latest variant data for France
data <- get_erviss_variants(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  countries = "France"
)

# Get specific variants with minimum proportion threshold
data <- get_erviss_variants(
  date_min = as.Date("2024-06-01"),
  date_max = as.Date("2024-12-31"),
  variant = c("XFG", "LP.8.1"),
  min_value = 5
)
} # }
```
