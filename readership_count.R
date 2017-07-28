load("readership.RData") # загрузка docs

## Какая публикация по ГИС самая популярная?

# Получаем список просмотров статей пользователями Mendeley
count <- function(x) {
  list(id=x$id, title=x$title, reader_count=x$reader_count)
}
lcount <-lapply(docs, count) 

# Преобразуем список в таблицу
dfcount <- do.call(rbind.data.frame, lcount)
# и упорядочиваем ее по убыванию (самые популярные статьи - вверху)
dfcount <- dfcount[order(dfcount$reader_count,decreasing = T),]

## Сколько в среднем читают публикации по ГИС?

# всего публикаций
length(docs)
# общее число прочтений
sum(dfcount$reader_count)
# среднее число прочтений публикации по ГИС (на английском)
round(sum(dfcount$reader_count)/length(docs))
