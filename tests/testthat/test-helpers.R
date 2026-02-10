test_that("yearweek_to_date converts correctly", {
  # Standard week
  expect_equal(
    ervissexplore:::yearweek_to_date("2024-W01"),
    as.Date("2024-01-01")
  )

  # Mid-year week
  expect_equal(
    ervissexplore:::yearweek_to_date("2024-W10"),
    as.Date("2024-03-04")
  )

  # Last week of year
  expect_equal(
    ervissexplore:::yearweek_to_date("2023-W52"),
    as.Date("2023-12-25")
  )

  # Week 1 of 2023 (Jan 4 2023 is a Wednesday)
  expect_equal(
    ervissexplore:::yearweek_to_date("2023-W01"),
    as.Date("2023-01-02")
  )

  # Vectorized usage
  result <- ervissexplore:::yearweek_to_date(c("2024-W01", "2024-W02"))
  expect_length(result, 2)
  expect_s3_class(result, "Date")
  expect_equal(result[2] - result[1], as.difftime(7, units = "days"))
})

test_that("yearweek_to_date returns Monday of ISO week", {
  # Check that all returned dates are Mondays (weekday 1 in ISO)
  dates <- ervissexplore:::yearweek_to_date(
    c("2024-W01", "2024-W10", "2024-W26", "2024-W52")
  )
  weekdays_num <- as.numeric(format(dates, "%u"))
  expect_true(all(weekdays_num == 1))
})

test_that("assert_date rejects non-Date objects", {
  expect_error(
    ervissexplore:::assert_date("2024-01-01", "test_arg"),
    "must be a Date object"
  )
  expect_error(
    ervissexplore:::assert_date(20240101, "test_arg"),
    "must be a Date object"
  )
  expect_error(
    ervissexplore:::assert_date(NULL, "test_arg"),
    "must be a Date object"
  )
})

test_that("assert_date accepts Date objects", {
  expect_no_error(
    ervissexplore:::assert_date(as.Date("2024-01-01"), "test_arg")
  )
  expect_no_error(
    ervissexplore:::assert_date(Sys.Date(), "test_arg")
  )
})

test_that("assert_date error message includes argument name", {
  expect_error(
    ervissexplore:::assert_date("not_a_date", "my_param"),
    "'my_param'"
  )
})

test_that("assert_file_or_url accepts valid URLs", {
  expect_no_error(
    ervissexplore:::assert_file_or_url("https://example.com/data.csv")
  )
  expect_no_error(
    ervissexplore:::assert_file_or_url("http://example.com/data.csv")
  )
})

test_that("assert_file_or_url accepts existing files", {
  tmp <- tempfile(fileext = ".csv")
  writeLines("a,b\n1,2", tmp)
  on.exit(unlink(tmp))

  expect_no_error(
    ervissexplore:::assert_file_or_url(tmp)
  )
})

test_that("assert_file_or_url rejects invalid paths", {
  expect_error(
    ervissexplore:::assert_file_or_url("/nonexistent/path/file.csv"),
    "must be an existing file or a valid URL"
  )
  expect_error(
    ervissexplore:::assert_file_or_url("not_a_url_or_file"),
    "must be an existing file or a valid URL"
  )
})

test_that("assert_indicator accepts valid indicators", {
  expect_no_error(
    ervissexplore:::assert_indicator(
      "positivity",
      c("positivity", "detections", "tests")
    )
  )
  expect_no_error(
    ervissexplore:::assert_indicator(
      c("positivity", "detections"),
      c("positivity", "detections", "tests")
    )
  )
})

test_that("assert_indicator rejects invalid indicators", {
  expect_error(
    ervissexplore:::assert_indicator(
      "invalid",
      c("positivity", "detections", "tests")
    ),
    "Invalid value"
  )
  expect_error(
    ervissexplore:::assert_indicator(
      c("positivity", "wrong"),
      c("positivity", "detections", "tests")
    ),
    "wrong"
  )
})

test_that("assert_indicator error message lists valid values", {
  expect_error(
    ervissexplore:::assert_indicator("bad", c("a", "b", "c")),
    "must be one or more of"
  )
})

test_that("safe_download_csv reads a valid CSV file", {
  tmp <- tempfile(fileext = ".csv")
  writeLines("a,b\n1,2\n3,4", tmp)
  on.exit(unlink(tmp))

  result <- ervissexplore:::safe_download_csv(tmp)
  expect_s3_class(result, "data.table")
  expect_equal(nrow(result), 2)
  expect_equal(names(result), c("a", "b"))
})

test_that("safe_download_csv errors on invalid path", {
  expect_error(
    ervissexplore:::safe_download_csv("/nonexistent/path/file.csv"),
    "Failed to download or read CSV"
  )
})

test_that("safe_download_csv error message includes the path", {
  bad_path <- "/some/fake/path.csv"
  expect_error(
    ervissexplore:::safe_download_csv(bad_path),
    bad_path,
    fixed = TRUE
  )
})

test_that("warn_if_empty returns the data.table unchanged", {
  dt <- data.table::data.table(x = 1:3, y = letters[1:3])
  result <- ervissexplore:::warn_if_empty(dt)
  expect_identical(result, dt)
})

test_that("warn_if_empty emits message for empty data.table", {
  dt <- data.table::data.table(x = integer(0), y = character(0))
  expect_message(
    ervissexplore:::warn_if_empty(dt),
    "No data found"
  )
})

test_that("warn_if_empty does not emit message for non-empty data.table", {
  dt <- data.table::data.table(x = 1:3)
  expect_no_message(
    ervissexplore:::warn_if_empty(dt)
  )
})
