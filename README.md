# plotlyBars

A module to create plotly bars animation. The animation will automatically appear / disappear exactly as the plotly plot does,
therefore you don't need to worry about handling anything else additionally.

The animation starts __before__ the plot calculation, so you can use this instead of `shiny::withProgress` in case you don't 
have some meaningful progress indication.

The animation is based on this thread: http://stackoverflow.com/questions/36129522/show-loading-graph-message-in-plotly

How to install: 

`
devtools::install_github("andrewsali/plotlyBars")
`

How to run the example

`
shiny::runGitHub("andrewsali/plotlyBars")
`

