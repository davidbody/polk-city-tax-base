library(shiny)

source("server.R")

shinyUI(fluidPage(
    titlePanel("Assessed Property Values in Polk County, Iowa"),
    mainPanel(
        p("Iowa municipalities assess property taxes on residential, commercial, industrial, and agricultural properties."),
        p("Is Polk City's property tax base too dependent on residential property?"),
        p("See how Polk City's tax base compares to other cities in Polk County."),
        selectInput("city", "Select a City:", choices = cities(prop_vals), selected = "Polk City"),
        plotOutput("plot"),
        p('Percentages on the charts are residential property as a percentage of total valuation.'),
        wellPanel(
            p("Notes:"),
            p("Data source:", a(href='http://web.assess.co.polk.ia.us/cgi-bin/web/tt/infoqry.cgi?tt=reconcile/reconcile_all', "Polk County Assessor")),
            p("Includes only property located in Polk County. Some cities are partly to almost completely in bordering counties."),
            p("Starting in 2015, residential includes residential and multiresidential.")
            ),
        p("This is a course project for", a(href='https://www.coursera.org/course/devdataprod', "Developing Data Products")),
        p("A slide deck with some background information is availble here:", a(href='https://davidbody.github.io/polk-city-tax-base/pitch', "davidbody.github.io/polk-city-tax-base/pitch")),
        p("Source code is here:", a(href='https://github.com/davidbody/polk-city-tax-base', "github.com/davidbody/polk-city-tax-base"))
        )
    )
)
