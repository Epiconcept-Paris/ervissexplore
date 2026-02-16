# Plot ERVISS non-sentinel tests/detections data

Creates a ggplot2 visualization of non-sentinel tests/detections data,
with facets by country and colored by pathogen.

## Usage

``` r
plot_nonsentinel_tests(data, date_breaks = "1 month", date_format = "%b %Y")
```

## Arguments

- data:

  A data.table or data.frame containing non-sentinel tests data,
  typically output from
  [`get_nonsentinel_tests`](get_nonsentinel_tests.md). Must contain
  columns: date, value, pathogen, countryname.

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
data <- get_nonsentinel_tests(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "Influenza",
  indicator = "detections"
)
plot_nonsentinel_tests(data, date_breaks = "1 month")

# }
```
