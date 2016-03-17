
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)
library(ggplot2movies)
shinyServer(function(input, output, session) {
       
         selectedData2<-reactive({
                table<-matrix(,nrow = 1,ncol=8)
                table[1,1]<-as.numeric(input$textd)
                table[1,2]<-as.numeric(input$textdel)
                table[1,3]<-as.numeric(input$textE)
                table[1,4]<-as.numeric(input$textP)
                
                if (input$radio == "nafta") {
                        # ro <- (825)
                        table[1,5] <- (840)      
                        #ksi <- (9.7*10^-6)
                        table[1,6]  <- (5*10^-6) # kinemat vyazkist'
                        if (input$textT == 273) {
                                table[1,7] <- 1400
                        }
                        if (input$textT == 283) {
                                table[1,7] <- 1332
                        }
                        if (input$textT == 293) {
                                table[1,7] <- 1292
                        }
                        if (input$textT == 303) {
                                table[1,7] <- 1253
                        }
                        if (input$textT == 313) {
                                table[1,7] <- 1216
                        }
                }
                if (input$radio == "palevo") {
                        table[1,5] <- (860)
                        table[1,6] <- (4.5*10^-6)
                        updateSelectInput(session, "textT", choices = ("293" = 293))
                        table[1,7] <- 1392
                }
                if (input$radio == "gas") {
                        table[1,5] <- (400)
                        table[1,6] <- (14.3*10^-6)
                        updateSelectInput(session, "textT", choices = ("293" = 293))
                        table[1,7]<-460
                }
                table[1,8]<-as.numeric(input$textT)
                colnames(table)<-c("d","del","E","P","ro","ksi","c","T")
                table
                
                
        })
        

  output$rezultC <- renderText({
        data<-as.data.frame(selectedData2())
        B <- (data$c ^ 2) * data$ro
        Ct <- data$c / sqrt( 1 + (data$d * B) / (data$del * data$E) )
        rezultC <- Ct
  })
  
    output$rezultf <- renderText({
      data<-as.data.frame(selectedData2())
      updateTextInput(session, "textc", value = data$c)
      updateTextInput(session, "textro", value = data$ro)
      updateTextInput(session, "textksi", value = data$ksi)
      r <- (data$d / 2)
      f <- (0.61 * data$c / r)
      #fmax <- f%/%1
      fmax <- floor(f)
      updateSliderInput(session, "rezultf_sl", max = fmax)
      rezultf <- f
    })
      
      output$rezultBet <- renderText({
        data<-as.data.frame(selectedData2())
        eta <- data$ksi * data$ro
        updateTextInput(session, "texteta", value = eta)
        b <- (4 / 3 * eta + data$ksi)
        w <- 2 * pi * input$rezultf_sl
        a <- (data$d / 2)
        #Bet <- ( (b * w^2) / (2 * c^3 * ro) ) + ( (1 / a) * ( (eta * w) / (2 * c^2 * ro)  )^(1/2) )
        Bet <- ( (b * w^2) / (2 * data$c^3 * data$ro) ) + ( (1 / a) * ( (eta * w) / (2 * data$c^2 * data$ro)  )^(1/2) )*8.68*1000
        output$rezultCw <- renderText({
          Cw <- data$c *( 1 - (eta / (2 * data$ro * w * a^2))^(1/2) )
          rezultCw <- Cw
        })
        rezultBet <- Bet
      })
      
      
    output$TempPlot1 <- renderPlot({
        data<-as.data.frame(selectedData2())
        B <- (data$c ^ 2) * data$ro
      x <- data.frame( nafta = c("nafta", "nafta", "nafta", "nafta", "nafta"), Temperatura = c(273, 283, 293, 303, 313), C = c(1374, 1332, 1292, 1253, 1216) )
     # x$Ct_ <- 1/sqrt( 1 + (data$d * data$B) / (data$del * data$E) )
      x$Ct_ <- 1/sqrt( 1 + (data$d * B) / (data$del * data$E) )
      ggplot(x, aes(Temperatura, y = value, color = variable))+ 
        
        geom_line(aes(y = Ct_, col = "Ct_"))+
        
        geom_point(aes(y = Ct_, col = "Ct_"))
      
    })
    
    output$TempPlot <- renderPlot({
        data<-as.data.frame(selectedData2())
        B <- (data$c ^ 2) * data$ro
      x <- data.frame( nafta = c("nafta", "nafta", "nafta", "nafta", "nafta"), Temperatura = c(273, 283, 293, 303, 313), C = c(1374, 1332, 1292, 1253, 1216) )
      x$Ct <- x$C/sqrt( 1 + (data$d * B) / (data$del * data$E) )

      ggplot(x, aes(Temperatura, y = value, color = variable))+ 
        geom_line(aes(y = C, col = "C")) + 
        geom_line(aes(y = Ct, col = "Ct"))+
        geom_point(aes(y = C, col = "C"))+
        geom_point(aes(y = Ct, col = "Ct"))
      
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
  
  selectedData1<-reactive({
          table<-matrix(1:6,nrow = 2,ncol = 3)
  })
  output$table1<-renderTable({
          selectedData1()
  })
  br()
  output$table2<-renderTable({
          selectedData2()
  })

})
