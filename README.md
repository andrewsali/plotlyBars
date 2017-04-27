# plotlyBars

A Shiny module to create plotly bars animation. The animation will automatically appear / disappear exactly as the plotly plot does,
therefore you don't need to worry about handling anything else additionally.

The animation starts __before__ the plot calculation, so you can use this instead of `shiny::withProgress` in case you don't 
have some meaningful progress indication.

The animation is based on this thread: http://stackoverflow.com/questions/36129522/show-loading-graph-message-in-plotly

## Installation & example

How to install: 

`
devtools::install_github("andrewsali/plotlyBars")
`

How to run the example given in [app.R](app.R)

`
shiny::runGitHub("andrewsali/plotlyBars")
`
## How to adapt your code

The wrapping is implemented as a [Shiny module](https://shiny.rstudio.com/articles/modules.html), therefore compared to the usual plotlyOutput / renderPlotly pair, slight code change is required. 

* In your UI function you need to call `plotlyBarsUI("my_id")` instead of `plotlyOutput("my_id")`.
* In your server function instead of calling `renderPlotly`, just use `callModule` and pass it a reactive that returns a plotly object. For example, in the server function one could write:
`callModule(plotlyBars,
             "my_id",
             plot_reactive = reactive({
               plot_ly(
                 x = 2, y = 3, type = "scatter", mode = "markers"
               )
             })
  )`
  
  This calls the plotlyBars function with id "my_id" and passes in a reactive that returns a plotly object. So whatever you would've put in `renderPlotly`, you can just wrap it in `reactive` and pass it as the `plot_reactive` argument to `shiny::callModule`.
