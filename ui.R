library(shiny)
library(datasets)
library(shinythemes)
library(shinycssloaders)
ui <- shinyUI(fluidPage(theme = shinytheme("cyborg"),
titlePanel("Mini Project"),
 tabsetPanel(id="change",
            tabPanel("PHEDOPHILIC anlysis",
             titlePanel("Upload your Chat Files"),
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose CSV/Text File',
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv/.txt')) ,
                 actionButton("submitdata",label = "Analyse")),
               
               
            mainPanel(
                 withSpinner(plotOutput('MyPlot'),type=6,color="#ffffff")
                
               )
             )
    ),tabPanel("TEST RESULTS", value = "results",
              h4("RESULT:"),
                 mainPanel(
                   
                   textOutput("value"),
                   imageOutput("pacifier_image")
                   
                 )
              ),
    tabPanel("DEVELOPERS", value = "credits",
             h4("Mini project"),
             sidebarLayout(
               sidebarPanel(
                 h4("CREDITS")),
             mainPanel(
               
              h3("R.AISHWARYA") 
              
              
             ))
              
              
  ))
)
)