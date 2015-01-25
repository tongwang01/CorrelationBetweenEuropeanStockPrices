library(shiny)
library(datasets)
library(ggplot2)
library(reshape2)


df <- EuStockMarkets

shinyServer(
  function(input, output) {
  dfInput <- reactive({
    if (input$target == "DAX") {df[input$range[1]: input$range[2],]}
    else if (input$target == "SMI") {df[input$range[1]: input$range[2],c(2, 1, 3, 4)]}
    else if (input$target == "CAC") {df[input$range[1]: input$range[2],c(3, 1, 2, 4)]}
    else {df[input$range[1]:input$range[2],c(4, 1, 2, 3)]}  
  })
  
  output$response <- renderText({input$target})
  output$predictors <- renderText({
    if (input$target == "DAX") {l <- "SMI, CAC and FTSE"}
    else if (input$target == "SMI") {l <- "DAX, CAC and FTSE"}
    else if (input$target == "CAC") {l <- "DAX, SMI and FTSE"}
    else {l <- "DAX, SMI and CAC"}  
  })
  output$daterange <- renderText({
    paste("day ", input$range[1], " to day ", input$range[2])
  })
  
  output$r_2 <- renderText({
    dataset <- dfInput()
    dataset <- data.frame(dataset)
    colnames(dataset) <- c("a", "b", "c", "d")
    fit <- lm(a ~ b + c + d, data = dataset)
    round(summary(fit)$r.squared,2)
  })
  
  output$plot <- renderPlot({
    dataset <- dfInput()
    dataset <- data.frame(dataset)
    colnames(dataset) <- c("a", "b", "c", "d")
    fit <- lm(a ~ b + c + d, data = dataset)
    fitted <- fit$fitted.value
    actual <- dataset$a
    dfp <- cbind(fitted, actual)
    dfp <- data.frame(dfp)
    dfp <- melt(dfp)
    dfp$date <- 1:nrow(dataset)
    p <- ggplot(data=dfp, aes(x = date, y = value, group = variable, colour = variable)) +
      geom_line()
    print(p)
  })
  output$text <- renderText({
    dataset <- dfInput()
    dataset <- data.frame(dataset)
    fit <- lm(dataset[,1] ~ ., data = dataset)
    fit$coefficients
  })
  output$table <- renderTable({
    dataset <- dfInput()
    head(dataset, 10)
  })
  })   