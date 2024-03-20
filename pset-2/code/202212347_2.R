########################################
##                                    ##
##  TALLER DE R. ECON-1302            ##
##       PROBLEM SET 2                ##
##                                    ##
##  David Florez-202212347            ##
## Maria Contreras-202014039          ##
##                                    ##
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





