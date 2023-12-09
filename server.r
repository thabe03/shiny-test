library(shiny)
library(ggplot2)
library(dplyr) # select
library(DT)

function(input, output) {
  output$custom_text <- renderText({
    paste0("Hello ", input$custom_text, "!")
  })
  
  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "#007bc2", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
  })
  output$selected_var <- renderText({ # renderDataTabIe renderlmage renderPlot renderPrint renderTable renderText renderUI
    paste("You have selected", input$var)
  })
  output$selected_var <- reactive({ # renderDataTabIe renderlmage renderPlot renderPrint renderTable renderText renderUI
    paste("You have selected", input$var)
  })
  output$min_max <- renderText({
    paste("You have chosen a range that goes from",
          input$range[1], "to", input$range[2])
  })
  # output$scatterplot <- renderPlot({
  #   ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
  #     geom_point()
  # })
  # output$moviestable <- renderDataTable({
  #   req(input$n) # required
  #   movies_sample <- movies %>%
  #     sample_n(input$n) %>%
  #     select(title:studio)
  #   datatable(
  #     data = movies_sample,
  #     options = list(pageLength = 10),
  #     rownames = FALSE
  #   )
  # })
  # output$moviestable2 <- renderDataTable({
  #   req(input$studio)
  #   movies_from_selected_studios <- movies %>%
  #     filter(studio %in% input$studio) %>%
  #     select(title:studio)
  #   DT::datatable(
  #     data = movies_from_selected_studios,
  #     options = list(pageLength = 10),
  #     rownames = FALSE
  #   )
  # })
  # output$scatterplot2 <- renderPlot({
  #   req(input$date)
  #   movies_selected_date <- movies %>%
  #     filter(thtr_rel_date >= as.POSIXct(input$date[1]) & thtr_rel_date <= as.POSIXct(input$date[2]))
  #   ggplot(data = movies_selected_date, aes(x = critics_score, y = audience_score, color = mpaa_rating)) +
  #     geom_point()
  # })
  
}