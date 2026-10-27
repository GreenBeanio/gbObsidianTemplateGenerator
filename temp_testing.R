devtools::load_all()

templat_dir <- here::here("inst", "extdata", "Templates")
output_dir <- here::here("testing")

test_time <- readRDS(testthat::test_path("testdata", "0_test_time.rds"))

# test_result <- readr::read_file(
#   createDay(input_date = test_time,
#             output_dir = output_dir,
#             template_dir = templat_dir,
#             unique_timestamp = test_time,
#             author = "Test User")[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_day.rds"))

# test_result <- readr::read_file(
#   createWeek(input_date = test_time,
#              output_dir = output_dir,
#              template_dir = templat_dir,
#              unique_timestamp = test_time,
#              author = "Test User")[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_week.rds"))

# test_result <- readr::read_file(
#   createMonth(input_date = test_time,
#               output_dir = output_dir,
#               template_dir = templat_dir,
#               unique_timestamp = test_time,
#               author = "Test User")[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_month.rds"))

# test_result <- readr::read_file(
#   createQuarter(input_date = test_time,
#                 output_dir = output_dir,
#                 template_dir = templat_dir,
#                 unique_timestamp = test_time,
#                 author = "Test User")[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_quarter.rds"))

# test_result <- readr::read_file(
#   createYear(input_date = test_time,
#              output_dir = output_dir,
#              template_dir = templat_dir,
#              unique_timestamp = test_time,
#              author = "Test User")[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_year.rds"))

# test_result <- readr::read_file(ObsidianDay$new(
#   input_date = lubridate::date(test_time),
#   output_dir = output_dir,
#   template_dir = templat_dir,
#   unique_timestamp = test_time,
#   author = "Test User")$process()[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_day.rds"))

# test_result <- readr::read_file(ObsidianWeek$new(
#   input_date = lubridate::date(test_time),
#   output_dir = output_dir,
#   template_dir = templat_dir,
#   unique_timestamp = test_time,
#   author = "Test User")$process()[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_week.rds"))

# test_result <- readr::read_file(ObsidianMonth$new(
#   input_date = lubridate::date(test_time),
#   output_dir = output_dir,
#   template_dir = templat_dir,
#   unique_timestamp = test_time,
#   author = "Test User")$process()[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_month.rds"))

# test_result <- readr::read_file(ObsidianQuarter$new(
#   input_date = lubridate::date(test_time),
#   output_dir = output_dir,
#   template_dir = templat_dir,
#   unique_timestamp = test_time,
#   author = "Test User")$process()[[1]])
# loaded_file <- readRDS(testthat::test_path("testdata", "create_quarter.rds"))

test_result <- readr::read_file(ObsidianYear$new(
  input_date = lubridate::date(test_time),
  output_dir = output_dir,
  template_dir = templat_dir,
  unique_timestamp = test_time,
  author = "Test User")$process()[[1]])
loaded_file <- readRDS(testthat::test_path("testdata", "create_year.rds"))

testthat::expect_equal(test_result, loaded_file)
