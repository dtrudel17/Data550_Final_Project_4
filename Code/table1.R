library(flextable)
#reset
#rm(list=ls())

#load all packages
pacman::p_load(data.table, dplyr, tidyr, tidyverse, ggplot2, knitr, flextable)

#get data as a data.table
#note: column names with spaces will need to be typed within ``
here::i_am("code/table1.r")
og <- fread(here::here("Raw_Data/TeenVaccineData.csv"))

#rename one column
setnames(og, "Vaccine/Sample", "Vaccine Sample")

#subset to age-specific estimates
data <- og[`Dimension Type` == "Age"]

#only keep state-specific or national estimates
data <- data[(`Geography Type` == "States/Local Areas" | Geography == "United States") & !grepl('-', Geography)]

#HPV include male- and female-specific as well as male + female combined; only keep combined HPV estimates
data <- data %>%
  mutate(drop = ifelse(`Vaccine Sample` == "HPV" & !grepl('Males and Females', 'Dose'), 1, NA)) %>%
  filter(is.na(drop)) %>%
  filter(Dimension == "13-17 Years") %>% #only need agg ages
  select(-drop)

#calculate mean estimate by vaccine type for 2018 and 2019
sum_vac <- data[`Survey Year` %in% c("2018", "2019"), 
                .(mean = weighted.mean(x = `Estimate (%)`, w = `Sample Size`, na.rm = T)), 
                by = .(`Vaccine Sample`, `Dose`)]  %>% arrange(`Vaccine Sample`, `Dose`)

#check
#sum_vac

#calculate mean estimate by vaccine type and survey year
sum_vac.year <- data[`Survey Year` %in% c("2018", "2019"), 
                     .(mean = mean(`Estimate (%)`, na.rm = T)), 
                     by = .(`Vaccine Sample`, `Dose`, `Survey Year`)] %>% arrange(`Vaccine Sample`, `Dose`)

#check
#sum_vac.year


#make data set to present in a table
#not considering dose to make it easier to interpret; only doing national
tbl_data <- data[Geography == "United States", .(`Estimate (%)` = round(mean(`Estimate (%)`, na.rm = T), digits = 2)), 
                 by = .(`Vaccine Sample`, `Survey Year`)] %>% arrange(`Survey Year`, `Vaccine Sample`)
tbl_data <- dcast(tbl_data, `Survey Year` ~ `Vaccine Sample`, value.var = "Estimate (%)")

#make table
final_project_table <- tbl_data %>% 
  flextable() %>%
  theme_vanilla() %>%
  set_table_properties(align = "right", layout = "autofit") %>%
  set_caption("National Vaccination Coverage by Year")

saveRDS(
  final_project_table,
  file = here::here("output/table_1.rds")
)
