
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("test"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        column(6,
               textInput("textd", label = h5("Введіть d"), value = ""),
               textInput("textdel", label = h5("Введіть δ"), value = ""),
               textInput("textE", label = h5("Введіть E"), value = "")
               ),
        
        column(6,
               textInput("textc", label = h5("Введіть c"), value = ""),
               textInput("textT", label = h5("Введіть T"), value = ""),
               textInput("textro", label = h5("Введіть ρ"), value = "")
               ),
        
        column(6,
               textInput("texteta", label = h5("Введіть η"), value = "")
        ),
        
        column(6,
               textInput("textksi", label = h5("Введіть ξ"), value = "")
        ),
        
        column(12,
               verbatimTextOutput("rezultC"),
               verbatimTextOutput("rezultf"),
               verbatimTextOutput("rezultBet"),
               verbatimTextOutput("rezultCw")
               ),
        
        column(12,
               sliderInput("rezultf_sl", "Критичне значення частоти",
                           min = 20, max = 200, value = 20)
               )
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(column(12,
                      plotlyOutput("trendPlot")
      ))
    )
  )
))
