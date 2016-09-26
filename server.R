library(dplyr)
library(ggplot2)

monthly_data <- read.csv("wv_monthly_data.csv",header = TRUE)
monthly_data$DATE <- as.Date(monthly_data$DATE)

shinyServer(
  function(input,output) {

    cat(file=stderr(), "reacting")

    thisStation <- reactive({
      sdate <- as.Date(as.character(input$sdate))
      edate <- as.Date(as.character(input$edate))
      station <- input$station
      if (is.null(station)) {
        station <- "MORGANTOWN HART FIELD WV US"
      }
      cat(file=stderr(), "sdate:", sdate, "(",class(sdate), ") edate:",edate, " station: ",station)
      d <- monthly_data %>% filter(STATION_NAME==station,DATE<=edate,DATE>=sdate) %>% arrange(DATE)
      if (nrow(d)==0) {
        d <- monthly_data %>% filter(STATION_NAME==station) %>% arrange(DATE)
      }
      d <- d[!is.na(d$EMXT) | !is.na(d$EMNT) | !is.na(d$MMXT) | !is.na(d$MMNT) | !is.na(d$MNTM),]
      if (nrow(d)==0) {
        d <- data.frame(DATE=c(sdate,edate),MNTM=c(0.0,0.0),EMNT=c(0.0,0.0),EMXT=c(0.0,0.0),MMXT=c(0.0,0.0),MMNT=c(0.0,0.0))
      }
      cat(file=stderr(),"returning")
      return(d)
    })
    
    output$stationPlot <- renderPlot({
      ggplot(thisStation(),aes(x=DATE)) +
           geom_line(aes(x=DATE,y=MNTM),size=2) +
           geom_ribbon(aes(x=DATE,ymax=EMXT,ymin=EMNT),alpha=0.2,fill="red") +
           geom_ribbon(aes(x=DATE,ymax=MMXT,ymin=MMNT),alpha = 0.6,fill= "blue") + 
           ylab(expression(""*~degree*F))
    })
  }
)