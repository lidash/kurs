
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
library(ggplot2movies)
shinyServer(function(input, output, session) {

  output$rezultC <- renderText({
    d <- input$textd
    d <- as.numeric(d)
    del <- input$textdel
    del <- as.numeric(del)
    E <- input$textE
    E <- as.numeric(E)
    c <- input$textc
    c <- as.numeric(c)
    Temp <- input$textT
    Temp <- as.numeric(Temp)
    ro <- input$textro
    ro <- as.numeric(ro)
    B <- (c ^ 2) * ro
    Ct <- c / sqrt( 1 + (d * B) / (del * E) )
    rezultC <- Ct
  })
  
  output$rezultf <- renderText({
    d <- input$textd
    d <- as.numeric(d)
    c <- input$textc
    c <- as.numeric(c)
    r <- (d / 2)
    f <- (0.61 * c / r)
    updateSliderInput(session, "rezultf_sl", value = f)
    
    output$rezultBet <- renderText({
      eta <- input$texteta
      eta <- as.numeric(eta)
      ksi <- input$textksi
      ksi <- as.numeric(ksi)
      b <- (4 / 3 * eta + ksi)
      w <- 2 * pi * f
      Bet <- ( (b * w^2) / (2 * c^3 * ro) ) + ( (1 / a) * ( (eta * w) / (2 * c^2 * ro)  )^(1/2) )
      output$rezultCw <- renderText({
        Cw <- c ( 1 - (eta / 2 * ro * w * a^2)^(1/2) )
      })
      rezultBet <- Bet
    })

    rezultf <- f
  })
  
  
  
  output$trendPlot <- renderPlotly({
    # initiate a 100 x 3 matrix filled with zeros
    m <- matrix(numeric(300), ncol = 3)
    # simulate a 3D random-walk
    for (i in 2:100) m[i, ] <- m[i-1, ] + rnorm(3)
    # collect everything in a data-frame
    df <- setNames(
      data.frame(m, seq(1, 100)),
      c("x", "y", "z", "time")
    )
    
    library(plotly)
    plot_ly(df, x = x, y = y, z = z, color = time, type = "scatter3d")
  })

})
