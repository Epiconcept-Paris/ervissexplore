# Plot ERVISS positivity data

Creates a ggplot2 visualization of positivity data, with facets by
country and colored by pathogen. The plot title displays mean, min and
max positivity values.

## Usage

``` r
plot_erviss_positivity(data, date_breaks = "2 weeks", date_format = "%b %Y")
```

## Arguments

- data:

  A data.table or data.frame containing positivity data, typically
  output from
  [`get_sentineltests_positivity`](get_sentineltests_positivity.md).
  Must contain columns: date, value, pathogen, countryname.

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
data <- get_sentineltests_positivity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2"
)
plot_erviss_positivity(data, date_breaks = "1 month")

# }
```
