{1. Considere que desea almacenar en un archivo la información correspondiente a los
alumnos de la Facultad de Informática de la UNLP. 

De los mismos deberá guardarse
nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
como un árbol B de orden M. x

a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de
alumnos como un árbol B de orden M. x

b. Suponga que la estructura de datos que representa una persona (registro de
persona) ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512
bytes y que los números enteros ocupan 4 bytes, ¿cuántos registros de persona
entrarían en un nodo del árbol B? --> entran OCHO 
¿Cuál sería el orden del árbol B en este caso (el
valor de M)? --> 9  X

Para resolver este inciso, puede utilizar la fórmula N = (M-1) * A + M *
B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro
(en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa
el campo referido a la cantidad de claves. El objetivo es reemplazar estas
variables con los valores dados y obtener el valor de M (M debe ser un número
entero, ignorar la parte decimal). X

c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la
información de los alumnos como un árbol B?
El valor de M depende del tamaño del registro de datos. 
Si los registros de los alumnos contienen más información y, por lo tanto, ocupan más espacio, 
el valor de M disminuirá porque menos registros caben en un nodo de tamaño fijo. 
Si los registros contienen menos información, M aumentará. x

d. ¿Qué dato seleccionaría como clave de identificación para organizar los
elementos (alumnos) en el árbol B? ¿Hay más de una opción? LEGAJO (otra opcion dni) x

e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento
especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para
encontrar un alumno por su clave de identificación en el peor y en el mejor de
los casos? ¿Cuáles serían estos casos?
Para buscar un alumno en un árbol B por la clave de identificación (Legajo o DNI), 
el proceso es similar al de cualquier búsqueda en un árbol B:

Comenzar desde la raíz.
Comparar la clave de búsqueda con las claves en el nodo actual.
Si la clave coincide, devolver el registro.
Si la clave es menor, ir al hijo izquierdo; si es mayor, ir al hijo derecho.
Repetir hasta encontrar la clave o llegar a un nodo hoja sin encontrar la clave.
En el mejor caso, la clave se encuentra en la raíz, por lo que solo se necesita una lectura de nodo.

En el peor caso, la clave está en el nivel más profundo del árbol. En un árbol B de orden M, 
el número máximo de nodos leídos es proporcional a la altura del árbol, que es 
𝑂(log⁡𝑀𝑁) donde N es el número total de registros. X

f. ¿Qué ocurre si desea buscar un alumno por un criterio diferente? ¿Cuántas
lecturas serían necesarias en el peor de los casos?
Si se desea buscar por un criterio diferente, como el NombreApellido, el árbol B no es eficiente, 
ya que no está ordenado por este criterio. En el peor de los casos, habría que realizar una búsqueda exhaustiva 
a través de todos los nodos, lo que implica leer todos los nodos del árbol. En el peor caso, esto significa realizar 
𝑁 lecturas, donde 𝑁 es el número total de nodos del árbol. X}

program ej1;
const
  M = 8;
type
	alumno = record
		nomyape: cadena;
		dni: integer;
		legajo: string[8];
		ano_ingreso: integer;
	end;
	nodo = record
		cant_datos: integer;
		datos: array[1..M-1] of alumno;
		hijos: array[1..M] of integer;
	end;
	arbolB = file of nodo;
var
  archivo: arbolB;
begin
end.