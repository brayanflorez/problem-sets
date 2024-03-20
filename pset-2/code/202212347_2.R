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





