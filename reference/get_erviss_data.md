# Get ERVISS data

Retrieves and filters data from the ERVISS (European Respiratory Virus
Surveillance Summary). This is a generic function that can retrieve any
of the available data types.

## Usage

``` r
get_erviss_data(
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
)
```

## Arguments

- type:

  Type of data. One of: "positivity", "variants", "ili_ari_rates",
  "sari_rates", "sari_positivity", "nonsentinel_severity",
  "nonsentinel_tests".

- csv_file:

  Path to a local CSV file or URL containing the ERVISS data. If NULL
  (default), data is fetched from the official ERVISS repository.

- date_min:

  Start date of the period (Date object)

- date_max:

  End date of the period (Date object)

- pathogen:

  Character vector of pathogen names to filter. Used for types:
  "positivity", "sari_positivity", "nonsentinel_severity",
  "nonsentinel_tests". Use "" (default) to include all pathogens.

- variant:

  Character vector of variant names to filter. Only used for type =
  "variants". Use "" (default) to include all variants.

- indicator:

  Character vector of indicators to filter. The available values depend
  on the data type. Use "" (default) to include all indicators.

- age:

  Character vector of age groups to filter. Used for types:
  "ili_ari_rates", "sari_rates", "sari_positivity",
  "nonsentinel_severity", "nonsentinel_tests". Use "" (default) to
  include all age groups.

- countries:

  Character vector of country names to filter. Use "" (default) to
  include all countries.

- min_value:

  Minimum value threshold (default: 0). Only used for type = "variants".

- use_snapshot:

  Logical. If TRUE, fetches a historical snapshot; if FALSE (default),
  fetches the latest data. Ignored if csv_file is provided.

- snapshot_date:

  Date of the snapshot to retrieve. Required if use_snapshot = TRUE and
  csv_file is NULL.

## Value

A data.table containing the filtered data.

## Examples

``` r
# \donttest{
# Get positivity data
data <- get_erviss_data(
  type = "positivity",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  countries = "France"
)

# Get ILI consultation rates
data <- get_erviss_data(
  type = "ili_ari_rates",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  indicator = "ILIconsultationrate",
  age = "total"
)

# Get non-sentinel severity data
data <- get_erviss_data(
  type = "nonsentinel_severity",
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-12-31"),
  pathogen = "SARS-CoV-2",
  indicator = "hospitaladmissions"
)
# }
```
