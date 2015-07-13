library(shiny)

shinyServer(function(input, output) {

  # display 10 rows initially
  output$ex1 <- renderDataTable(dependencies(),
                                options = list(
                                  pageLength = 15,
                                  lengthMenu = list(c(15, 100, -1),
                                                    c('15', '100', 'All'))
                                  ))

  # TODO: add button "refresh local extension repos"
  # TODO: add button "download list as CSV"
})
