#installing github
install.packages("devtools")
devtools::install_github("matbmeijer/HolidayAPI")

library(data.table)
library(dplyr)
library(tidyr)
library(knitr)
library(tidyverse)
install.packages("HolidayAPI")
library(HolidayAPI)
library(data.table)
api_password = Sys.getenv("holidayapi")

#get country
countries_df<-get_countries()
summary(countries_df)
class(countries_df)

countries_df<-countries_df %>% as.data.frame()
class(countries_df)

knitr::kable(head(countries_df, 5), row.names = FALSE, caption = "Example of available countries & subdivisions", format = "markdown")

#make a lists
countries <- list(c('AT', 'BE', 'BE', 'CZ', 'DE', 'DK', 'ES', 'NL', 'FR', 'GB', 'IE', 'NO', 'GR', 'LV', 'PT', 'SE'))

#adding city name
cities <- list(c('vienna', 'antwerp', 'brussels', 'prague', 'berlin', 'copenhagen', 'madrid', 'amsterdam', 'paris', 'london', 'dublin', 'oslo', 'athens', 'riga', 'lisbon', 'stockholm'))
class(cities)

df_lc <- data.frame(countries, cities)
class(df_lc)
names(df_lc)[1] <- "country"
names(df_lc)[2] <- "city"

knitr::kable(head(df_lc, 8), row.names = FALSE, caption = "overview cities and countries", format = "markdown")

#combining holiday data in once.
all_holidays = lapply(countries, get_holidays, year=2021)

df_all_holidays = rbindlist(lapply(all_holidays, function(x) data.table(x$holidays)))

class(df_all_holidays)

knitr::kable(head(df_all_holidays, 266), row.names = FALSE, caption = "overview EU holidays", format = "markdown")

#joinen van final_all_holidays with df_lc

final_all_holidays <- left_join(df_all_holidays, df_lc, by = NULL)

knitr::kable(head(final_all_holidays, 300), row.names = FALSE, caption = "overview EU holidays", format = "markdown")


#cleaning
Cleaning <- function(final_all_holidays) {
  final_all_holidays <- final_all_holidays %>%
    group_by(date) %>%
    select(name, date ) %>%
    mutate(date = as.Date(date))
}

#keeping only necessary colomns
final_EU_holidays <- final_all_holidays %>%
  select(name, date, country)

#Write to csv
write.csv(final_EU_holidays, "Holiday_data_clean.csv")
