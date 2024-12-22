{2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.

a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice. X

b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos. x

c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?

Un orden mayor en el árbol B significa que cada nodo puede contener más claves y más hijos. 
Esto reduce la altura del árbol, lo que puede resultar en un acceso más rápido a los datos 
ya que se necesitan menos lecturas de nodos para encontrar una clave específica. x

d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.

Para buscar un alumno con el DNI 12345678 usando el índice:

Comenzar desde la raíz del árbol B.
Comparar el DNI 12345678 con las claves del nodo actual.
Si la clave coincide, utilizar el enlace correspondiente para obtener el registro del alumno en el archivo de datos.
Si la clave es menor que alguna de las claves del nodo, seguir el enlace al hijo correspondiente.
Si la clave es mayor que todas las claves del nodo, seguir el enlace al último hijo.
Repetir los pasos 2-5 hasta encontrar la clave o llegar a un nodo hoja sin encontrar la clave. x

e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?

Buscar un alumno por su número de legajo en un índice organizado por DNI no es eficiente, 
ya que el índice no está ordenado por legajo. Sería necesario recorrer todo el árbol B y 
luego buscar secuencialmente en el archivo de datos.
Para brindar acceso indizado al archivo de alumnos por número de legajo, 
se debería crear otro índice estructurado como un árbol B, pero ordenado por legajo.

f. Suponga que desea buscar los alumnas que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?
 
Buscar alumnos en un rango de DNIs usando un árbol B que solo provee acceso indizado por DNI implica:

Encontrar el nodo donde comienza el rango (40000000).
Recorrer el árbol B y obtener todos los DNIs dentro del rango hasta 45000000.
Acceder a los registros correspondientes en el archivo de datos.
El problema principal es que el árbol B no está optimizado para búsquedas por rangos, 
por lo que se pueden requerir múltiples lecturas de nodos y registros, 
especialmente si el rango abarca muchos nodos del árbol. x }

program ej2;
const
  M = 4;
type
	alumno = record
		nomyape: cadena;
		dni: string[8];
		legajo: string[7];
		ano_ingreso: integer;
	end;
	nodo = record
		cant_claves: integer;
		claves: array[1..M-1] of string[8];
		enlaces: array[1..M-1] of integer;
		hijos: array[1..M] of integer;
	end;
	archivoDatos = file of alumno;
	arbolB = file of nodo;
var
  archivo: archivoDatos;
  indice: arbolB;
begin
end.