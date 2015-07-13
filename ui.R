library(shiny)

shinyUI(navbarPage(
  title = 'CKAN dependency explorer',
  tabPanel('Dependencies',         dataTableOutput('ex1'))
))
