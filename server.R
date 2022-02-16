



shinyServer(function(input, output, session) {
  
  
  #---------------------> DATA 


  rv_data <- reactiveValues(df = NULL)


  observeEvent(c(input$go),{

    sql = paste0(

      "

      SELECT 
      vendor_id,
      pickup_datetime,
      dropoff_datetime,
      pickup_longitude,	
      pickup_latitude,	
      dropoff_longitude,	
      dropoff_latitude,
      rate_code,
      passenger_count,	
      trip_distance,	
      payment_type,	
      total_amount
      FROM `nyc-tlc.yellow.trips` 
      WHERE DATE(pickup_datetime) = '",input$fecha,"'
      AND vendor_id = '",input$vendor_id,"'
      AND pickup_longitude <> 0
      AND pickup_latitude <> 0
      LIMIT 15000


      ")
    
    df<- dbGetQuery(con, sql)
    
    # ---- ** reactive ** 
    rv_data$df <- df

    
  })
  


  
  #------------------------> GRID MAP
  
  
  
  observeEvent(c(input$go),{
    
    df <- as.data.frame(rv_data$df)
    
    validate(
      need(nrow(df) != 0, 'No data to show')
    )
    
    mapdeck_update(
      map_id = 'map_gridmap'
    )%>%
      add_grid(
        data = df,
        lat = "pickup_latitude",
        lon = "pickup_longitude",
        cell_size = 100,
        elevation_scale = 5,
        auto_highlight = TRUE,
        layer_id = "grid_layer",
        colour_range = colourvalues::colour_values(1:6, palette = colourvalues::get_palette("viridis")[70:256,])
      )%>%
      mapdeck_view(
        location = c(df$pickup_longitude[1],df$pickup_latitude[1]), 
        zoom = 12, 
        pitch = 45)

    
  })
  

  
  output$map_gridmap <- renderMapdeck({
    
    df <- as.data.frame(rv_data$df)
    
    showModal(modalDialog(
      
      title = "Heatmap message",
      "Please use Go! button in 'Dynamic Report Filters' to refresh map."
      
    ))
    
    validate(
      need(nrow(df) != 0, 'No data to show')
    )
    
    mapdeck(
      token = key,
      style = 'mapbox://styles/mapbox/dark-v8', 
      location = c(df$pickup_longitude[1],df$pickup_latitude[1]),
      pitch = 45,
      zoom = 12,
      padding = 0
    )
    
    
  })
  
  
  #--------------------> TEXT
  
  
  
  output$title <- renderUI({
    
    df <- as.data.frame(rv_data$df)
    
    validate(
      need(nrow(df) != 0, 'No data to show')
    )
    
    
    h3(paste('Statistic: ',nrow(df), 'pickups'))
 
    
  })
  
  

  
  #----------------------> BOXPLOT 
  
  
  output$total_amount_box <- renderHighchart({


    df <- as.data.frame(rv_data$df)
    
    validate(
      need(nrow(df) != 0, 'No data to show')
    )

    df$var <- 'TotalAmount'
    df = df[df$total_amount >= quantile(df$total_amount, 0.05) & df$total_amount <= quantile(df$total_amount, 0.95),]
    
    validate(
      need(nrow(df) != 0, 'No data to show')
    )

    hcboxplot(x = df$total_amount, var = df$var )%>% 
      hc_title(text = paste("TotalAmount"), align = "left", style = list(color = "#ffffff")) %>%
      hc_subtitle(text = "Source: database",align = "left",style = list(color = "#ffffff")) %>%
      hc_credits(enabled = TRUE,text = "adolfoi") %>% 
      hc_legend(align = "left", verticalAlign = "top",
                layout = "vertical", x = 0, y = 100) %>%
      hc_exporting(enabled = TRUE)%>%
      hc_add_theme(hc_theme_darkunica())
    
    
    
    
  })
  
  
  
  #--------------------> PIE CHART 
  
  
  
  output$rate_code_pie <- renderHighchart({
    
    df <- as.data.frame(rv_data$df)
    
    validate(
      need(nrow(df) != 0, 'No data to show')
    )
    
    
    df <- df %>% 
      select(rate_code) %>%
      group_by(rate_code) %>%
      summarise(n = n()) %>%
      arrange(desc(n))
    
    
    hchart(df, type = "pie", hcaes(x = rate_code, y = n))%>%
      hc_tooltip(
        useHTML = TRUE,
        pointFormat = paste0("<span style=\"color:{series.color};\">{series.options.icon}</span>",
                             "<b>
                             <i class='fa fa-users'></i> {point.y}
                             <br>
                             <b>{point.percentage:.1f}% share</b>
                             </b>")
      )%>% 
      hc_title(text = paste("Rate Code"), align = "left", style = list(color = "#ffffff")) %>%
      hc_subtitle(text = "Source: database",align = "left",style = list(color = "#ffffff")) %>%
      hc_credits(enabled = TRUE,text = "adolfoi") %>% 
      hc_exporting(enabled = TRUE)%>%
      hc_add_theme(hc_theme_darkunica())
    
    
  })
  
  

 

  

})
