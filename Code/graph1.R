library(tidyverse)
library(gtsummary)
library(dplyr)

here::i_am("code/graph1.R")


data_1 <- read.csv(
  file = here::here("Raw_Data/TeenVaccineData.csv")
)
labelled::var_label(data_1) <- list(
  Vaccine.Sample = "Vaccine Type",
  Dose = "Dose",
  Survey.Year = "Year",
  Estimate.... = "Coverage Estimate",
  Sample.Size = "Sample Size"
)

data_1 <- filter(data_1, Survey.Year == "2014" |Survey.Year == "2015" |Survey.Year == "2016" |Survey.Year == "2017" |Survey.Year == "2018" |Survey.Year == "2019" | Survey.Year == "2020" | Survey.Year == "2021" | Survey.Year == "2022" | Survey.Year == "2023")

summary_vaccine_coverage <- data_1 %>%
  group_by(Vaccine.Sample, Survey.Year) %>%
  summarise(
    average_estimate = mean(Estimate...., na.rm = TRUE),
    .groups = "drop"
  )

# Use tbl_summary() for summarization, grouping by Vaccine.Sample and Survey.Year
summary_vaccine_coverage_table <- summary_vaccine_coverage %>%
  tbl_summary(
    by = Vaccine.Sample,  # Group by Vaccine.Sample first
    statistic = list(all_continuous() ~ "{mean}") 
  ) 


line_graph <- ggplot(summary_vaccine_coverage, aes(x = factor(Survey.Year), y = average_estimate, color = Vaccine.Sample, group = Vaccine.Sample)) +
  geom_line() +
  geom_point() +  # Optional: Adds points at each year
  labs(x = "Year", y = "Estimate", title = "Coverage Estimates Over Time by Vaccine Type") +
  theme_minimal()

ggsave(
  here::here("output/graph1.png"),
  plot = line_graph,
  device = "png"
)
