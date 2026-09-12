source(file.path(here::here(), "Functions.R"))

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
  tibble::tibble(Date = seq.Date(as.Date("2026-07-26"), as.Date("2026-09-06"), 
                                 by = "day")) |>
  dplyr::mutate(Quarter = lubridate::quarter(Date),
                Month = lubridate::month(Date),
                Week = lubridate::week(Date),
                Day = lubridate::wday(Date, label = TRUE, abbr = FALSE, week_start = 1))

createYear(dates_df$Date, file.path(template_dir, "Year.md"))

createQuarter(dates_df |> dplyr::filter(Month %in% 7:9) |> dplyr::pull(Date),
              file.path(template_dir, "Quarter.md"))

createMonth(dates_df |> dplyr::filter(Month %in% 7:9) |> dplyr::pull(Date),
            file.path(template_dir, "Month.md"))

createWeek(dates_df |> dplyr::filter(Month == 8) |> dplyr::pull(Date),
           file.path(template_dir, "Week.md"))

createDay(dates_df |> dplyr::filter(Week == 35) |> dplyr::pull(Date),
          file.path(template_dir, "Day.md"))