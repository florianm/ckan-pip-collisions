library(shiny)

shinyServer(function(input, output) {

  # display 10 rows initially
  output$ex1 <- renderDataTable(dependencies(),
                                options = list(
                                  pageLength = 15,
                                  lengthMenu = list(c(15, 100, -1),
                                                    c('15', '100', 'All'))
                                  ))
  # output object: download PDF
  output$downloadCSV <- downloadHandler(
    filename = "dependencies.csv",
    content = function(file) {
      write.csv(dependencies(), file, row.names = F)},
    contentType = "text/csv"
  )

  output$save2disk <- renderUI({
      downloadButton("downloadCSV", "Download CSV")
  })

  # TODO: add button "refresh local extension repos"
  # TODO: add button "download list as CSV"
})
