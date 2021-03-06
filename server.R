
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
    P <- input$textP
    P <- as.numeric(P)
    
    if (input$radio == "nafta") {
      # ro <- (825)
        ro <- (840)      
      #ksi <- (9.7*10^-6)
        ksi <- (5*10^-6) # kinemat vyazkist'
    }
    if (input$radio == "palevo") {
      ro <- (860)
      ksi <- (4.5*10^-6)
    }
    if (input$radio == "gas") {
      ro <- (400)
      ksi <- (14.3*10^-6)
    }
    if(input$radio == "nafta" && input$textT == 273){
      #c <- 1374
            c <- 1400
    }
    if(input$radio == "nafta" && input$textT == 283){
      c <- 1332
    }
    if(input$radio == "nafta" && input$textT == 293){
      c <- 1292
    }
    if(input$radio == "nafta" && input$textT == 303){
      c <- 1253
    }
    if(input$radio == "nafta" && input$textT == 313){
      c <- 1216
    }
    if(input$radio == "palevo"){
      updateSelectInput(session, "textT", choices = ("293" = 293))
      c <- 1392
    }
    if(input$radio == "gas"){
      updateSelectInput(session, "textT", choices = ("293" = 293))
      c <- 460
    }
    B <- (c ^ 2) * ro
    Ct <- c / sqrt( 1 + (d * B) / (del * E) )
    output$rezultf <- renderText({
      r <- (d / 2)
      f <- (0.61 * c / r)
      fmax <- floor(f)
      updateSliderInput(session, "rezultf_sl", max = fmax)
      
      output$rezultBet <- renderText({
        eta <- ksi * ro
        b <- (4 / 3 * eta + ksi)
        w <- 2 * pi * f
        a <- r
        Bet <- ( (b * w^2) / (2 * c^3 * ro) ) + ( (1 / a) * ( (eta * w) / (2 * c^2 * ro)  )^(1/2) )*8.68*1000
        output$rezultCw <- renderText({
          Cw <- c *( 1 - (eta / (2 * ro * w * a^2))^(1/2) )
          rezultCw <- Cw
        })
        rezultBet <- Bet
      })
      
      rezultf <- f
    })
    output$TempPlot1 <- renderPlot({
            x <- data.frame( nafta = c("nafta", "nafta", "nafta", "nafta", "nafta"), Temperatura = c(273, 283, 293, 303, 313), C = c(1374, 1332, 1292, 1253, 1216) )
            x$Ct_ <- 1/sqrt( 1 + (d * B) / (del * E) )
            
            ggplot(x, aes(Temperatura, y = value, color = variable))+ 
                    
                    geom_line(aes(y = Ct_, col = "Ct_"))+
                    
                    geom_point(aes(y = Ct_, col = "Ct_"))
            
    })
    output$TempPlot <- renderPlot({
      x <- data.frame( nafta = c("nafta", "nafta", "nafta", "nafta", "nafta"), Temperatura = c(273, 283, 293, 303, 313), C = c(1374, 1332, 1292, 1253, 1216) )
      x$Ct <- x$C/sqrt( 1 + (d * B) / (del * E) )

      ggplot(x, aes(Temperatura, y = value, color = variable))+ 
        geom_line(aes(y = C, col = "C")) + 
        geom_line(aes(y = Ct, col = "Ct"))+
        geom_point(aes(y = C, col = "C"))+
        geom_point(aes(y = Ct, col = "Ct"))
      
    })
    rezultC <- Ct
   
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
    
    plot_ly(df, x = x, y = y, z = z, color = time, type = "scatter3d")
  })
  

})
