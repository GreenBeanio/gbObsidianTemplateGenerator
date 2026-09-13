source(file.path(here::here(), "Functions.R"))
source(file.path(here::here(), "Utils.R"))

input_dir <- here::here()
output_dir <- file.path(input_dir, "Output")
template_dir <- file.path(input_dir, "Templates")

unlink(file.path(output_dir, "*"), recursive = T, force = T)

test_date <- Sys.Date()

createYear(input_date = test_date,
           template_dir = template_dir,
           output_dir = output_dir)
# 
# createQuarter(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
# 
# createMonth(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
# 
# createWeek(input_date = test_date,
#            template_dir = template_dir,
#            output_dir = output_dir)
#
# createDay(input_date = test_date,
#            template_dir = template_dir,
#           output_dir = output_dir)