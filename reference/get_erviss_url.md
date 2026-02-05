# Get ERVISS data URL

Builds the URL to download ERVISS data, either the latest batch or a
specific snapshot.

## Usage

``` r
get_erviss_url(
  type = c("positivity", "variants"),
  use_snapshot = FALSE,
  snapshot_date = NULL
)
```

## Arguments

- type:

  Type of data: "positivity" or "variants"

- use_snapshot:

  Logical. If TRUE, returns a snapshot URL; if FALSE (default), returns
  the URL for the latest data.

- snapshot_date:

  Date of the snapshot to retrieve (required if use_snapshot = TRUE).
  Must be a Date object.

## Value

A character string containing the URL

## Examples

``` r
# Get latest positivity data URL
get_erviss_url("positivity")
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/sentinelTestsDetectionsPositivity.csv"

# Get latest variants data URL
get_erviss_url("variants")
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/variants.csv"

# Get snapshot URL
get_erviss_url("variants", use_snapshot = TRUE, snapshot_date = as.Date("2023-11-24"))
#> [1] "https://raw.githubusercontent.com/EU-ECDC/Respiratory_viruses_weekly_data/refs/heads/main/data/snapshots/2023-11-24_variants.csv"
```
