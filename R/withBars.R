#' Utility functions to convert regular plotly shiny commands to module commands
#' @param plotly_ui_expr
#' @export
withBarsUI <- function(plotly_ui_expr) {
  do.call(plotlyBarsUI,as.list(substitute(plotly_ui_expr))[-1],envir = parent.frame())
}

#' Utility functions to convert regular plotly shiny commands to module commands
#' @param plotly_output_expr
#' @export
withBars <- function(plotly_output_expr) {
  output_call_list <- as.list(substitute(plotly_output_expr))

  parent_environment <- parent.frame()

  output_assignment <- deparse(output_call_list[[2]])

  output_id <- NULL

  # given as string using $
  if (grepl('output\\$(.*)',output_assignment)) {
    output_id <- gsub('output\\$(.*)',"\\1",output_assignment)
  }

  # given as string within [[]]
  if (grepl('output\\[\\["(.*)"\\]\\]',output_assignment)) {
    output_id <- gsub('output\\[\\["(.*)"\\]\\]',"\\1",output_assignment)
  }

  # give using an expression within [[]]
  if (is.null(output_id) && grepl('output\\[\\[(.*)\\]\\]',output_assignment)) {
    output_id <- gsub('output\\[\\[(.*)\\]\\]',"\\1",output_assignment)
    output_id <- eval(parse(text=output_id),envir = parent_environment)
  }

  render_env <- new.env(parent=parent_environment)
  render_env$output_call_list <- output_call_list
  render_reactive <- reactive(eval(as.list(output_call_list[[3]])[[2]]),env=render_env)

  do.call(callModule,c(list(plotlyBars,output_id,render_reactive),as.list(output_call_list[[3]][-c(1,2)])),envir = parent_environment)
}
