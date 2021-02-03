documentation_tab <- function() {
  tabPanel("Help",
           fluidPage(width = 12,
                     fluidRow(
                       
                       h3("Cancer wait times"), 
                       p("This RShiny mini-app offers a quick visualisation of the treatment waiting times of people referred by GP with suspected 
                         cancer or breast symptoms and those subsequently diagnosed with and treated for cancer by the NHS in England."),
                       h4("How to use the mini-app"),
                       p("The app will open in the 'Plot' tab, here: "),
                       tags$ol(
                         tags$li("Select the sheet you wish to visualise using the drop-down menu on the right-side. A table displaying the 
                                 data will appear in the bottom of the screen."),
                         tags$li("Choose the region. A graph showing the differences of the % treated within your range between national average and regional 
                                 providers will appear in the main panel; and the table below will update to show the data only for the selected region."),
                         tags$li("If you want, you can further filter the data in the plot and table by choosing a cancer type and a quarter.")
                       ),
                       p("The 'Map' tab displays an interactive map showing the average waiting times for each region in England. If you hover over the different
                         regions, the average waiting time will appear. Notice that the map will be grey if you have not chosen a sheet."),
                       h4("Walkthrough video"),
                       tags$video(src="cancer-wait-times.mp4", type = "video/mp4", width="100%", height = "350", frameborder = "0", controls = NA),
                       p(class = "nb", "NB: This mini-app is for provided for demonstration purposes, is unsupported and is utilised at user's 
                       risk. If you plan to use this mini-app to inform your study, please review the code and ensure you are 
                       comfortable with the calculations made before proceeding. ")
                       
                     )
                     
                     
                     
                     
           ))
}