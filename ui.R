#source("global.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  # Application title
  titlePanel("Cancer Waiting Times Stats"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectizeInput('sheet','Sheets',choices = xl_sheets[[1]][-1], options = list(placeholder = 'select a sheet', onInitialize = I('function() { this.setValue(""); }'))),
      conditionalPanel(
        condition = "input.sheet != ''",
        selectizeInput('regions','Regions',choices = NULL, options = list(placeholder = 'select region', onInitialize = I('function() { this.setValue(""); }'))),
        
        conditionalPanel(
          condition = "input.sheet.includes('BY CANCER')",
          selectizeInput('cancerType','Cancer Type',choices = NULL, options = list(placeholder = 'select cancer type', onInitialize = I('function() { this.setValue(""); }')))

        ),
        
        selectizeInput('quarter','Quarter',choices = NULL, options = list(placeholder = 'select quarter', onInitialize = I('function() { this.setValue(""); }')))
      ),
      htmlOutput("national_avg")
    ),
    
    # Show a plot of the generated distribution
    fluidRow(
      column(
        tabsetPanel(type = "tabs",
                    tabPanel("Plot", plotOutput(outputId = "plot", width = "850px")),
                    tabPanel("Map", leafletOutput(outputId = "map",  width = "850px"))
        ), width = 5
      ),
      column(
        div(DT::dataTableOutput('sheet'), style = "font-size: 80%") , width = 3)
    )
  )
)
