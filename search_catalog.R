library(httr)
library(jsonlite)

client_id     <- '3849'              # "MENDELEY_CLIENT_ID"
client_secret <- '0Oa7TAnpEYw04m1w'  # "MENDELEY_CLIENT_SECRET"
endpoint <- 'https://api.mendeley.com'

access_token_rsp <- POST(endpoint,
                         path = 'oauth/token',
                         authenticate(client_id, client_secret),
                         add_headers(
                           'Content-Type' = 'application/x-www-form-urlencoded'
                         ),
                         body = 'grant_type=client_credentials&scope=all'
)

access_token <- content(access_token_rsp)$access_token 


headers <- add_headers(
                       'Authorization' = paste('Bearer', access_token),
                       'Content-Type' = 'application/vnd.mendeley-document.1+json'
                      )
my_query <- 'gis'

rsp <- GET(endpoint,
           path = 'search/catalog', 
           query = list(query = my_query, limit=100), 
           headers
           )

headers <- rsp$headers

docs <- fromJSON(rawToChar(content(rsp)))

