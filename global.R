

library(DBI)
library(odbc)
library(mapdeck)
library(markdown)
library(highcharter)
library(dplyr)





key = "pk.eyJ1IjoiYW5kcmVzcjQyNDI0MiIsImEiOiJjanIxZzg3dTUwaDZ4M3pxbDN6djR4eTkzIn0.KCTZo9seeEhCLbSZO3_pFg"


con <- DBI::dbConnect(odbc::odbc(),
                      Driver         = "Simba ODBC Driver for Google BigQuery",
                      Catalog        = "elegant-plating-330906",
                      Email          = "adolfoi@elegant-plating-330906.iam.gserviceaccount.com",
                      KeyFilePath    = "C:/Users/andre/Documents/SHINYAPP IO/nyc_trip/elegant-plating-330906-df8bcd99f49b.json",
                      OAuthMechanism = 0)


sql = "

SELECT 
EXTRACT(YEAR FROM pickup_datetime) AS ANIO,
EXTRACT(MONTH FROM pickup_datetime) AS MES,
COUNT(vendor_id) AS N
FROM `nyc-tlc.yellow.trips` 
WHERE total_amount > 0
GROUP BY 
EXTRACT(YEAR FROM pickup_datetime),
EXTRACT(MONTH FROM pickup_datetime) 

"

df_ts <- dbGetQuery(con, sql)
