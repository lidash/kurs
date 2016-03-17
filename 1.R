x <- data.frame( nafta = c("nafta", "nafta", "nafta", "nafta", "nafta"), Temperatura = c(273, 283, 293, 303, 313), C = c(1374, 1332, 1292, 1253, 1216) )
x$Ct <- x$C/2
with(x,{
  plot(Temperatura[1:length(Temperatura)], C, "l",
       ylab="Ct",
       xlab="c")
  plot(Temperatura[1:length(Temperatura)], Ct, "l",
       ylab="Ct",
       xlab="c")
})

