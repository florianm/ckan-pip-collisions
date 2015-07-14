library(shiny)

shinyUI(navbarPage(
  title = 'CKAN dependency explorer',
  tabPanel('Deps',  dataTableOutput('ex1')),
  tabPanel('Docs',  includeMarkdown("README.md"))
))
