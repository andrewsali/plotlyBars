library(shiny)
library(shinydashboard)
library(plotly)
library(plotlyBars)

ui <- fluidPage(
  checkboxInput("show_plot","Show plot",value=FALSE),
  plotlyBarsUI("example")
)

server <- function(input, output) {
  callModule(plotlyBars,
             "example",
             plot_reactive = reactive({
               req(input$show_plot)
               Sys.sleep(10) # just for demo so you can enjoy the animation
               plot_ly(
                 x = 2, y = 3, type = "scatter", mode = "markers"
               )
             })
  )
}

shinyApp(ui = ui, server = server)
