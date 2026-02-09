fixture_path <- test_path("fixtures", "ili_ari_rates.csv")

test_that("get_ili_ari_rates reads data and returns data.table", {
  result <- get_ili_ari_rates(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31")
  )
  expect_s3_class(result, "data.table")
  expect_true(nrow(result) > 0)
  expect_true("date" %in% names(result))
  expect_true("indicator" %in% names(result))
  expect_true("age" %in% names(result))
  expect_true("value" %in% names(result))
})

test_that("get_ili_ari_rates filters by indicator", {
  result <- get_ili_ari_rates(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "ILIconsultationrate"
  )
  expect_true(all(result$indicator == "ILIconsultationrate"))
})

test_that("get_ili_ari_rates filters by age group", {
  result <- get_ili_ari_rates(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    age = "0-4"
  )
  expect_true(all(result$age == "0-4"))
})

test_that("get_ili_ari_rates filters by countries", {
  result <- get_ili_ari_rates(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    countries = "Germany"
  )
  expect_true(all(result$countryname == "Germany"))
})

test_that("get_ili_ari_rates combines indicator + age + country filters", {
  result <- get_ili_ari_rates(
    csv_file = fixture_path,
    date_min = as.Date("2024-01-01"),
    date_max = as.Date("2024-12-31"),
    indicator = "ILIconsultationrate",
    age = "total",
    countries = "France"
  )
  expect_true(all(result$indicator == "ILIconsultationrate"))
  expect_true(all(result$age == "total"))
  expect_true(all(result$countryname == "France"))
})

test_that("get_ili_ari_rates rejects invalid indicator", {
  expect_error(
    get_ili_ari_rates(
      csv_file = fixture_path,
      date_min = as.Date("2024-01-01"),
      date_max = as.Date("2024-12-31"),
      indicator = "positivity"
    ),
    "Invalid value"
  )
})

test_that("get_ili_ari_rates returns empty for out-of-range dates", {
  expect_message(
    result <- get_ili_ari_rates(
      csv_file = fixture_path,
      date_min = as.Date("2020-01-01"),
      date_max = as.Date("2020-12-31")
    ),
    "No data found"
  )
  expect_equal(nrow(result), 0)
})
