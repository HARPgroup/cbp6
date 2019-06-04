# STAT 545: Graphing - Using Colors in R

#### Limits ####
j_xlim <- c(460,60000)
j_ylim <- c(47,82)

library(gapminder)
library(tidyverse)

n <- 8
set.seed(1)
(jdat <- data.frame(w = round(rnorm(n), 2),
                    x = 1:n,
                    y = I(LETTERS[1:n]),
                    z = runif(n) > 0.3,
                    v = rep(LETTERS[9:12], each = 2)))

#### Plots ####
plot(gapminder$lifeExp ~ gapminder$gdpPercap, jDat, log = 'x', xlim=j_xlim, ylim = j_ylim,
     main = "Start your engines...")

#change color to red
plot(gapminder$lifeExp ~ gapminder$gdpPercap, jDat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = "red", main = 'col = "red"')

#change color to blue and orange
plot(gapminder$lifeExp ~ gapminder$gdpPercap, jDat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = c("blue", "orange"), main = 'col = c("blue", "orange")')

#change to N random colors (8 colors here)
plot(gapminder$lifeExp ~ gapminder$gdpPercap, jDat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:8, main = paste0('col = 1:', 8))
with(jdat, text(x = gdpPercap, y = lifeExp, pos = 1))

#labels default colors with color names
plot(gapminder$lifeExp ~ gapminder$gdpPercap, jDat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:8, main = 'the default palette()')
with(jDat, text(x = gapminder$gdpPercap, y = gapminder$lifeExp, labels = palette(),
                pos = rep(c(1, 3, 1), c(5, 1, 2))))

#custom colors - store them as object in one place then call later

j_colors <- c('chartreuse3', 'cornflowerblue', 'darkgoldenrod1', 'peachpuff3',
              'mediumorchid2', 'turquoise3', 'wheat4', 'slategray2')

plot(gapminder$lifeExp ~ gapminder$gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_colors, main = 'custom colors!')
with(jdat, text(x = gapminder$gdpPercap, y = gapminder$lifeExp, labels = j_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 
                #use colors() to view all color options

#look at palettes
library(RColorBrewer)

display.brewer.all()

        #view a single palette
display.brewer.pal(n = 8, name = 'Dark2')
        #specify custom colors with palette
j_brew_colors <- brewer.pal(n = 8, name = "Dark2")
plot(gapminder$lifeExp ~ gapminder$gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_brew_colors, main = 'Dark2 qualitative palette from RColorBrewer')
with(jdat, text(x = gapminder$gdpPercap, y = gapminder$lifeExp, labels = j_brew_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 

#virids palette
library(ggplot2)
library(viridis)
library(hexbin)

ggplot(data.frame(x = rnorm(10000), y = rnorm(10000)), aes(x = x, y = y)) +
        geom_hex() + coord_fixed() +
        scale_fill_viridis() + theme_bw()

        #specify colors with hexadecimal RGB colors
brewer.pal(n = 8, name = "Dark2")

#### Good practices ####

library(ggplot2)

#dont do this
life_exp <- gapminder$lifeExp
year <- gapminder$year
ggplot(aes(x = year, y = life_exp)) + geom_jitter()

#do this
ggplot(data = gapminder, aes(x = year, y = life_exp)) + geom_jitter()

        #to avoid typing gapminder each time
                #with(gapminder, cor(year, lifeExp)) OR
                #gapminder %$%cor(year, lifeExp)      library(magrittr)

#creating tables by hand
tibble(x = 1:5,
       y = x ^ 2,
       text = c("alpha", "beta", "gamma", "delta", "epsilon"))
my_dat <- tribble(
        ~ x, ~ y,    ~ text,
        1,   1,   "alpha",
        2,   4,    "beta",
        3,   9,   "gamma",
        4,  16,   "delta",
        5,  25, "epsilon"
)
ggplot(my_dat, aes(x, y)) + geom_line() + geom_text(aes(label = text))

#reshaping data
japan_dat <- gapminder %>%
        filter(country == "Japan")
japan_tidy <- japan_dat %>%
        gather(key = var, value = value, pop, lifeExp, gdpPercap)
dim(japan_dat) #> [1] 12  6
dim(japan_tidy) #> [1] 36  5

p <- ggplot(japan_tidy, aes(x = year, y = value)) +
        facet_wrap(~ var, scales="free_y")
p + geom_point() + geom_line() +
        scale_x_continuous(breaks = seq(1950, 2011, 15))

        #minimal code for above example
japan_tidy <- gapminder %>%
        filter(country == "Japan") %>%
        gather(key = var, value = value, pop, lifeExp, gdpPercap)
ggplot(japan_tidy, aes(x = year, y = value)) +
        facet_wrap(~ var, scales="free_y") +
        geom_point() + geom_line() +
        scale_x_continuous(breaks = seq(1950, 2011, 15))

#### Writing figures to file ####
        #to save file
        #ggsave("my-awesome-graph.png", plotvariablename)

suppressPackageStartupMessages(library(ggplot2))
library(gapminder)
p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
p1 <- p + ggtitle("scale = 0.6")
p2 <- p + ggtitle("scale = 2")
p3 <- p + ggtitle("base_size = 20") + theme_grey(base_size = 20)
p4 <- p + ggtitle("base_size = 3") + theme_grey(base_size = 3)
ggsave("img/fig-io-practice-scale-0.3.png", p1, scale = 0.6)
ggsave("img/fig-io-practice-scale-2.png", p2, scale = 2)
ggsave("img/fig-io-practice-base-size-20.png", p3)
ggsave("img/fig-io-practice-base-size-3.png", p4)

pdf("test-fig-proper.pdf") # starts writing a PDF to file
plot(1:10)                    # makes the actual plot
dev.off()                     # closes the PDF file
#> quartz_off_screen 
#>                 2

plot(1:10)

#### Multiple Plots ona Page ####

library(gridExtra)
library(gapminder)
library(ggplot2)

        #Store the constituent plots to plot objects and then pass them to grid.arrange() or arrangeGrob()
p_dens <- ggplot(gapminder, aes(x = gdpPercap)) + geom_density() + scale_x_log10() +
        theme(axis.text.x = element_blank(),
              axis.ticks = element_blank(),
              axis.title.x = element_blank())
p_scatter <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
        geom_point() + scale_x_log10() #p_both <- arrangeGrob(p_dens, p_scatter, nrow = 2, heights = c(0.35, 0.65))
#print(p_both)
grid.arrange(p_dens, p_scatter, nrow = 2, heights = c(0.35, 0.65))

        #OR use multiplot function
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
        require(grid) # Make a list from the ... arguments and plotlist
        plots <- c(list(...), plotlist)
        
        numPlots = length(plots) # If layout is NULL, then use 'cols' to determine layout
        if (is.null(layout)) {
                layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                                 ncol = cols, nrow = ceiling(numPlots/cols))
        }
        
        if (numPlots==1) {
                print(plots[[1]])
                
        } else {      #set up the page
                grid.newpage()
                pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
                # Make each plot, in the correct location
                for (i in 1:numPlots) {
                        # Get the i,j matrix positions of the regions that contain this subplot
                        matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
                        
                        print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                                        layout.pos.col = matchidx$col))
                }
        }
}
        
multiplot(p1, p2, p3, p4, cols = 2)

        
        
        
        
        
        
        
        

