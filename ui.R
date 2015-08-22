library(shiny)

source("./getData.R")

shinyUI(pageWithSidebar(
    headerPanel("Assessed Property Values in Polk County, Iowa"),
    sidebarPanel(
        selectInput("city", "Select a City:", choices = cities(df), selected = "Polk City")
    ),
    mainPanel(
        h3('Assessed Property Values'),
        plotOutput("plot")
    )
))
