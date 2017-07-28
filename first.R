library(httr)
library(jsonlite)

access_token <- "СТРОКА_ACCESS_TOKEN"

endpoint <- "https://api.mendeley.com"

response <- GET(endpoint, 
                path = "catalog", 
                query = list(doi = "10.1103/PhysRevA.20.1521"), 
                add_headers(
                  'Authorization' = paste("Bearer", access_token),
                  'Content-Type' = 'application/vnd.mendeley-document.1+json'
                  )
                )

docs <- fromJSON(content(response, as = "text", encoding = "UTF-8"))

docs$authors
