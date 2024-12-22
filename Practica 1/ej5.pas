{ 5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”. }

program ej5;
type
	cadena = string[10];
	celular = record
		codigo: integer;		
		minimo: integer;
		stock: integer;
		precio: real;
		nombre: cadena;
		descripcion: cadena;
		marca: cadena;
	end;
	archivo = file of celular;
//procedures
{a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.}
procedure CrearArchivo(var a: archivo; var nombre: cadena; var t: text);
var
	c: celular;
begin
	assign(t, 'celulares.txt');
	assign(a, nombre);
	rewrite(a);
	reset(t);
	while (not eof(t)) do begin
	  readln(t, c.codigo, c.precio, c.marca);
      readln(t, c.stock, c.minimo, c.descripcion);
      readln(t, c.nombre);
	  writeln(c.descripcion);
	  write(a, c);
	end;
	writeln('Archivo "' ,nombre, '" cargado.');
	close(a);
	close(t);
end;

{b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.}
procedure ListarMenoresAlMinimo(var a: archivo; var nombre: cadena);
var c: celular;
begin
	assign(a, nombre);
	reset(a);
	writeln('Archivos con stock menor al minimo:');
	while (not eof(a)) do begin
		read(a, c);
		if(c.stock<c.minimo) then
			writeln('Codigo: ', c.codigo, ', Stock minimo: ' ,c.minimo, ', Stock actual: ' ,c.stock, ', Precio: ',c.precio:3:2, ' Nombre, descripcion y marca: ' ,c.nombre, c.descripcion, c.marca);
	end;
end;

{c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.}
procedure ListarPorNombre(var a: archivo; var nombre: cadena);
var 
	c: celular;
	desc: cadena;
begin
	assign(a, nombre);
	reset(a);
	writeln('Ingrese la descripcion del celular que quiere buscar (debe tener 10 caracteres, rellenar con espacios.):');
	readln(desc);
	writeln('Archivos con la descripcion ' ,desc, ':');
	while (not eof(a)) do begin
		read(a, c);
		if(c.descripcion = desc) then
			writeln('Codigo: ', c.codigo, ', Stock minimo: ' ,c.minimo, ', Stock actual: ' ,c.stock, ', Precio: ',c.precio:3:2, ' Nombre, descripcion y marca: ' ,c.nombre, c.descripcion, c.marca);
	end;
end;


{d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”. }

procedure ExportarArchivo(var a: archivo; var nombre: cadena; var t: text);
var
	c: celular;
begin
	assign(a, nombre);
	assign(t, 'textoCelulares.txt');
	reset(a);
	rewrite(t);
	while (not eof(a)) do begin
        read(a, c);
		writeln(t, c.codigo, ' ' ,c.precio:3:2, ' ' ,c.marca);
	    writeln(t, c.stock, ' ' ,c.minimo, ' ' ,c.descripcion);
	    writeln(t, c.nombre);
	end;
	close(a);
	close(t);
	writeln('Archivo cargado');
end;

var
	a: archivo;
	nombre: cadena;
	t: text;
	aux: integer;
begin
	writeln('Ingrese un nombre de archivo.');
	readln(nombre);
	writeln('Ingrese una opcion:');
	writeln('1: crear un archivo llamado ' ,nombre, ' en base a los datos guardados en celulares.txt');
	writeln('2: Listar los celulares con stock menor al minimo.');
	writeln('3: Buscar un celular por su descripcion');
	writeln('4: Exportar el contenido del archivo ' ,nombre, ' a un archivo de texto.');
    readln(aux);
	case aux of
	1: CrearArchivo(a, nombre, t);
	2: ListarMenoresAlMinimo(a, nombre);
	3: ListarPorNombre(a, nombre);
	4: ExportarArchivo(a, nombre, t);
	else
	writeln('Adiós.');
	end;
	readln();
end.
