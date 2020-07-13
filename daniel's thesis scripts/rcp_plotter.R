rcp26 <- read.csv("C:/Users/danie/Documents/Precip_and_Temp_Mapper/Land_Use_Thesis/rcp26.csv")
rcp45 <- read.csv("C:/Users/danie/Documents/Precip_and_Temp_Mapper/Land_Use_Thesis/rcp45.csv")
rcp60 <- read.csv("C:/Users/danie/Documents/Precip_and_Temp_Mapper/Land_Use_Thesis/rcp60.csv")
rcp85 <- read.csv("C:/Users/danie/Documents/Precip_and_Temp_Mapper/Land_Use_Thesis/rcp85.csv")

rcp26trim <- rcp26[which(rcp26[,1]>2000 & rcp26[,1]<2150),1:2]
rcp45trim <- rcp45[which(rcp45[,1]>2000 & rcp45[,1]<2150),1:2]
rcp60trim <- rcp60[which(rcp60[,1]>2000 & rcp60[,1]<2150),1:2]
rcp85trim <- rcp85[which(rcp85[,1]>2000 & rcp85[,1]<2150),1:2]

plot(rcp85trim[,1], rcp85trim[,2], type = 'l', lwd = 3, col = 'blue', xlab = 'Year', ylab = 'Atmospheric Concentration of GHG (CO2 Equivalence, ppm)')
lines(rcp60trim[,1], rcp60trim[,2], type = 'l', lwd = 3, col = 'red')
lines(rcp45trim[,1], rcp45trim[,2], type = 'l', lwd = 3, col = 'black')
lines(rcp26trim[,1], rcp26trim[,2], type = 'l', lwd = 3, col = 'green')
legend('topleft', legend = c('RCP 2.6', 'RCP 4.5', 'RCP 6.0', 'RCP 8.5'), col = c('green', 'black', 'red', 'blue'), lwd = 3)
