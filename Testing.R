source(file.path(here::here(), "Functions.R"))
source(file.path(here::here(), "Utils.R"))

input_dir <- here::here()
output_dir <- file.path(input_dir, "Output")
template_dir <- file.path(input_dir, "Templates")


# if(!dir.exists(output_dir)) {
#   dir.create(output_dir)
#   dir.create(file.path(output_dir, "Year"))
#   dir.create(file.path(output_dir, "Quarter"))
#   dir.create(file.path(output_dir, "Quarter"))
#   dir.create(file.path(output_dir, "Month"))
#   dir.create(file.path(output_dir, "Week"))
#   dir.create(file.path(output_dir, "Day"))
# }
# 
# dates_df <-
#   tibble::tibble(Date = seq.Date(as.Date("2026-07-26"), Sys.Date(),
#                                  by = "day")) |>
#   dplyr::mutate(Quarter = lubridate::quarter(Date),
#                 Month = lubridate::month(Date),
#                 Week = lubridate::week(Date),
#                 Day = lubridate::wday(Date, label = TRUE, abbr = FALSE, week_start = 1))
# 
# test_date <- dates_df |> dplyr::pull(Date) |> dplyr::first()

unlink(file.path(output_dir, "*"), recursive = T, force = T)

test_date <- as.Date("2026-01-01")

# createYear(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
# 
# createQuarter(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
# 
createMonth(input_date = test_date,
           template_dir = template_dir,
           output_dir = output_dir)
# 
# createWeek(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
#
# createDay(input_date = test_date,
#            template_dir = template_dir,
#           output_dir = output_dir)