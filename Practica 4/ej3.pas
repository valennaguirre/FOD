{3. Los árboles B+ representan una mejora sobre los árboles B dado que conservan la
propiedad de acceso indexado a los registros del archivo de datos por alguna clave,
pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,
considere que por un lado se tiene el archivo que contiene la información de los
alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado
se tiene un índice al archivo de datos, pero en este caso el índice se estructura como
un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los
siguientes incisos:

a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
encuentran en los nodos internos y que elementos se encuentran en los nodos
hojas?

Nodos internos:
Contienen solo las claves que actúan como separadores para guiar la búsqueda
(DNI de alumnos) y punteros a nodos hijos.

Nodos hojas: Contienen todas las claves y punteros a los registros de datos. x

b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por
qué?

La característica distintiva de los nodos hojas en un árbol B+ es que están enlazados secuencialmente entre sí, formando una lista enlazada.
Permiten un recorrido secuencial eficiente de los registros de alumnos, 
sin necesidad de redescender por el árbol. 
Esto es especialmente útil para rangos de DNI o consultas que impliquen iterar 
sobre un conjunto de alumnos consecutivos. x

c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño.

d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
específico haciendo uso de la estructura auxiliar (índice) que se organiza como
un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
estructurado como un árbol B?

e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
búsquedas en un árbol B?}

const
  M = 4;

type
  cadena = string[50];

  // Estructura de datos para un alumno
  TAlumno = record
    NomYAp: cadena;
    DNI: string[8];
    Legajo: string[7];
    AnoIngreso: integer;
  end;

  // Estructura de datos para un nodo interno del árbol B+
  TNodoInternoBPlus = record
    CantClaves: integer;
    Claves: array[1..M-1] of string[8];
    Hijos: array[1..M] of integer;
  end;

  // Estructura de datos para un nodo hoja del árbol B+
  TNodoHojaBPlus = record
    CantClaves: integer;
    Claves: array[1..M-1] of string[8];
    Enlaces: array[1..M-1] of integer; // Enlaces a los registros en el archivo de datos
    SiguienteHoja: integer; // Enlace al siguiente nodo hoja
  end;

  // Archivos
  ArchivoDatos = file of TAlumno;
  ArbolBPlusInternos = file of TNodoInternoBPlus;
  ArbolBPlusHojas = file of TNodoHojaBPlus;

var
  Archivo: ArchivoDatos;
  IndiceInternos: ArbolBPlusInternos;
  IndiceHojas: ArbolBPlusHojas;