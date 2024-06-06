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

p_load(tidyverse, rio, skimr, janitor, haven, data.table, sf, rvest) 


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







