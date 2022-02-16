



library(shiny)
library(shinythemes)


shinyUI(
  
  navbarPage(
    
    title = "New York Trips",
    position = "fixed-top",
    
    theme = shinytheme("slate"),
                 
    
    tabPanel("Map", 
            
             
             fluidRow(

               mapdeckOutput('map_gridmap', width = '100%', height=900),
               
               absolutePanel(
                 
                 wellPanel(
                   
                   h2('Taxis Pickup Locations In NewYork City'),
                   
                   HTML(markdownToHTML(fragment.only=TRUE, text=c(
                     
                     
                     "Este conjunto de datos incluye registros de viaje de todos 
                     los viajes realizados en taxis amarillos en la ciudad de Nueva York 
                     desde 2009. Los datos utilizados en los conjuntos de datos adjuntos 
                     fueron recopilados y proporcionados a la Comision de Taxis y 
                     Limusinas de la Ciudad de Nueva York (TLC) por proveedores de 
                     tecnologia autorizados por el Programa de Mejora de Pasajeros de 
                     Taxis (TPEP)."
                     
                     ))),
                     
                  dateInput(
                    
                    inputId = "fecha", 
                    label = h4("Date input"), 
                    value = "2014-01-01", 
                    min = "2009-01-01", 
                    max = "2015-06-30"
                  
                  ),

                  selectInput(

                    inputId = "vendor_id",
                    label =  h4("Vendor:"),
                    choices = c(
                      "Creative Mobile Technologies" = "CMT",
                      "VeriFone, Inc." = "VTS"
                      ),
                    selected = "CMT"

                  ),

                  actionButton(

                    inputId = "go", 
                    label = "Get Data")
                   
                   ),
                   
                 
                 top = 80, 
                 left = 25,
                 width = 300,
                 style = "opacity: 0.80"

                 ),
               
               
               absolutePanel(
                 
                 wellPanel(
                   
                   uiOutput('title'),
                   
                   highchartOutput("total_amount_box",width = "100%", height = "300px"),
                   
                   HTML(markdownToHTML(fragment.only=TRUE, text=c(
                     
                     "El monto total cobrado a los pasajeros. No incluye propinas en efectivo."
            
                   ))),
                   
                   
                   highchartOutput("rate_code_pie",width = "100%", height = "300px"),
                   
                   HTML(markdownToHTML(fragment.only=TRUE, text=c(
                     
                     "The final rate code in effect at the end of the trip. `1= Standard` 
                     rate 2=JFK 3=Newark 4=Nassau or Westchester 5=Negotiated fare 6=Group ride"
                     
                   )))

                 
                 ),
                 
                 top = 80, 
                 right = 25,
                 width = 300,
                 style = "opacity: 0.80"
                 
               ),
               
               
               
               absolutePanel(
                 
                 img(src='logoadolfo.png', align = "right"),
                 
                 top = 750, 
                 left = 25,
                 width = 375,
                 style = "opacity: 0.80"
                 
               ))

             ),
    
    
    tabPanel("Forecast", "contents"),
    tabPanel("Database", "contents")
    
    
    
    )
  
  )
