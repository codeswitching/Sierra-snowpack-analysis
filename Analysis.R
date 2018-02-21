library(tidyverse)
library(lubridate)
library(plotly)

station <- 219
url <- paste0("http://cdec.water.ca.gov/cgi-progs/snowQuery?course_num=", station, "&month=%28All%29&start_date=&end_date=&csv_mode=Y&data_wish=Raw+Data")
download.file(url, "surveydata.csv")
snowdata <- read_table2("surveydata.csv", col_types = cols(Meas.Date = col_skip()))

snowdata %>%
  rename(station = Course, year = Year, month = Month, name = Name) %>%
  group_by(year) %>%
  summarize(totalSWE = max(SWE, na.rm=T)) %>%
  mutate(recent = year > 2003) %>%
  arrange(totalSWE) ->
  snowsummary
snowsummary$year_cat <- factor(snowsummary$year, snowsummary$year)
plot_ly(snowsummary, x=~year_cat, y=~totalSWE, type="bar", color=~recent, colors=c("lightgray", "blue")) %>%
  layout(xaxis = list(title=""),
         yaxis = list(title="Max Snow Water Content"),
         showlegend=F)
