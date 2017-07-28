library(httr)
library(jsonlite)

client_id     <- '3849'              # "MENDELEY_CLIENT_ID"
client_secret <- '0Oa7TAnpEYw04m1w'  # "MENDELEY_CLIENT_SECRET"
endpoint <- "https://api.mendeley.com"

access_token_rsp <- POST(endpoint,
                         path = 'oauth/token',
                         authenticate(client_id, client_secret),
                         add_headers(
                           'Content-Type' = 'application/x-www-form-urlencoded'
                         ),
                         body = 'grant_type=client_credentials&scope=all'
)

rsp_content <- content(access_token_rsp)

access_token <- rsp_content$access_token 


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
