library(httr)
library(jsonlite)

client_id     <- 'MENDELEY_CLIENT_ID'
client_secret <- 'MENDELEY_CLIENT_SECRET'

access_token_rsp <- POST('https://api.mendeley.com/oauth/token',
                         authenticate(client_id, client_secret),
                         add_headers(
                           'Content-Type' = 'application/x-www-form-urlencoded'
                         ),
                         body = 'grant_type=client_credentials&scope=all'
                         )

rsp_content <- content(access_token_rsp)

access_token <- rsp_content$access_token 
