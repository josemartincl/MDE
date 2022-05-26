
#https://youtu.be/ULQtfXh5nHQ
#  https://dbmstools.com/tools/valentina-studio#database-design-tools
  
#Instalar paquetes
#install.packages("RMySQL")
#install.packages("DBI")
#install.packages("dplyr")
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("broom")

library("DBI")
library("RMySQL")
library("dplyr")
library("ggplot2")
library("readr")

database <- dbConnect(MySQL(), user="root" , host= "localhost", password = "", dbname = "mysql")
StrSQL = "SELECT * FROM mysql.mdl_user;";


#Datos <- (dbGetQuery(database, statement = StrSQL ))
#View(Datos)

#install.packages("modes")
#library("modes")

#instalar librerias de R en weka
#install.packages("rJava")
#library("rJava")
#install.packages("RWeka")
#library("RWeka")

#mdlUser <- dbGetQuery(database, statement = "SELECT username, firstname, lastname, department, city FROM mysql.mdl_user;")
#View(mdlUser)

#mdlassign <- dbGetQuery(database, statement = "SELECT * FROM mysql.mdl_assign;")
#mdlassign_grades <- dbGetQuery(database, statement = "SELECT * FROM mdl_assign_grades;")

#mdl_assign <- consulta(mdl_assign,"")
#mdl_assign_grades <- consulta(mdl_assign_grades,"")
#mdl_assign_plugin_config <- consulta(mdl_assign_plugin_config,"")
#mdl_assign_submission <- consulta(mdl_assign_submission,"")
#mdl_assign_user_flags <- consulta(mdl_assign_user_flags,"")
#mdl_assignfeedback_comments <- consulta(mdl_assignfeedback_comments,"")
#mdl_assignsubmission_file <- consulta(mdl_assignsubmission_file,"")
#mdl_files <- consulta(mdl_files,"")

#Hacer funcion para consultar y comparar las dos bases de datos
script <- function(verEn, table, StrSQL){
  if(StrSQL == ""){
    StrSQL <- paste("SELECT * FROM mysql.", table , ";", sep = "")  
  }

  if(verEn == ""){
    return (dbGetQuery(database, statement = StrSQL ))
  }
    
  if(verEn == "p"){
    print (dbGetQuery(database, statement = StrSQL ))
  }
  
  if(verEn == "v"){
    Datos <-  dbGetQuery(database, statement = StrSQL )
    View (Datos)
  }

}

# Estadisticas descriptiva
par(
  mfrow=c(1,3)
)

#par(  mfrow=c(2,3),  mar=c(1,1,1,5,1),  oma=c(1,1,1,1) )

#script("p","mdl_assign","")
#script("p","mdl_assign_grades","")
#script("p","mdl_assign_plugin_config","")
#script("p","mdl_assign_submission","")
#script("p","mdl_assign_user_flags","")
#script("p","mdl_assignfeedback_comments","")
#script("p","mdl_assignsubmission_file","")
#script("p","mdl_files","")


#mdl_course
#mdl_course_format_options    
#mdl_course_modules  
#mdl_course_sections

#mdl_forum    
#mdl_forum_discussion_subs    
#mdl_forum_discussions  
#mdl_forum_posts

#StrSQL <- "SELECT * FROM mysql.mdl_assign WHERE course = 4;"
#Datos <- script("v","", StrSQL)

#StrSQL <- "SELECT * FROM mysql.mdl_assign WHERE course = 5;"
#Datos <- script("v","", StrSQL)

#StrSQL <- "SELECT * FROM mysql.mdl_assign;"
#Datos <- script("v","", StrSQL)

#StrSQL <- "SELECT * FROM mdl_course WHERE course = 5;"
#Datos <- script("v","", StrSQL)


curso <- "(4)"
StrSQL <- paste("SELECT mdl_user.id AS idalumno, concat(mdl_user.firstname, ' ',mdl_user.lastname) AS alumno,
    mdl_course.fullname AS curso, 
    /*mdl_course_categories.name AS categoria, */
    mdl_course.id,
    CASE 
    WHEN mdl_grade_items.itemtype = 'course' 
        THEN concat('Total assignatura: ')
    WHEN mdl_grade_items.itemtype ='category' 
        THEN mdl_grade_categories.fullname 
    ELSE mdl_grade_items.itemname
    END AS elementocalificador, 
    mdl_grade_grades.itemid, 
    ROUND(mdl_grade_grades.finalgrade,2) 
        AS nota, 
    mdl_scale.scale,
    if(ROUND(mdl_grade_grades.finalgrade) < 2,
     SUBSTRING_INDEX(mdl_scale.scale,',',
    ROUND(mdl_grade_grades.finalgrade)),
    substring(SUBSTRING_INDEX(mdl_scale.scale,',',
    ROUND(mdl_grade_grades.finalgrade)),
    ((length(SUBSTRING_INDEX(mdl_scale.scale,',',
    ROUND(mdl_grade_grades.finalgrade)))-
    length(SUBSTRING_INDEX(mdl_scale.scale,',',
    ROUND(mdl_grade_grades.finalgrade)-1))-1)*-1))) 
        AS texto,
    DATE_ADD('1970-01-01', 
    INTERVAL mdl_grade_items.timemodified SECOND) 
        AS fechanota,
    mdl_grade_items.itemtype as tipoelemento, 
    mdl_grade_items.sortorder
    /*mdl_grade_items.hidden*/
FROM mdl_course
    JOIN mdl_context ON 
        mdl_course.id = mdl_context.instanceid
    JOIN mdl_role_assignments ON 
        mdl_role_assignments.contextid = mdl_context.id
    JOIN mdl_user ON 
        mdl_user.id = mdl_role_assignments.userid
    JOIN mdl_grade_grades ON 
        mdl_grade_grades.userid = mdl_user.id
    JOIN mdl_grade_items ON 
        mdl_grade_items.id = mdl_grade_grades.itemid
    left join mdl_grade_categories ON 
        mdl_grade_categories.id = mdl_grade_items.iteminstance
    JOIN mdl_course_categories ON 
        mdl_course_categories.id = mdl_course.category
    left join mdl_scale ON 
        mdl_scale.id = mdl_grade_grades.rawscaleid
WHERE mdl_grade_items.courseid = mdl_course.id 
        AND mdl_grade_grades.finalgrade is not null 
        AND mdl_grade_items.hidden=0
        /*AND mdl_grade_items.itemtype <> 'mod'*/
        AND mdl_grade_items.itemtype <> 'course'
        AND mdl_course.id IN ", curso , " 
        /*AND mdl_course.id IN (4,5) */
        /*AND mdl_grade_grades.itemid = 3*/
        ORDER BY curso, sortorder;")

Datos <- script("","", StrSQL)
View(Datos)

#Dato <- StrSQL


#alumno <- c(Datos$alumno)
#elementocalificador <- Datos$elementocalificador
#nota <- as.numeric(Datos$nota)

length(Datos$nota)
mean(Datos$nota)
median(Datos$nota)
#modes(Datos$nota)

#plot(Datos$nota)
#hist(nota)




plot(x = banco$education, y = banco$age, main = "Edad por nivel educativo", 
     xlab = "Nivel educativo", ylab = "Edad", 
     col = c("orange3", "yellow3", "green3", "blue"))



boxplot(Datos$nota, horizontal = TRUE)
plot(Datos$nota, col = 3, las = 1, main = paste('Dispersion nota del curso', curso) ,xlab = '') 
hist(Datos$nota, col = 3 ,las = 1 ,main = paste('Histograma nota del curso', curso) ,xlab = '')


#View(elementocalificador)
#M <- (cbind(alumno, nota)) #sirve para separar datos de una tabla
#View(M)


#Ruido en los datos
#tidyr
# https://rpubs.com/paraneda/tidyverse#:~:text=Tidyverse%20es%20una%20colecci%C3%B3n%20de,la%20generaci%C3%B3n%20de%20trabajos%20reproducibles.
#Carrera, periodo y cantidad de estudiantes titulados

#install.packages("tidyr")
#install.packages("tidyverse")
#install.packages('gapminder')
#install.packages("lifecycle")
#library(tidyverse)
#library(dplyr, quietly = TRUE)
#library(gapminder)



#Preprocesamiento
#Eliminar los valores con NA, para evitar los valore faltantes
#mean(Datos$nota , na.rm = TRUE)
#Datos = Datos[complete.cases(Datos$nota), ]
#mean(Datos$nota , na.rm = TRUE)
#Datos

#Eliminar los valores infinitos
#Datos = Datos[is.finite(Datos$nota), ]
#Datos

#Outliers
boxplot.stats(Datos$nota)
boxplot(Datos$nota)



  
#Histograma y forma de la distribución normal
#p valor y nivel de sgnificación

plot(Datos)

Datos1 <- Datos$nota
Datos2 <- Datos$nota

#Datos1 %>% filter(Datos$nota, curso != "Seguridad en TI (91428 - Silvia Ramos Cabral)")
#Datos2 <- Datos2 > filter(id != 4)

View(Datos1)
View(Datos2)

#Datos1 <- str(gapminder %>% group_by(continent))
Datos1 <- str(Datos$nota %>% group_by(id))


#Datos1 <- select(gapminder,year,country,gdpPercap)
View(Datos)
DatosNotas <- select(Datos,id,nota)
View(DatosNotas)

Datos1 %>% filter(DatosNotas, id == 2)
Datos2 %>% filter(DatosNotas, id == 4)

year_country_gdp_euro <- gapminder %>%
  filter(continent=="Europe") %>%
  select(year,country,gdpPercap)

Datos1 <- DatosNotas %>% filter(id==2) 
Datos2 <- DatosNotas %>% filter(id==4) 
View(Datos1)
View(Datos2)

#Gráfico linea de regresión sobre los datos
ggplot(Datos1, aes(x=id, y=nota) ) + 
  geom_point(color='#2908B9', size = 4) +
  geom_smooth(method = lm, se = FALSE,  color = '#2C3E50' ) 


#https://swcarpentry.github.io/r-novice-gapminder-es/13-dplyr/

#Coeficiente de correlación de Spearmea


par(  mfrow=c(2,3))
#plot(Datos1$nota)
#plot(Datos2$nota)
plot(Datos1$nota, col = 3, las = 1, main = paste('Dispersion nota del curso', curso) ,xlab = '') 
plot(Datos2$nota, col = 4, las = 1, main = paste('Dispersion nota del curso', curso) ,xlab = '') 
boxplot(Datos1$nota, col = 3, horizontal = TRUE)
boxplot(Datos2$nota, col = 4, horizontal = TRUE)
hist(Datos1$nota, col = 3 ,las = 1 ,main = paste('Histograma nota del curso', curso) ,xlab = '')
hist(Datos2$nota, col = 4 ,las = 1 ,main = paste('Histograma nota del curso', curso) ,xlab = '')



#1 Revisar por actividad
# 2, 143, 
#itemid = 2, 143,47,188,83,224,84, 225, 85, 226,86,227,90,231, 91, 232
DatosAct <- select(Datos,itemid,nota)
View(DatosAct)
Datos1 <- DatosAct %>% filter(itemid==2) 



plot(Datos1$nota, col = 3, las = 1, main = paste('Dispersion nota del curso', curso) ,xlab = '') 
plot(Datos2$nota, col = 4, las = 1, main = paste('Dispersion nota del curso', curso) ,xlab = '') 
boxplot(Datos1$nota, col = 3, horizontal = TRUE)
boxplot(Datos2$nota, col = 4, horizontal = TRUE)
hist(Datos1$nota, col = 3 ,las = 1 ,main = paste('Histograma nota del curso', curso) ,xlab = '')
hist(Datos2$nota, col = 4 ,las = 1 ,main = paste('Histograma nota del curso', curso) ,xlab = '')



gh <- function(Id){
  #https://www.youtube.com/watch?v=EA8WLDoCB50
  par(  mfrow=c(2,3))
  DatosAct <- select(Datos,itemid,nota)
  #View(DatosAct)
  DatosX <- DatosAct %>% filter(itemid == Id) 
  plot(DatosX$nota, col = 4, las = 1, main = paste('Dispersion ', Id) ,xlab = '') 
  boxplot(DatosX$nota, col = 4, horizontal = TRUE)
  hist(DatosX$nota, col = 4 ,las = 1 ,main = paste('Histograma ', Id) ,xlab = '')
  #View(DatosX)
}


gh(2)
gh(143)
gh(47)

lista <- c(2,143,47,188,83,224,84,225, 85, 226,86,227,90,231, 91, 232)
for(i in lista){
  gh(i)
}

par(  mfrow=c(1,1))
Barra <- select(Datos,itemid,idalumno,nota) %>% filter(itemid==2)
#Barra <- select(Datos,itemid,nota)
#View(Datos)
#View(Barra)
plot(x = Barra$idalumno, y = Barra$nota)


datos <- read.csv(file = 'nombre_de_archivo.csv')

