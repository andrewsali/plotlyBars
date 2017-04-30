#' Utility functions to convert regular plotly shiny commands to module commands
#' @param plotly_ui_expr
#' @export
withBarsUI <- function(plotly_ui_expr) {
  ui_from_expr(substitute(plotly_ui_expr),parent_environment = parent.frame())
}

#' Utility functions to convert regular plotly shiny commands to module commands
#' @param plotly_output_expr
#' @export
withBars <- function(plotly_output_expr) {
  render_expression <- substitute(plotly_output_expr)
  parent_environment <- parent.frame()
  call_module_from_expr(render_expression,parent_environment)
}

ui_from_expr <- function(ui_expression, parent_environment) {
  do.call(plotlyBarsUI,as.list(ui_expression)[-1],envir = parent_environment)
}

call_module_from_expr <- function(render_expression, parent_environment) {
  output_call_list <- as.list(render_expression)
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

#' @export
..srv.. <- structure(new.env(),class=c("..bars..","environment"))
..ui.. <- structure(new.env(),class=c("..bars..","environment"))

#' Synctactic sugar for calling the plotlyBars module
#' @export
addBars <- function(value,..ui..) {
  if (deparse(substitute(..ui..)) != "..ui..") {
    stop("You should call addBars for ui function as ... %>% addBars(..ui..)")
  }
  ui_from_expr(substitute(value),parent.frame())
}

#' @export
`addBars<-` <- function(x,value) {
#  if (TRUE || deparse(substitute(x)) != "..srv.." || class(substitute(value)) != "<-") {
#stop("You should call addBars in your server function as addBars(..srv..) <- output$... <-")
#  }
  call_module_from_expr(substitute(value),parent.frame())
}

#'
#' @export
`$<-...bars..` <- function(x,name,value) {
  print(deparse(substitute(value)))
  x
}

`%..srv..%` <- function(lhs,rhs) {
  call_module_from_expr(substitute(rhs),parent.frame())
}

#'
#' @export
`%..ui..%` <- function(lhs,rhs) {
  ui_from_expr(substitute(lhs),parent.frame())
}
