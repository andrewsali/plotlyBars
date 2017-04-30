library(shiny)
library(plotly)
library(plotlyBars)

ui <- fluidPage(
  tags$b("This example shows a fake long-running reactive returning a plotly plot. Whilst the reactive is running, the animation is shown."),
  checkboxInput("show_plot","Show plot",value=TRUE),
  actionButton("redraw_plot","Re-draw plot"),
  plotlyOutput("example") %..ui..% addBars()
)

server <- function(input, output,session) {
    addBars(..srv..)  <- output$example <- renderPlotly({
      req(input$show_plot)
      input$redraw_plot
      Sys.sleep(10) # just for demo so you can enjoy the animation
      plot_ly(
        x = runif(1e4), y = runif(1e4), type = "scatter", mode = "markers"
      )
    })
}

shinyApp(ui = ui, server = server)
