library(shiny)

shinyServer(
    function(input, output) {
        output$city <- renderPrint({input$city})
        output$plot <- renderPlot({plotCity(input$city)})
    }
)
