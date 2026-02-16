# Plot ERVISS non-sentinel severity data

Creates a ggplot2 visualization of non-sentinel severity data, with
facets by country and colored by pathogen.

## Usage

``` r
plot_nonsentinel_severity(
  data,
  date_breaks = "1 month",
  date_format = "%b %Y"
)
```

## Arguments

- data:

  A data.table or data.frame containing severity data, typically output
  from [`get_nonsentinel_severity`](get_nonsentinel_severity.md). Must
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
data <- get_nonsentinel_severity(
  date_min = as.Date("2024-01-01"),
  date_max = as.Date("2024-06-30"),
  pathogen = "SARS-CoV-2",
  indicator = "hospitaladmissions"
)
plot_nonsentinel_severity(data, date_breaks = "1 month")

# }
```
