########################################
##                                    ##
##  TALLER DE R. ECON-1302            ##
##       PROBLEM SET 2                ##
##                                    ##
##  David Florez-202212347            ##
## Maria Contreras-202014039          ##
##Lina Ramos-201921142                ##
## R version 4.3.1 (2023-06-16 ucrt)  ##
##                                    ##
########################################

##set up
rm(list=ls())

##Instalar y llamar librerías
require(pacman)

p_load(tidyverse, rio, skimr, janitor, haven) 

#############################################
####1. IMPORTAR/EXPORTAR BASES DE DATOS

#1.1
location <- import("pset-2/input/Módulo de sitio o ubicación.dta") %>% clean_names()
identification <- import("pset-2/input/Módulo de identificación.dta") %>% clean_names()

#1.2
export(x=location, file="pset-2/output/location.rds")
export(x=identification, file="pset-2/output/identification.rds")

#############################################
#### 2. GENERAR VARIABLES

#2.1
identification <- mutate(identification, 
                         bussiness_type = case_when(grupos4=="01" ~ "Agricultura",
                                                    grupos4=="02" ~ "Industria manufacturera",
                                                    grupos4=="03" ~ "Comercio",
                                                    grupos4=="04" ~ "Servicios" ))

#2.2
identification <- mutate(identification, 
                         grupo_etario = case_when(p241>=0 &p241<18 ~ "Jovén",
                                                  p241>=18 &p241<35 ~ "Adulto joven",
                                                  p241>=35 &p241<50 ~ "Adulto",
                                                  p241>=50  ~ "Senior" ))

#2.3
location <- mutate(location, 
                   ambulante=ifelse(p3053==3 |p3053==4 | p3053==5,yes=1, no=0))



#Punto 3


#3.1 
identification_sub <- identification[, c("directorio", "secuencia_p", "secuencia_encuesta", "grupo_etario", "cod_depto", "f_exp")]


#3.2 
location_sub <- location[, c("directorio", "secuencia_p", "secuencia_encuesta", "ambulante","p3054", "p469", "cod_depto", "f_exp")]

#Punto 4

#4.1
combined_data <- data.frame(identification_sub, location_sub)

#Punto 5

#5.1

skim(combined_data)
summary(combined_data)
table(combined_data$grupo_etario)
table(combined_data$cod_depto)
hist(combined_data$ambulante)

#5.2
combined_data%>% group_by(cod_depto,grupo_etario)%>%summarise(prop_ambu=mean(ambulante,na.rm=T))%>%
  print(n = Inf)

combined_data%>% group_by(cod_depto,grupo_etario)%>%summarise(mean_local=mean(p3054,na.rm=T))%>%
  print(n = Inf)

##Planteamos nuestro analisis entre numero de locales y la proporcion de negocios ambulantes por departamento
##y edad. Encontramos que en el departemento del Choco los adultos jovenes (18-35) presentaron un mayor indice
##de poseer un mayor numero locales, en comparativa con el resto de departamentos. Si bien el adulto (35-50) del Choco tambien
##tiene una media significativa, es similar a la de otros departamentos como Huila. Ahora bien, la media en el
##Choco dentro de la poblacion de adultos jovenes tuvo una proporcion del 43% respecto a la cantidad de puestos ambulantes.
##Los datos sugieren entonces que la ventaja   compartiva de puestos del Choco no es una dato correlacionado con la formalidad del trabajo.
##Un ejemplo de esto es Bogota, siendo la ciudad con mayor porcentaje de puestos ambulantes dentro de los adultos jovenes con un 61% y con
## una cifra baja de numero de locales.Estas cifras  sugieren entonces que no hay un vinculo directo entre los departamentos que mas locales 
##registran, tanto formales como informales, y aquellos que reportan mayores porcentajes de negocios ambulantes.Creemos que intuitivamente deberia
##presentarse una correlacion pero la existencia de diferentes regulaciones,politicas regionales y diferencias de la densidad poblacional arrojan 
##dichos resultados.