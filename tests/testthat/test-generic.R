positivity_path <- test_path("fixtures", "sentinel_positivity.csv")
variants_path <- test_path("fixtures", "variants.csv")
ili_ari_path <- test_path("fixtures", "ili_ari_rates.csv")
sari_rates_path <- test_path("fixtures", "sari_rates.csv")
sari_positivity_path <- test_path("fixtures", "sari_positivity.csv")
severity_path <- test_path("fixtures", "nonsentinel_severity.csv")
tests_path <- test_path("fixtures", "nonsentinel_tests.csv")

# --- get_erviss_data dispatcher ---

test_that("get_erviss_data dispatches to positivity", {
  direct <- get_sentineltests_positivity(
    csv_file = positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2",
    countries = "France"
  )
  generic <- get_erviss_data(
    type = "positivity",
    csv_file = positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2",
    countries = "France"
  )
  expect_equal(generic, direct)
})

test_that("get_erviss_data dispatches to variants", {
  direct <- get_erviss_variants(
    csv_file = variants_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    variant = "XFG"
  )
  generic <- get_erviss_data(
    type = "variants",
    csv_file = variants_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    variant = "XFG"
  )
  expect_equal(generic, direct)
})

test_that("get_erviss_data dispatches to ili_ari_rates", {
  direct <- get_ili_ari_rates(
    csv_file = ili_ari_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "ILIconsultationrate"
  )
  generic <- get_erviss_data(
    type = "ili_ari_rates",
    csv_file = ili_ari_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "ILIconsultationrate"
  )
  expect_equal(generic, direct)
})

test_that("get_erviss_data dispatches to sari_rates", {
  direct <- get_sari_rates(
    csv_file = sari_rates_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = "total"
  )
  generic <- get_erviss_data(
    type = "sari_rates",
    csv_file = sari_rates_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = "total"
  )
  expect_equal(generic, direct)
})

test_that("get_erviss_data dispatches to sari_positivity", {
  direct <- get_sari_positivity(
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "Influenza"
  )
  generic <- get_erviss_data(
    type = "sari_positivity",
    csv_file = sari_positivity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "Influenza"
  )
  expect_equal(generic, direct)
})

test_that("get_erviss_data dispatches to nonsentinel_severity", {
  direct <- get_nonsentinel_severity(
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2"
  )
  generic <- get_erviss_data(
    type = "nonsentinel_severity",
    csv_file = severity_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "SARS-CoV-2"
  )
  expect_equal(generic, direct)
})

test_that("get_erviss_data dispatches to nonsentinel_tests", {
  direct <- get_nonsentinel_tests(
    csv_file = tests_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "Influenza"
  )
  generic <- get_erviss_data(
    type = "nonsentinel_tests",
    csv_file = tests_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    pathogen = "Influenza"
  )
  expect_equal(generic, direct)
})

test_that("get_erviss_data errors on invalid type", {
  expect_error(
    get_erviss_data(
      type = "invalid",
      date_min = as.Date("2024-01-01"),
      date_max = as.Date("2024-12-31")
    ),
    "arg"
  )
})

# --- plot_erviss_data dispatcher ---

test_that("plot_erviss_data dispatches to positivity", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(12.5, 11.3),
    pathogen = rep("SARS-CoV-2", 2),
    countryname = rep("France", 2)
  )
  p <- plot_erviss_data(data, type = "positivity")
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "Positivity")
})

test_that("plot_erviss_data dispatches to variants", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(45.2, 42.1),
    variant = rep("XFG", 2),
    countryname = rep("France", 2)
  )
  p <- plot_erviss_data(data, type = "variants")
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "% of all variants")
})

test_that("plot_erviss_data dispatches to ili_ari_rates", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(120.5, 115.3),
    age = rep("total", 2),
    countryname = rep("France", 2)
  )
  p <- plot_erviss_data(data, type = "ili_ari_rates")
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "Consultation rate")
})

test_that("plot_erviss_data dispatches to sari_rates", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(5.2, 5.8),
    age = rep("total", 2),
    countryname = rep("France", 2)
  )
  p <- plot_erviss_data(data, type = "sari_rates")
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "SARI rate")
})

test_that("plot_erviss_data dispatches to nonsentinel_severity", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(450, 420),
    pathogen = rep("SARS-CoV-2", 2),
    countryname = rep("France", 2)
  )
  p <- plot_erviss_data(data, type = "nonsentinel_severity")
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "Count")
})

test_that("plot_erviss_data dispatches to nonsentinel_tests", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(500, 480),
    pathogen = rep("Influenza", 2),
    countryname = rep("France", 2)
  )
  p <- plot_erviss_data(data, type = "nonsentinel_tests")
  expect_s3_class(p, "ggplot")
  expect_equal(p$labels$y, "Count")
})

test_that("plot_erviss_data errors on invalid type", {
  data <- data.table::data.table(
    date = as.Date("2024-01-01"),
    value = 10,
    pathogen = "X",
    countryname = "France"
  )
  expect_error(plot_erviss_data(data, type = "invalid"), "arg")
})

test_that("plot_erviss_data sets default date_breaks based on type", {
  data <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-01-08")),
    value = c(12.5, 11.3),
    pathogen = rep("SARS-CoV-2", 2),
    countryname = rep("France", 2)
  )
  # For positivity, default is "2 weeks"
  p_pos <- plot_erviss_data(data, type = "positivity")
  expect_s3_class(p_pos, "ggplot")

  # For variants, default is "1 month"
  data_var <- data.table::data.table(
    date = as.Date(c("2024-01-01", "2024-02-01")),
    value = c(45, 42),
    variant = rep("XFG", 2),
    countryname = rep("France", 2)
  )
  p_var <- plot_erviss_data(data_var, type = "variants")
  expect_s3_class(p_var, "ggplot")
})

# --- ERVISS_TYPES constant ---

test_that("ERVISS_TYPES contains all expected data types", {
  types <- ervissexplore:::ERVISS_TYPES
  expect_equal(
    types,
    c(
      "positivity",
      "variants",
      "ili_ari_rates",
      "sari_rates",
      "sari_positivity",
      "nonsentinel_severity",
      "nonsentinel_tests"
    )
  )
})
