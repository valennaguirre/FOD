{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. x

De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. x

El nombre de las distribuciones no puede repetirse. x

Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario. x

b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.

c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

program ej8;
type
  cadena = string[7];
  distribucion = record
    nombre: cadena;
    ano: integer;
    numero_version: integer;
    cant_desarrolladores: integer;
    descripcion: cadena;
  end;
  archivo = file of distribucion;

procedure DeTxtABinario(var a: archivo; var txt: text);
var
	esp: distribucion;
begin    
	assign(txt, 'ptresej8.txt');
	assign(a, 'p3ej8');
	rewrite(a);
	reset(txt);
    readln();
    readln(txt, esp.cant_desarrolladores);
    write(a, esp);
	while (not eof(txt)) do begin
	  readln(txt,esp.cant_desarrolladores,esp.nombre,esp.ano,esp.numero_version,esp.descripcion);
	  write(a, esp);
	end;
	writeln('Archivo p3ej8 cargado.');
	close(a);
	close(txt);
 readln();
end;

procedure ImprimirArchivo(var a: archivo);
var
  esp: distribucion;
begin
  assign(a, 'p3ej8');
  reset(a);
  //seek(a, 1);
  while(not eof(a)) do begin
    read(a, esp);
    writeln(esp.cant_desarrolladores, ' ' ,esp.nombre, ' ' ,esp.ano, ' ' ,esp.numero_version, ' ' ,esp.descripcion);
  end;
  close(a);
end;

function ExisteDistribucion(var a: archivo; var nombre: cadena): boolean;
var
  dis: distribucion;
  encontrado: boolean;
begin
  assign(a, 'p3ej8');
  reset(a);
  seek(a, 1);
  encontrado:= false;
  while (not eof(a)) and (encontrado = false) do begin
    read(a, dis);
    if(dis.nombre = nombre) then
      encontrado:= true;
  end;
  close(a);
  ExisteDistribucion:= encontrado;
end;

procedure LeerDistribucion(var dis: distribucion; var a: archivo);
begin
  writeln('Ingrese nombre:');
  readln(dis.nombre);
  if(ExisteDistribucion(a, dis.nombre) = false) then begin
    writeln('Ingrese año:');
    readln(dis.ano);
    writeln('Ingrese numero_version:');
    readln(dis.numero_version);
    writeln('Ingrese cant_desarrolladores:');
    readln(dis.cant_desarrolladores);
    writeln('Ingrese descripcion:');
    readln(dis.descripcion);
  end
  else
    dis.ano:= -1;
end;

procedure AltaDistribucion(var a: archivo);
var
  dis, disCabecera: distribucion;
  pos: integer;
begin
  writeln('Ingrese los datos de la nueva distribucion:');
  LeerDistribucion(dis, a);
  if(dis.ano = -1) then
    writeln('Ya existe la distribucion')
  else begin
    assign(a, 'p3ej8');
    reset(a);
    read(a, disCabecera);
    if(disCabecera.cant_desarrolladores = 0) then begin
      seek(a, fileSize(a));
      write(a, dis);
    end 
    else begin
      pos:= disCabecera.cant_desarrolladores*-1;
      seek(a, pos);
      read(a, disCabecera);
      seek(a, filePos(a)-1);
      write(a, dis);
      seek(a, 0);
      write(a, disCabecera);
    end;
    writeln('Se dio de alta la nueva distribucion.');
    close(a);
  end;
end;

procedure BajaDistribucion(var a: archivo);
var
  nombre: cadena;
  regCabecera, regAux: distribucion;
  pos: integer;
  encontrado: boolean;
begin
  assign(a, 'p3ej8');
  writeln('Ingrese un nombre de distribucion');
  readln(nombre);
  encontrado:= false;
  if (ExisteDistribucion(a, nombre) = true) then begin
    reset(a);
    read(a, regCabecera);
    while (not eof(a)) and (encontrado = false) do begin
      read(a, regAux);
      if (regAux.nombre = nombre) then begin
        pos:= filePos(a)-1;
        seek(a, pos);
        write(a, regCabecera);
        seek(a, 0);
        regCabecera.cant_desarrolladores:= pos * -1;
        write(a, regCabecera);
        encontrado:= true;
      end;
    end;
    close(a);
    writeln('Se dio de baja a la distribucion ' ,nombre);
  end 
  else
    writeln('Distribucion no existente.');
end;

var
  a: archivo;
  txt: text;
  nombre: cadena;
begin
  {DeTxtABinario(a, txt);
  ImprimirArchivo(a); }
  AltaDistribucion(a);
  ImprimirArchivo(a);
  BajaDistribucion(a);
  ImprimirArchivo(a);
  readln();
end.
