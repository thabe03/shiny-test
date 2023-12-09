library(shiny)
library(ggplot2)
library(dplyr) # select
library(DT)

# Get the data

file <- "https://github.com/rstudio-education/shiny-course/raw/main/movies.RData"
destfile <- "movies.RData"

download.file(file, destfile)
load("movies.RData")
all_studios <- sort(unique(movies$studio))
min_date <- min(movies$thtr_rel_date)
max_date <- max(movies$thtr_rel_date)

ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  
  textInput(
    inputId = "custom_text",
    label = "Input some text here:"
  ),
  
  strong("Text is shown below:"),
  
  dateRangeInput(
    inputId = "date",
    label = "Select dates:",
    start = "2013-01-01", end = "2014-01-01",
    min = min_date, max = max_date,
    startview = "year"
  ),
  
  fluidRow(
    
    column(3,
           h3("Buttons"),
           actionButton("action", "Action"),
           br(),
           br(), 
           submitButton("Submit")),
    
    column(3,
           h3("Single checkbox"),
           checkboxInput("checkbox", "Choice A", value = TRUE)),
    
    column(3, 
           checkboxGroupInput("checkGroup", 
                              h3("Checkbox group"), 
                              choices = list("Choice 1" = 1, 
                                             "Choice 2" = 2, 
                                             "Choice 3" = 3),
                              selected = 1)),
    
    column(3, 
           dateInput("date", 
                     h3("Date input"), 
                     value = "2014-01-01"))   
  ),
  
  fluidRow(
    
    column(3,
           dateRangeInput("dates", h3("Date range"))),
    
    column(3,
           fileInput("file", h3("File input"))),
    
    column(3, 
           h3("Help text"),
           helpText("Note: help text isn't a true widget,", 
                    "but it provides an easy way to add text to",
                    "accompany other widgets.")),
    
    column(3, 
           numericInput("num", 
                        h3("Numeric input"), 
                        value = 1))   
  ),
  
  fluidRow(
    
    column(3,
           radioButtons("radio", h3("Radio buttons"),
                        choices = list("Choice 1" = 1, "Choice 2" = 2,
                                       "Choice 3" = 3),selected = 1)),
    
    column(3,
           selectInput("select", h3("Select box"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)),
    
    column(3, 
           sliderInput("slider1", h3("Sliders"),
                       min = 0, max = 100, value = 50),
           sliderInput("slider2", "",
                       min = 0, max = 100, value = c(25, 75))
    ),
    
    column(3, 
           textInput("text", h3("Text input"), 
                     value = "Enter text..."))   
  ),
  
  sidebarLayout(
    # position = "right",
    
    sidebarPanel(
      HTML(paste("Enter a value between 1 and", "651")),
      numericInput(
        inputId = "n",
        value = 3,
        step = 10,
        label = "Numérique"
      ),
      selectInput(
        inputId = "studio",
        label = "Select studio:",
        choices = all_studios,
        selected = "20th Century Fox",
        multiple = TRUE
      ),
      selectInput(
        inputId = "y",
        label = "Y-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "audience_score"
      ),
      selectInput(
        inputId = "x",
        label = "X-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "critics_score"
      ),
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100)),
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", 
                              "Percent Black",
                              "Percent Hispanic", 
                              "Percent Asian"),
                  selected = "Percent White")
    ),
    mainPanel(
      h1("First level title", align = "center"), # p h-6 a br div span pre code strong em
      # img(src = "my_image.png", height = 72, width = 72) dans www dossier
      plotOutput(outputId = "distPlot"),
      textOutput("selected_var"), # dataTableOutput imageOutput plotOutput tableOutput textOutput uiOutput verbatim
      textOutput("min_max"),
      plotOutput(outputId = "scatterplot"),
      textOutput(outputId = "custom_text"),
      dataTableOutput(outputId = "moviestable"),
      dataTableOutput(outputId = "moviestable2"),
      plotOutput(outputId = "scatterplot2")
    )
  )
)

server <- function(input, output) {
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
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
  output$min_max <- renderText({ 
    paste("You have chosen a range that goes from",
          input$range[1], "to", input$range[2])
  })
  output$user_text <- renderText({ custom_text })
  output$moviestable <- renderDataTable({
    req(input$n) # required
    movies_sample <- movies %>%
      sample_n(input$n) %>%
      select(title:studio)
    datatable(
      data = movies_sample,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })
  output$moviestable2 <- renderDataTable({
    req(input$studio)
    movies_from_selected_studios <- movies %>%
      filter(studio %in% input$studio) %>%
      select(title:studio)
    DT::datatable(
      data = movies_from_selected_studios,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })
  output$scatterplot2 <- renderPlot({
    req(input$date)
    movies_selected_date <- movies %>%
      filter(thtr_rel_date >= as.POSIXct(input$date[1]) & thtr_rel_date <= as.POSIXct(input$date[2]))
    ggplot(data = movies_selected_date, aes(x = critics_score, y = audience_score, color = mpaa_rating)) +
      geom_point()
  })
  
}
shinyApp(ui = ui, server = server)