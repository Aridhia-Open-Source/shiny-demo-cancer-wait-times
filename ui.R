################
###### UI ######
################

ui <- fluidPage(
  # Application title
  titlePanel("Cancer Waiting Times Stats"),
  # Style
  includeCSS("www/styles.css"),
  
  ### Side Bar ###
  sidebarLayout(
    sidebarPanel(
      selectizeInput("sheet", "Sheets", choices = xl_sheets[[1]][-1],
                     options = list(placeholder = "select a sheet", onInitialize = I("function() { this.setValue(''); }"))),
      conditionalPanel(
        condition = "input.sheet != ''",
        selectizeInput("regions", "Regions", choices = NULL,
                       options = list(placeholder = "select region", onInitialize = I("function() { this.setValue(''); }"))),
        conditionalPanel(
          condition = "input.sheet.includes('BY CANCER')",
          selectizeInput("cancerType", "Cancer Type", choices = NULL,
                         options = list(placeholder = "select cancer type", onInitialize = I("function() { this.setValue(''); }")))
        ),
        selectizeInput("quarter", "Quarter", choices = NULL, options = list(placeholder = "select quarter", onInitialize = I("function() { this.setValue(''); }")))
      ),
      htmlOutput("national_avg")
    ),
    ### End of Side Bar ###
    
    ### Main Panel ###
    fluidRow(
      column(
        tabsetPanel(type = "tabs",
                    tabPanel("Plot", plotOutput(outputId = "plot", width = "850px")),
                    tabPanel("Map", leafletOutput(outputId = "map",  width = "850px")),
                    documentation_tab()
        ), width = 5
      ),
      column(width = 3,
        div(DT::dataTableOutput("sheet"), style = "font-size: 80%")
      )
    )
    ### End of Main Panel ###
  )
)
