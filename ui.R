library(shiny)

source("server.R")

shinyUI(fluidPage(
    titlePanel("Assessed Property Values in Polk County, Iowa"),
    mainPanel(
        p("Iowa municipalities assess property taxes on residential, commercial, industrial, and agricultural properties."),
        p("Is Polk City's tax base too dependent on residential property?"),
        p("See how Polk City's tax base compares to other cities in Polk County."),
        selectInput("city", "Select a City:", choices = cities(prop_vals), selected = "Polk City"),
        plotOutput("plot"),
        p('Percentages on the charts are residential property as a percentage of total valuation.'),
        wellPanel(
            p("Notes:"),
            p("Data source:", a(href='http://web.assess.co.polk.ia.us/cgi-bin/web/tt/infoqry.cgi?tt=reconcile/reconcile_all', "Polk County Assessor")),
            p("Includes only property located in Polk County."),
            p("Starting in 2015, residential includes residential and multiresidential.")
            )
        )
    )
)
