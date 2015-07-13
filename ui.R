library(shiny)

shinyUI(navbarPage(
  title = 'CKAN dependency explorer',
  tabPanel('Dependencies',     dataTableOutput('ex1'))
#   tabPanel('Length menu',        dataTableOutput('ex2')),
#   tabPanel('No pagination',      dataTableOutput('ex3')),
#   tabPanel('No filtering',       dataTableOutput('ex4')),
#   tabPanel('Individual filters', dataTableOutput('ex5')),
#   tabPanel('Function callback',  dataTableOutput('ex6'))
))
