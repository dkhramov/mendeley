load("readership.RData") # загрузка docs

## В каких странах больше всего читают статьи по ГИС?

# Получаем список просмотров статей пользователями разных стран
country <- function(x) {
  if(!is.null(x$reader_count_by_country)) {
    list(id=x$id, title=x$title, by_country=x$reader_count_by_country)
  }
}

lcountry <-lapply(docs, country) 
#Удаляем из него нулевые элементы
non_nulls <- which(!sapply(lcountry, is.null))
lcountry <- lcountry[non_nulls]

by_country <- function(x) {
  unlist(x$by_country)
}

lby_country <-sapply(lcountry, by_country)
# Преобразуем список в именованный вектор
vby_country <- unlist(lby_country)
# Преобразуем вектор в таблицу "Название страны-число просмотров"
df_by_country <- data.frame(country=attr(vby_country,"names"),views=vby_country)
# Складываем результаты просмотров по странам
cdf <- aggregate(. ~ country, data=df_by_country, FUN=sum)

## Построим карту стран, пользователи из которых читают статьи по ГИС

library(rworldmap)

# Присоединяем данные пользователя ко внутреннему представлению карты
spdf <- joinCountryData2Map(cdf, joinCode="NAME", 
                            nameJoinColumn="country")

# Создаем графическое устройство
mapDevice()

# Отображаем данные на карте
mapParams <- mapCountryData(spdf, nameColumnToPlot="views", 
                            catMethod="fixedWidth", 
                            mapTitle = "Map")

do.call( addMapLegend, c(mapParams, legendLabels="all") )

# Выведем атрибуты страны (название/число просмотров) 
# по щелчку по карте
identifyCountries(spdf, nameCountryColumn="NAME", 
                  nameColumnToPlot="views")
