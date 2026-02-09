fixture_path <- test_path("fixtures", "variants.csv")

test_that("get_erviss_variants reads data and returns data.table", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result, "data.table")
  expect_true(nrow(result) > 0)
  expect_true("date" %in% names(result))
  expect_true("variant" %in% names(result))
  expect_true("value" %in% names(result))
})

test_that("get_erviss_variants filters by variant", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    variant = "XFG"
  )
  expect_true(all(result$variant == "XFG"))
})

test_that("get_erviss_variants filters by multiple variants", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    variant = c("XFG", "LP.8.1")
  )
  expect_true(all(result$variant %in% c("XFG", "LP.8.1")))
})

test_that("get_erviss_variants filters by countries", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    countries = "Germany"
  )
  expect_true(all(result$countryname == "Germany"))
})

test_that("get_erviss_variants filters by min_value", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    min_value = 40
  )
  expect_true(all(result$value >= 40))
})

test_that("get_erviss_variants filters by indicator", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "proportion"
  )
  expect_true(all(result$indicator == "proportion"))
})

test_that("get_erviss_variants rejects invalid indicator", {
  expect_error(
    get_erviss_variants(
      csv_file = fixture_path,
      date_min = as.Date("2024-01-01"),
      date_max = as.Date("2024-12-31"),
      indicator = "invalid"
    ),
    "Invalid value"
  )
})

test_that("get_erviss_variants filters by date range", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-08"),
    date_max = as.Date("2024-01-14")
  )
  expect_true(all(result$date >= as.Date("2024-01-08")))
  expect_true(all(result$date <= as.Date("2024-01-14")))
})

test_that("get_erviss_variants returns empty for out-of-range dates", {
  expect_message(
    result <- get_erviss_variants(
      csv_file = fixture_path,
      date_min = as.Date("2020-01-01"),
      date_max = as.Date("2020-12-31")
    ),
    "No data found"
  )
  expect_equal(nrow(result), 0)
})

test_that("get_erviss_variants combines variant + country + min_value filters", {
  result <- get_erviss_variants(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    variant = "XFG",
    countries = "France",
    min_value = 40,
    indicator = "proportion"
  )
  expect_true(all(result$variant == "XFG"))
  expect_true(all(result$countryname == "France"))
  expect_true(all(result$value >= 40))
  expect_true(all(result$indicator == "proportion"))
})
