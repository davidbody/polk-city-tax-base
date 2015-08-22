library(shiny)

shinyUI(fluidPage(
    titlePanel("Assessed Property Values in Polk County, Iowa"),
    mainPanel(
        selectInput("city", "Select a City:", choices = cities(prop_vals), selected = "Polk City"),
        plotOutput("plot"),
        p('Percentages on the charts are residential property as a percentage of total valuation.'),
        wellPanel(
            HTML("<p>Notes:</p>"),
            HTML("<p>Data source: <a href='http://web.assess.co.polk.ia.us/cgi-bin/web/tt/infoqry.cgi?tt=reconcile/reconcile_all'>Polk County Assessor</a></p>"),
            HTML("<p>Includes only property located in Polk County.</p>"),
            HTML("<p>Starting in 2015, residential includes residential and multiresidential.</p>")
            )
        )
    )
)
