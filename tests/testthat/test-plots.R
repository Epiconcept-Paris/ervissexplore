# --- Plot positivity ---

test_that("plot_erviss_positivity returns a ggplot object", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08", "2024-01-15")),
    value = c(12.5, 11.3, 10.1),
    pathogen = rep("SARS-CoV-2", 3),
    countryname = rep("France", 3)
  )
  p <- plot_erviss_positivity(data)
  expect_s3_class(p, "ggplot")
})

test_that("plot_erviss_positivity title contains statistics", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08", "2024-01-15")),
    value = c(10, 20, 30),
    pathogen = rep("SARS-CoV-2", 3),
    countryname = rep("France", 3)
  )
  p <- plot_erviss_positivity(data)
  expect_match(p$labels$title, "Mean positivity")
  expect_match(p$labels$title, "20.00")
  expect_match(p$labels$title, "10.00")
  expect_match(p$labels$title, "30.00")
})

test_that("plot_erviss_positivity has correct y-axis label", {
  data <- data.table::data.table(
    date = as.Date("2024-01-01"),
    value = 10,
    pathogen = "SARS-CoV-2",
    countryname = "France"
  )
  p <- plot_erviss_positivity(data)
  expect_equal(p$labels$y, "Positivity")
})

# --- Plot variants ---

test_that("plot_erviss_variants returns a ggplot object", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08", "2024-01-15")),
    value = c(45.2, 42.1, 38.5),
    variant = rep("XFG", 3),
    countryname = rep("France", 3)
  )
  p <- plot_erviss_variants(data)
  expect_s3_class(p, "ggplot")
})

test_that("plot_erviss_variants has correct y-axis label", {
  data <- data.table::data.table(
    date = as.Date("2024-01-01"),
    value = 45.2,
    variant = "XFG",
    countryname = "France"
  )
  p <- plot_erviss_variants(data)
  expect_equal(p$labels$y, "% of all variants")
})

# --- Plot ILI/ARI rates ---

test_that("plot_ili_ari_rates returns a ggplot object", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(120.5, 115.3),
    age = rep("total", 2),
    countryname = rep("France", 2)
  )
  p <- plot_ili_ari_rates(data)
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "Consultation rate")
})

# --- Plot SARI rates ---

test_that("plot_sari_rates returns a ggplot object", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(5.2, 5.8),
    age = rep("total", 2),
    countryname = rep("France", 2)
  )
  p <- plot_sari_rates(data)
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "SARI rate")
})

# --- Plot SARI positivity ---

test_that("plot_sari_positivity returns a ggplot object", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(15.2, 14.8),
    pathogen = rep("Influenza", 2),
    countryname = rep("France", 2)
  )
  p <- plot_sari_positivity(data)
  expect_s3_class(p, "ggplot")
})

test_that("plot_sari_positivity title contains statistics", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08", "2024-01-15")),
    value = c(10, 20, 30),
    pathogen = rep("Influenza", 3),
    countryname = rep("France", 3)
  )
  p <- plot_sari_positivity(data)
  expect_match(p$labels$title, "Mean")
  expect_match(p$labels$title, "20.00")
})

# --- Plot non-sentinel severity ---

test_that("plot_nonsentinel_severity returns a ggplot object", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(450, 420),
    pathogen = rep("SARS-CoV-2", 2),
    countryname = rep("France", 2)
  )
  p <- plot_nonsentinel_severity(data)
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "Count")
})

# --- Plot non-sentinel tests ---

test_that("plot_nonsentinel_tests returns a ggplot object", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(500, 480),
    pathogen = rep("Influenza", 2),
    countryname = rep("France", 2)
  )
  p <- plot_nonsentinel_tests(data)
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "Count")
})

# --- date_breaks and date_format parameters ---

test_that("plot functions accept custom date_breaks and date_format", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-02-01", "2024-03-01")),
    value = c(10, 20, 30),
    pathogen = rep("SARS-CoV-2", 3),
    countryname = rep("France", 3)
  )
  p <- plot_erviss_positivity(
    data,
    date_breaks = "1 month",
    date_format = "%Y-%m"
  )
  expect_s3_class(p, "ggplot")
})

# --- theme_erviss ---

test_that("theme_erviss returns a ggplot theme", {
  th <- ervissexplore:::theme_erviss()
  expect_s3_class(th, "theme")
})
