# Plot ERVISS SARI positivity data

Creates a ggplot2 visualization of SARI positivity data, with facets by
country and colored by pathogen.

## Usage

``` r
plot_sari_positivity(data, date_breaks = "2 weeks", date_format = "%b %Y")
```

## Arguments

- data:

  A data.table or data.frame containing SARI positivity data, typically
  output from [`get_sari_positivity`](get_sari_positivity.md). Must
  contain columns: date, value, pathogen, countryname.

- date_breaks:

  A string specifying the date breaks for the x-axis (e.g., "1 month",
  "2 weeks")

- date_format:

  A string specifying the date format for x-axis labels (e.g., `"%b %Y"`
  for "Jan 2024")

## Value

A ggplot2 object

## Examples

``` r
# \donttest{
data <- get_sari_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "Influenza",
  indicator = "positivity"
)
plot_sari_positivity(data, date_breaks = "1 month")

# }
```
