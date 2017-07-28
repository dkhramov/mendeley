library(httr)
library(jsonlite)

client_id     <- "3849"              # "MENDELEY_CLIENT_ID"
client_secret <- "0Oa7TAnpEYw04m1w"  # "MENDELEY_CLIENT_SECRET"
endpoint <- "https://api.mendeley.com"

access_token_rsp <- POST(endpoint,
                         path = 'oauth/token',
                         authenticate(client_id, client_secret),
                         add_headers(
                           'Content-Type' = 'application/x-www-form-urlencoded'
                         ),
                         body = 'grant_type=client_credentials&scope=all'
)
access_token <- content(access_token_rsp)$access_token 

# Заголовки запроса к API
headers <- add_headers(
  'Authorization' = paste("Bearer", access_token),
  'Content-Type' = 'application/vnd.mendeley-document.1+json'
)

queries <- c("gis", "英语", "гис")

# Запросы на разных языках
df <- data.frame(lang=c("en", "cn", "ru"), 
                 query=queries, 
                 num.of.docs=rep(0,length(queries)))

# Определение числа документов на каждом из языков
for (i in 1:nrow(df)) {
  rsp <- GET(endpoint,
             path = "search/catalog",
             query = list(query = queries[i]),
             headers)
  count <- headers(rsp)$`mendeley-count`
  if ( !is.null(count) ) {
    df$num.of.docs[[i]] <- as.integer(count)
  }
}

# Вычисление процента от общего числа документов
percent <- round( df$num.of.docs/sum(df$num.of.docs)*100, digits=2 )
# Вывод результатов в виде таблицы
cbind(df[,-2],percent)
