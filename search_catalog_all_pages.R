library(httr)
library(jsonlite)
library(stringr)

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
lim      <- 100

rsp <- GET(endpoint,
           path = 'search/catalog', 
           query = list(query = my_query, limit = lim), 
           headers
           )

# Общее число документов
all <- as.numeric( rsp$headers$`mendeley-count` ) 
# Сколько документов обработано
i <- lim
# Документы на странице
docs <- fromJSON(rawToChar(content(rsp)), simplifyDataFrame = F)

repeat {
  cat("Proceed", i, "from", all, "...\n")
  
  link <- rsp$headers$link
  rsp <- GET(str_match(link, '<(.+)>')[[2]], headers)
  tdocs <- fromJSON(rawToChar(content(rsp)), simplifyDataFrame = F)
  docs <- append(docs, tdocs)
  if (!str_detect(link, 'next')) break
  i <- i + lim
}

# Сохранение результатов
save(docs, file = "readership.RData")

