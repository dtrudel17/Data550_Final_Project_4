
library(knitr)
library(rmarkdown)
here::i_am("Code/Render_Final_Report.R")

render(
  here::here("Final_Project.Rmd"),
  knit_root_dir = here::here()
)