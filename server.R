
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(lubridate)
library(quantmod)

shinyServer(function(input, output) {

  # Open the file and add a date column
    getSymbols("IWM", src = "google")
    
    IWM <- data.frame(IWM)
  
    IWM$date <- row.names(IWM)
    IWM$date <- as.POSIXct(IWM$date,format = "%Y-%m-%d")
  
  # Plot the closing price and running average
  output$distPlot <- renderPlot({
    
    ## Plot the basic data set
    plot(IWM$date,IWM$IWM.Close, 
      type = "l",
      xlab = "date",
      ylab = "price at close ($)",
      col = "grey")
    
    ## Calculate and plot the running average
    ma <- function(x,n=20){filter(x,rep(1/n,n), sides=1)}
    n <- input$n
    lines(IWM$date,ma(IWM$IWM.Close, n), col = "red")
    
  })

})
