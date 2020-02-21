
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  names(xl_sheets) <- list.files("./datafiles/")
  dfs <- reactiveValues(merged = 0, by_area = 0, regions = 0)
  
  b <- leaflet(options = leafletOptions(minZoom = 5.7, maxZoom = 5.7)) %>%
    addTiles() %>%
    addPolygons(data = map_gsdf, 
                layerId= map_gsdf$scn16cd, 
                color = "#444444", weight = 1, smoothFactor = 0.5,
                popup = paste0("<b>",map_gsdf$scn16nm,"</b>"),
                opacity = 1.0, fillOpacity = 0.5,
                highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE))
  
  output$map <- renderLeaflet(b)
  
  observeEvent(input$sheet,{
    
    if (input$sheet != ""){
      
      list_of_sheets <- names(xl_sheets) %>%
        map(~paste0("./datafiles/", .x))%>%
        map(~read_rm_sheet(.x,input$sheet))%>% 
        map(add_ons_id)
      
      merged <- do.call('rbind', list_of_sheets)
      merged[is.na(merged)] = "N/A"
      dfs$merged <- merged
      dfs$by_area <- NULL
      
      areas <- merged[[1]] %>%
        unique()
      
      names(areas) <- c('West Midlands', 'South East Coast', 'London', 'North West', 'South Central', 'North East', 
                        'Yorkshire and the Humber', 'East Midlands', 'East of England', 'South West', 'N/A')
      dfs$regions <- areas
      
      time_quarters <- merged$time_period %>%
        unique()
      
      updateSelectizeInput(session, 'regions', choices = names(areas))
      updateSelectizeInput(session, 'quarter', choices = time_quarters)
      
      output$sheet <- DT::renderDataTable(merged,options = list( targets = '_all'))
      
      percentage_name <- names(merged)[[match('total',names(merged)) + 3]]
    
      averages <- merged %>%
        group_by(ons_area_id) %>%
        summarise(average_time = mean(.data[[percentage_name]])) %>%
        .[map_gsdf@data$scn16cd,] %>%
        .[-11,] %>%
        select(average_time) %>%
        pull( ., average_time) %>%
        round(., 2)
      
      map_gsdf@data$average <- as.factor(averages)
      
      min <- round(min(averages),0) - 1
      max <- round(max(averages),0) + 1
      
      pal <- colorNumeric(
        palette = "Reds",
        domain = min : max
      )
      
      b <- leaflet(options = leafletOptions(minZoom = 5.7, maxZoom = 5.7)) %>%
        addTiles() %>%
        addPolygons(data = map_gsdf, 
                    layerId= map_gsdf$scn16cd, 
                    color = ~pal(averages), weight = 1, smoothFactor = 0.5,
                    popup = paste0("<b>",map_gsdf$scn16nm,"<br></b>", "<b>", percentage_name, ":</b><br>",map_gsdf$average, "</b>"),
                    opacity = 1.0, fillOpacity = 0.7,
                    highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE))
      
      output$map <- renderLeaflet(b)
      
      
      # if (grepl("BY CANCER", input$sheet)){
      #   cancer_field <- names(merged)[[match('total',names(merged)) - 1]]
      #   cancer_types <- merged[[cancer_field]] %>%
      #     unique()
      #   updateSelectizeInput(session, 'cancerType', choices = cancer_types)
      # }
      }
  })
  
  observeEvent(input$regions,{
    
    if (input$regions != ""){
      
      tmp <- dfs$merged[which(dfs$merged[[1]] == dfs$regions[[input$regions]]),]
      dfs$by_area <- tmp
      
      time_quarters <- tmp$time_period %>%
        unique()
      
      updateSelectizeInput(session, 'quarter', choices = time_quarters)
      
      output$sheet <- DT::renderDataTable(tmp, options = list( targets = '_all'))
      
      percentage_name <- names(tmp)[[match('total',names(tmp)) + 3]]
      nat_avg <- (sum(tmp[[which(names(tmp)=='total')+1]]) / sum(tmp$total)) * 100
      
      average_diff <- tmp %>%
        group_by(ods_code) %>%
        summarise(average_time = mean(.data[[percentage_name]])) %>%
        mutate (difference = average_time - nat_avg)
      
      p <- ggplot(data = average_diff, aes(x = ods_code , y =difference)) + 
        geom_col(aes(fill = difference)) +
        scale_fill_gradient2(low = "red",
                             high = "green",
                             midpoint = median(average_diff$difference))
      
      output$plot <- renderPlot(p)
    }
  })
  
  observeEvent(input$quarter,{
    
    if (input$quarter != ""){
      
      if (is.null(dfs$by_area)){
        tmp <- dfs$merged[which(dfs$merged[['time_period']] == input$quarter),]
        
        output$sheet <- DT::renderDataTable(tmp,options = list( targets = '_all'))
      }
      else{
        tmp <- dfs$by_area[which(dfs$by_area[['time_period']] == input$quarter),]
        
        output$sheet <- DT::renderDataTable(tmp,options = list( targets = '_all'))
        
        percentage_name <- names(tmp)[[match('total',names(tmp)) + 3]]
        nat_avg <- (sum(tmp[[which(names(tmp)=='total')+1]]) / sum(tmp$total)) * 100
        
        average_diff <- tmp %>%
          group_by(ods_code) %>%
          summarise(average_time = mean(.data[[percentage_name]])) %>%
          mutate (difference = average_time - nat_avg)
        
        p <- ggplot(data = average_diff, aes(x = ods_code , y =difference)) + 
          geom_col(aes(fill = difference)) +
          scale_fill_gradient2(low = "red",
                               high = "green",
                               midpoint = median(average_diff$difference))
        
        output$plot <- renderPlot(p)
      }
    }
  })
  
  # observeEvent(input$cancerType,{
  #   if (input$cancerType != ""){
  #     if (is.null(dfs$by_area)){
  #       tmp <- dfs$merged[which(dfs$merged[['time_period']] == input$quarter),]
  # 
  #       output$sheet <- DT::renderDataTable(tmp,options = list( targets = '_all'))
  #     }
  #     else{}
  # 
  #   }
  # })
}