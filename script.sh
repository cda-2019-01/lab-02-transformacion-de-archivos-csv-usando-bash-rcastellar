# Transformación de archivos CSV usando Bash

#Agregar Columna con Estacion
sed 's/;/;Estacion1;/' estaciones/estacion1.csv > estaciones/station.1-1.csv
sed 's/;/;Estacion2;/' estaciones/estacion2.csv > estaciones/station.2-1.csv
sed 's/;/;Estacion3;/' estaciones/estacion3.csv > estaciones/station.3-1.csv
sed 's/;/;Estacion4;/' estaciones/estacion4.csv > estaciones/station.4-1.csv

# Unir los archivos
csvstack estaciones/station.1-1.csv estaciones/station.2-1.csv estaciones/station.3-1.csv estaciones/station.4-1.csv > out.1

# Separar por ';' por ',' y decimales  por '.'
sed 's/,/./g' out.1 > out.2
sed 's/;/,/g' out.2 > out.3
sed 's/FECHA,Estacion1/FECHA,ESTACION/' out.3 > out.4

# Separar la fecha en MES y AÑO
sed 's/\([0-9]*\)\/\([0-9]*\)\/\([0-9]*\)/\1\/\2\/\3,\2,\3/' out.4 > out.5
sed 's/FECHA/FECHA,MES,AÑO/' out.5 > out.6

#Separar la Hora
sed 's/\([0-9]*\):\([0-9]*\):\([0-9]*\)/\1:\2\:\3,\1/' out.6 > out.7
sed 's/HHMMSS/HHMMSS,HORA/' out.7 > final.csv

#Consulta velocidad-por-mes.csv
csvsql --query 'select ESTACION,MES,avg(VEL) from final group by ESTACION, MES'  final.csv > velocidad-por-mes.csv

#Consulta velocidad-por-ano.csv
csvsql --query 'select ESTACION,AÑO,avg(VEL) from final group by ESTACION, AÑO' final.csv > velocidad-por-ano.csv

#Consulta velocidad-por-hora.csv
csvsql --query 'select ESTACION,HORA,avg(VEL) from final group by ESTACION, HORA' final.csv > velocidad-por-hora.csv

rm out.*
rm final.csv
rm estaciones/station.*