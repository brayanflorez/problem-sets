########################################
##                                    ##
##  TALLER DE R. ECON-1302            ##
##       PROBLEM SET 2                ##
##                                    ##
##  David Florez-202212347            ##
##  Maria Contreras-202014039         ##
##  Lina Ramos-201921142              ##
## R version 4.3.1 (2023-06-16 ucrt)  ##
##                                    ##
########################################

##set up
rm(list=ls())

##Instalar y llamar librerías
require(pacman)

p_load(tidyverse, rio, skimr, janitor, haven, data.table, sf, rvest, ggplot2, viridis) 


#############################################
####1. EXTRAER INFORMACION DE INTERNET


##1.1
my_url = "https://eduard-martinez.github.io/pset-4.html"
browseURL(my_url) ## Ir a la página

my_html = read_html(my_url) ## leer el html de la página
class(my_html) ## ver la clase del objeto
View(my_html)

# Extraer todas las URLs contenidas en la página
url_full <- my_html %>% html_nodes("a") %>% html_attr("href")


## 1.2 Filtrar URL

# Mantener únicamente las URLs que contengan la palabra "propiedad"
url_subset <- url_full[str_detect(url_full, "propiedad")]

url_subset #Mostrar el resultado


# 1.3 Iterar sobre url_subset para extraer las tablas
lista_tablas <- lapply(url_subset, function(u) {
  page <- read_html(u)
  table <- page %>% html_node("table") %>% html_table()
  return(table)
})

# 1.4 Preparar la información
db_house <- rbindlist(lista_tablas, fill = TRUE)

# Mostrar el resultado
print(db_house)

#############################################
####2. MANIPULAR LA INFORMACIÓN GIS

# Convertir `db_house` en SimpleFeature 
sf_house <- st_as_sf(db_house, coords = c("lon", "lat"), crs = 4326)
print(sf_house)

##2.2

##Crear el mapa

map <- ggplot(data = sf_house) +
  geom_sf(aes(fill = price)) +  
  scale_fill_viridis(name = "Valor de la vivienda", option = "viridis") +
  theme_minimal() +
  labs(title = "Mapa de Valores de Vivienda")

##Corroborar
print(map)
ggsave("mapa_valores_vivienda.pdf", plot = map, device = "pdf")


##Analisis 
##1
mean_mpg <- mean(db_house$price)
print(mean_mpg)
sd_mpg <- sd(db_house$price)
print(sd_mpg)
##2
mean_db <- mean(db_house$surface_total)
print(mean_db)
sd_db<- sd(db_house$surface_total)
print(sd_db)
##3
hist(db_house$price, 
     main = "Histograma precio",
     xlab = "Price",
     col = "lightblue", 
     border = "black")
##conclusion de las estadisticas
##En base a las estadísticas podemos observar que el precio de
##las viviendas es considerablemente alto, pues la media se encuentra en  $1,399,712,145.
##No obstante, esta cifra también sugiere que pueden existir valores atípicos, que rondan 
##en precios extremadamente altos, que podrían influir en el resultado. Por otro lado,
##la desviación estándar nos presenta una variabilidad en los precios, es decir,
##estos oscilan en un rango amplio entre diferentes viviendas. Dicha observación 
##es consistente con la disparidad económica entre los estudiantes.
