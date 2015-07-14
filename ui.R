library(shiny)

shinyUI(navbarPage(
  title = 'CKAN dependency explorer',

  tabPanel('Deps',
           uiOutput("save2disk"),
           dataTableOutput('ex1')),

  tabPanel('Docs',
           includeMarkdown("README.md"))

))
