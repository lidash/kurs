
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
library(ggplot2movies)
shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  # Application title
  titlePanel("Дослідження"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        
        column(12,
               radioButtons("radio", label = h4("Вид досліджуваного середовища"),
                            choices = list("Сира нафта" = "nafta", "Дизельне паливо" = "palevo", "Природній газ" = "gas"), 
                            selected = "nafta")
        ),        
        
        column(6,
               selectInput("textT", label = h5("Введіть T, К"), 
                           choices = list("273" = 273, "283" = 283, "293" = 293, "303" = 303, "313" = 313), 
                           selected = 273)
        ),
        
        column(6,
               textInput("textP", label = h5("Введіть P, Па"), value = "")  
        )
      ),
        fluidRow(
        column(4,
               #textInput("textc", label = h5("Введіть c"), value = ""),
               #textInput("textro", label = h5("Введіть ρ"), value = ""),
               textInput("textd", label = h5("Введіть d, м"), value = 1.020)
        ),
        
        column(4,
               selectInput("textdel", label = h5("Введіть δ, м"), 
                           choices = list("0.002" = 0.002, "0.00325" = 0.00325), 
                           selected = 0.002)
             
        ),
        
        column(4,
               textInput("textE", label = h5("Введіть E"), value = 2.08*10^11)
        ),
        
        #column(6,
               #textInput("texteta", label = h5("Введіть η"), value = "")
        #),
        
        #column(6,
               #textInput("textksi", label = h5("Введіть ξ"), value = "")
        #),
    
        column(12,
               h5("Результат обрахунку Cm(T)"),
               verbatimTextOutput("rezultC"),
               h5("Результат обрахунку fкр"),
               verbatimTextOutput("rezultf"),
               h5("Результат обрахунку β, дБ"),
               verbatimTextOutput("rezultBet"),
               h5("Результат обрахунку С(ω)"),
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
      )),
      fluidRow(column(12,
                      plotOutput("TempPlot")
      )),
      fluidRow(column(12,
                      plotOutput("TempPlot1")
      ))
    )
  )
))
