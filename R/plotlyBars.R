#' The UI function
#' @param id The namespace id
#' @param ... Further arguments passed to \code{\link{plotlyOutput}}
#' @details See \url{https://github.com/andrewsali/plotlyBars}
#' @export
plotlyBarsUI <- function(id,...) {
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),
    shiny::singleton(
      tags$head(
        tags$style(
          # from http://stackoverflow.com/questions/36129522/show-loading-graph-message-in-plotly  ---  2017-03-29 08:44:10  -----
          HTML(
            ".plotly.html-widget.html-widget-output.shiny-bound-output.js-plotly-plot {
            z-index: 22;
            position: relative;
}

.plotlybars {
padding: 0 10px;
vertical-align: bottom;
width: 100%;
height: 100%;
overflow: hidden;
position: relative;
box-sizing: border-box;
}

.plotlybars-wrapper {
width: 165px;
height: 100px;
margin: 0 auto;
left: 0;
right: 0;
position: absolute;
z-index: 1;
}

.plotlybars-text {
color: #447adb;
font-family: 'Open Sans', verdana, arial, sans-serif;
font-size: 80%;
text-align: center;
margin-top: 5px;
}

.plotlybars-bar {
background-color: #447adb;
height: 100%;
width: 13.3%;
position: absolute;

-webkit-transform: translateZ(0);
transform: translateZ(0);

animation-duration: 2s;
animation-iteration-count: infinite;
animation-direction: normal;
animation-timing-function: linear;

-webkit-animation-duration: 2s;
-webkit-animation-iteration-count: infinite;
-webkit-animation-direction: normal;
-webkit-animation-timing-function: linear;
}

.b1 { left: 0%; top: 88%; animation-name: b1; -webkit-animation-name: b1; }
.b2 { left: 14.3%; top: 76%; animation-name: b2; -webkit-animation-name: b2; }
.b3 { left: 28.6%; top: 16%; animation-name: b3; -webkit-animation-name: b3; }
.b4 { left: 42.9%; top: 40%; animation-name: b4; -webkit-animation-name: b4; }
.b5 { left: 57.2%; top: 26%; animation-name: b5; -webkit-animation-name: b5; }
.b6 { left: 71.5%; top: 67%; animation-name: b6; -webkit-animation-name: b6; }
.b7 { left: 85.8%; top: 89%; animation-name: b7; -webkit-animation-name: b7; }

@keyframes b1 { 0% { top: 88%; } 44% { top: 0%; } 94% { top: 100%; } 100% { top: 88%; } }
@-webkit-keyframes b1 { 0% { top: 88%; } 44% { top: 0%; } 94% { top: 100%; } 100% { top: 88%; } }

@keyframes b2 { 0% { top: 76%; } 38% { top: 0%; } 88% { top: 100%; } 100% { top: 76%; } }
@-webkit-keyframes b2 { 0% { top: 76%; } 38% { top: 0%; } 88% { top: 100%; } 100% { top: 76%; } }

@keyframes b3 { 0% { top: 16%; } 8% { top: 0%; } 58% { top: 100%; } 100% { top: 16%; } }
@-webkit-keyframes b3 { 0% { top: 16%; } 8% { top: 0%; } 58% { top: 100%; } 100% { top: 16%; } }

@keyframes b4 { 0% { top: 40%; } 20% { top: 0%; } 70% { top: 100%; } 100% { top: 40%; } }
@-webkit-keyframes b4 { 0% { top: 40%; } 20% { top: 0%; } 70% { top: 100%; } 100% { top: 40%; } }

@keyframes b5 { 0% { top: 26%; } 13% { top: 0%; } 63% { top: 100%; } 100% { top: 26%; } }
@-webkit-keyframes b5 { 0% { top: 26%; } 13% { top: 0%; } 63% { top: 100%; } 100% { top: 26%; } }

@keyframes b6 { 0% { top: 67%; } 33.5% { top: 0%; } 83% { top: 100%; } 100% { top: 67%; } }
@-webkit-keyframes b6 { 0% { top: 67%; } 33.5% { top: 0%; } 83% { top: 100%; } 100% { top: 67%; } }

@keyframes b7 { 0% { top: 89%; } 44.5% { top: 0%; } 94.5% { top: 100%; } 100% { top: 89%; } }
@-webkit-keyframes b7 { 0% { top: 89%; } 44.5% { top: 0%; } 94.5% { top: 100%; } 100% { top: 89%; } }"
          )
        )
      ))
    ,
    div(id = ns("plotly-container")
        ,
        div(id=ns("plotly-bars"),
            class = "plotlybars-wrapper",
            style="display:none",
            div( class="plotlybars"
                 , div(class="plotlybars-bar b1")
                 , div(class="plotlybars-bar b2")
                 , div(class="plotlybars-bar b3")
                 , div(class="plotlybars-bar b4")
                 , div(class="plotlybars-bar b5")
                 , div(class="plotlybars-bar b6")
                 , div(class="plotlybars-bar b7")
            )
            , div(class="plotlybars-text"
                  , p("loading")
            )
        )
        , plotly::plotlyOutput(ns("plotly_plot"),...)
    )
  )
}

#' Module function which calls \code{\link{renderPlotly}} and ensures that loading animation is appropriately displayed / hidden.
#' @export
#' @param plot_reactive A reactive returning a plotly object
#' @param ... Further options passed to \code{\link{renderPlotly}}
#' @details See \url{https://github.com/andrewsali/plotlyBars}
plotlyBars <- function(input,output,session,plot_reactive,...) {
  ns <- session$ns

  # we need to ensure that renderPlotly only runs after the animation is flushed & loaded to be certain that the loading animation is rendered
  update_plot <- reactiveValues(val=NULL)

  observe({
    update_plot$val <- runif(1)
    shinyjs::runjs(sprintf("$('#%s').show()",ns("plotly-bars")))
    on.exit({
      if (hidePlot) {
        shinyjs::runjs(sprintf("$('#%s').hide()",ns("plotly-bars")))
      }
    })
    hidePlot <- TRUE
    req(plot_reactive())
    hidePlot <- FALSE
  })

  output$plotly_plot <- renderPlotly({
    update_plot$val
    isolate(plot_reactive())
  })
}
