library(shiny)

source("./getData.R")

shinyUI(fluidPage(
    titlePanel("Assessed Property Values in Polk County, Iowa"),
    mainPanel(
        selectInput("city", "Select a City:", choices = cities(df), selected = "Polk City"),
        plotOutput("plot"),
        p('Percentages on the charts are residential property as a percentage of total valuation.'),
        wellPanel(
            HTML("<p>Notes:</p>"),
            HTML("<p>Data source: Polk County Assessor <a href='http://web.assess.co.polk.ia.us/cgi-bin/web/tt/infoqry.cgi?tt=reconcile/reconcile_all'>web.assess.co.polk.ia.us/cgi-bin/web/tt/infoqry.cgi?tt=reconcile/reconcile_all</a></p>"),
            HTML("<p>Includes only property located in Polk County.</p>"),
            HTML("<p>Residential includes multiresidential class added in 2015.</p>")
            )
        )
    )
)
