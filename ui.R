library(shiny)

source("./getData.R")

shinyUI(pageWithSidebar(
    headerPanel("Assessed Property for Cities in Polk County, Iowa"),
    sidebarPanel(
        selectInput("city", "Select a City:", choices = cities(df))
    ),
    mainPanel(
        h3('Assessed Property Values'),
        plotOutput("plot")
    )
))
