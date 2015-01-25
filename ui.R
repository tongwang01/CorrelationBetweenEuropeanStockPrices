library(shiny)

# Define UI for European Stock Prices application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Correlation Between European Stock Prices"),
  
  # Sidebar with controls to select one stock index as response variable
  sidebarPanel(
    selectInput("target", "Target Stock Index:",
                list("DAX" = "DAX", 
                     "SMI" = "SMI", 
                     "CAC" = "CAC",
                     "FTSE" = "FTSE")), 
  # Slider to select the range of days to analyze
    sliderInput("range", "Date Range:",
                min = 1, max = 1860, value = c(1,1860)),
    h4("Documentation"),
   p("Stock prices around the world often rise and fall together. In this project we investigate 
     the daily closing prices of four major European stock indices: Germany DAX (Ibis), Switzerland SMI, 
     France CAC, and UK FTSE from 1991 to 1998. The data is contained in the EuStockMarkets dataset in R."),
   p("
     You can select a target stock index and a date range, the application would then fit a linear regression
     model predicting this index using the values of the other three indices on the selected dates. Model R squared 
     is reported. We also show a plot demonstrating the fitted values and actual values."),
  p("
     We can see that all four stock indices highly correlate with the other European stock markets.")
  
  ),
  mainPanel(
    h4('We are predicting the value of:'),
    textOutput("response"),
    h4('using the values of the following other European stock indices with linear regression:'),
    textOutput("predictors"),
    h4('We take data from the following dates between 1991 to 1998:'),
    textOutput("daterange"),
    h4('Model R Squared is:'),
    textOutput("r_2"),
    h4('See below the plot of actual and fitted values'),
    plotOutput("plot")
  )
))