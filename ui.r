library(shiny)
library(ggplot2)
library(dplyr) # select
library(DT)

# file <- "https://github.com/rstudio-education/shiny-course/raw/main/movies.RData"
# destfile <- "movies.RData"
# 
# download.file(file, destfile)
# load("movies.RData")
# all_studios <- sort(unique(movies$studio))
# min_date <- min(movies$thtr_rel_date)
# max_date <- max(movies$thtr_rel_date)

fluidPage(
  titlePanel("Hello Shiny!"),

  textInput(
    inputId = "custom_text",
    label = "Input some text here:",
    value = "Enter text..."
  ),
  textOutput(outputId = "custom_text"),

  fluidRow(
    column(3,
           h3("Buttons"),
           actionButton("action", "Action"),
           br(),
           br()),
           # submitButton("Submit")),

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
                     value = "2014-01-01")),
    column(3,
           dateRangeInput("dates", h3("Date range"))
           # dateRangeInput(
           #   inputId = "date",
           #   label = "Select dates:",
           #   start = "2013-01-01", end = "2014-01-01",
           #   min = min_date, max = max_date,
           #   startview = "year"
           # ),
           ),

    column(3,
           fileInput("file", h3("File input"))),
    column(3,
           radioButtons("radio", h3("Radio buttons"),
                        choices = list("Choice 1" = 1, "Choice 2" = 2,
                                       "Choice 3" = 3),selected = 1)),
    column(3,
           numericInput(
             inputId = "n",
             value = 3,
             step = 10,
             label = "Numérique"
           )),
    column(3,
           selectInput("var",
                       label = "Choose a variable to display",
                       choices = c("Percent White",
                                   "Percent Black",
                                   "Percent Hispanic",
                                   "Percent Asian"),
                       selected = "Percent White"))
    
  ),

  sidebarLayout(
    # position = "right",
    sidebarPanel(
      # selectInput(
      #   inputId = "studio",
      #   label = "Select studio:",
      #   choices = all_studios,
      #   selected = "20th Century Fox",
      #   multiple = TRUE
      # ),
      # selectInput(
      #   inputId = "y",
      #   label = "Y-axis:",
      #   choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
      #   selected = "audience_score"
      # ),
      # selectInput(
      #   inputId = "x",
      #   label = "X-axis:",
      #   choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
      #   selected = "critics_score"
      # ),
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
      HTML(paste("Enter a value between 1 and", "651"))
    ),
    mainPanel(
      h1("First level title", align = "center"), # p h-6 a br div span pre code strong em
      # img(src = "my_image.png", height = 72, width = 72) dans www dossier
      plotOutput(outputId = "distPlot"),
      textOutput("selected_var"), # dataTableOutput imageOutput plotOutput tableOutput textOutput uiOutput verbatim
      textOutput("min_max")
      # plotOutput(outputId = "scatterplot"),
      # dataTableOutput(outputId = "moviestable"),
      # dataTableOutput(outputId = "moviestable2"),
      # plotOutput(outputId = "scatterplot2")
    )
  )
)