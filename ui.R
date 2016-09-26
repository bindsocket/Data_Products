library(ggplot2)
library(shiny)
monthly_station_names <- read.csv("monthly_station_names.csv",header = TRUE)
select_choices = setNames(as.character(monthly_station_names$STATION_NAME),as.character(monthly_station_names$STATION_NAME))

shinyUI(
fluidPage(
  titlePanel("WV Monthly Climate By Station"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filters"),
             dateInput("sdate","Start Date:",value="2014-09-01",format="mm/yyyy",startview = "year"),
             dateInput("edate","End Date:",value="2015-09-01",format="mm/yyyy",startview="year"),
             selectInput("station","Station:",select_choices,selected = NULL),
             span("Use the date selector to indicate the beginning and ending month and year for displaying. Use the dropdown menu to select different stations.")
           )
    ),
    column(8,
           plotOutput("stationPlot"),
           wellPanel(
             span("The center line indicates the average temperature during the time period. The blue area indicates the extent of the average maximum temperature and average minimum temperature per month. The red area indicates extreme limits observed per month.")
           )
    )
  )
)
)