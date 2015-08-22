library(shiny)
library(reshape2)
library(ggplot2)
library(scales)

load("./data/prop_vals.Rda")

cities <- function(prop_vals) {
    as.list(unique(as.character(prop_vals$city)))
}

years <- unique(prop_vals$year)

prop_vals$total <- prop_vals$residential + prop_vals$commercial + prop_vals$industrial + prop_vals$agricultural

plotCity <- function(city) {
    percent_residential <- prop_vals[prop_vals$city == city, c(1,2,3,7)]
    percent_residential$percent <- percent_residential$residential / percent_residential$total

    city.without_totals <- prop_vals[prop_vals$city == city, -7]

    city.m <- melt(city.without_totals, id.vars = c("year", "city"), variable.name = "prop_class")

    g <- ggplot(city.m, aes(x = year, y = value, fill = prop_class))
    g <- g + geom_bar(stat="identity")
    g <- g + scale_y_continuous(labels = dollar)
    g <- g + scale_x_continuous(breaks = years)
    g <- g + labs(title = city, y = "Assessed Property Value", x = "Year")
    g <- g + labs(fill = "Property Class")

    for(year in years) {
        r <- percent_residential[percent_residential$year == year, 3]
        p <- percent_residential[percent_residential$year == year, 5] * 100
        g <- g + annotate("text", x = year, y = r * .95, label = sprintf("%.1f %%", p))
    }

    g
}

shinyServer(
    function(input, output) {
        output$city <- renderPrint({input$city})
        output$plot <- renderPlot({plotCity(input$city)})
    }
)
