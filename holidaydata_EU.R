#installing github
install.packages("devtools")
devtools::install_github("matbmeijer/HolidayAPI")
install.packages("HolidayAPI")


library(data.table)
library(dplyr)
library(tidyr)
library(knitr)
library(tidyverse)
library(HolidayAPI)
library(data.table)
api_password = Sys.getenv("holidayapi")

#get country
countries_df<-get_countries()
summary(countries_df)
class(countries_df)

countries_df<-countries_df %>% as.data.frame()
class(countries_df)

#make a lists
countries <- (c('AT', 'BE', 'BE', 'CZ', 'DE', 'DK', 'ES', 'NL', 'FR', 'GB', 'IE', 'NO', 'GR', 'LV', 'PT', 'SE'))
counter<-1

#adding city name
cities <- (c('vienna', 'antwerp', 'brussels', 'prague', 'berlin', 'copenhagen', 'madrid', 'amsterdam', 'paris', 'london', 'dublin', 'oslo', 'athens', 'riga', 'lisbon', 'stockholm'))
class(cities)

df_lc <- data.frame(countries, cities)
class(df_lc)
names(df_lc)[1] <- "country"
names(df_lc)[2] <- "city"


#combining holiday data in once.
all_holidays = for (country in countries){
  lapply(countries[counter], get_holidays, year=2021)
  counter<-counter+1}
  
all_holidays = lapply(countries, get_holidays, year=2021)

df_all_holidays = rbindlist(lapply(all_holidays, function(x) data.table(x$holidays)))

class(df_all_holidays)

#joinen van final_all_holidays with df_lc

final_all_holidays <- left_join(df_all_holidays, df_lc, by = NULL)

#cleaning
Cleaning <- function(final_all_holidays) {
  final_all_holidays <- final_all_holidays %>%
    group_by(date) %>%
    select(name, date ) %>%
    mutate(date = as.Date(date))
}

#keeping only necessary colomns
final_EU_holidays <- final_all_holidays %>%
  select(name, date, country, city)

#Write to csv
write.csv(final_EU_holidays, "Holiday_data_clean.csv")
