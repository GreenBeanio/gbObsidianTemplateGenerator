source(file.path(here::here(), "Functions.R"))
source(file.path(here::here(), "Utils.R"))

input_dir <- here::here()
output_dir <- file.path(input_dir, "Output")
template_dir <- file.path(input_dir, "Templates")


if(!dir.exists(output_dir)) {
  dir.create(output_dir)
  dir.create(file.path(output_dir, "Year"))
  dir.create(file.path(output_dir, "Quarter"))
  dir.create(file.path(output_dir, "Quarter"))
  dir.create(file.path(output_dir, "Month"))
  dir.create(file.path(output_dir, "Week"))
  dir.create(file.path(output_dir, "Day"))
}

dates_df <- 
  tibble::tibble(Date = seq.Date(as.Date("2026-07-26"), Sys.Date(), 
                                 by = "day")) |>
  dplyr::mutate(Quarter = lubridate::quarter(Date),
                Month = lubridate::month(Date),
                Week = lubridate::week(Date),
                Day = lubridate::wday(Date, label = TRUE, abbr = FALSE, week_start = 1))

test_date <- dates_df |> dplyr::pull(Date) |> dplyr::first()

createYear(test_date, 
           file.path(template_dir, "Year.md"))

createQuarter(test_date,
              file.path(template_dir, "Quarter.md"))

createMonth(test_date,
            file.path(template_dir, "Month.md"))

createWeek(test_date,
           file.path(template_dir, "Week.md"))

createDay(test_date,
          file.path(template_dir, "Day.md"))