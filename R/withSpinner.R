#' Add a spinner that shows when an output is recalculating
#' @param ui_element A UI element that should be wrapped with a spinner when the corresponding output is being calculated.
#' @export
withSpinner <- function(ui_element) {
  tagList(
    shiny::singleton(
      tags$head(tags$link(rel="stylesheet",href="assets/spinner.css"))
    ),
    shiny::singleton(
      tags$script(src="assets/spinner.js")
    ),
    div(class="shiny-spinner-output-container",
        div(class="shiny-spinner-spinner-container",
            tags$img(
              class="shiny-spinner-loading-spinner",
              src="assets/spinner.gif")

        ),
        ui_element
    )
  )
}
