{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}

program ej4;
const
  corte = 'fin';
type
  cadena = string[30];
  empleados = record
    nro: integer;
    apellido: cadena;
    nombre: cadena;
    edad: integer;
    dni: integer;
  end;
  archivo = file of empleados;

procedure CrearArchivo(var nombre: cadena; var a: archivo);
var
  e: empleados;
begin
  assign(a, nombre);
  rewrite(a);
  writeln('Ingrese el apellido del empleado');
  readln(e.apellido);
  while (e.apellido <> corte) do begin
    writeln('Ingrese el numero del empleado');
    readln(e.nro);
    writeln('Ingrese el nombre');
    readln(e.nombre);
    writeln('Ingrese la edad');
    readln(e.edad);
    writeln('Ingrese el dni');
    readln(e.dni);
    write(a, e);
    writeln('Ingrese un nuevo apellido de un empleado distinto a "fin"');
    readln(e.apellido);
  end;
  writeln('Archivo creado! Pulse enter p/continuar');
  close(a);
  readln();
end;

procedure BuscarNomApe(var nombre: cadena; var a: archivo);
var
  nom: cadena;
  e: empleados;
begin
  writeln('Ingrese un nombre/apellido a buscar');
  readln(nom);
  assign(a, nombre);
  reset(a);
  while(not eof(a)) do begin
    read(a, e);
    if((e.apellido = nom) or (e.nombre = nom)) then begin
      writeln(e.apellido);
      writeln(e.nombre);
      writeln(e.nro);
      writeln(e.edad);
      writeln(e.dni);
    end;
  end;
end;

procedure ListarTodos(var nombre: cadena; var a: archivo);
var
  e: empleados;
begin
  writeln('Todos los empleados:');
  assign(a, nombre);
  reset(a);
  while(not eof(a)) do begin
    read(a, e);
      writeln(e.apellido);
      writeln(e.nombre);
      writeln(e.nro);
      writeln(e.edad);
      writeln(e.dni);
  end;
end;

procedure MayoresASetenta(var nombre: cadena; var a: archivo);
var 
  e: empleados;
begin
  writeln('Empleados mayores a 70 aÃ±os: ');
  assign(a, nombre);
  reset(a);
  while(not eof(a)) do begin
    read(a, e);
    if(e.edad>70) then begin
      writeln(e.apellido);
      writeln(e.nombre);
      writeln(e.nro);
      writeln(e.edad);
      writeln(e.dni);
    end;
  end;
end;

procedure AbrirArchivo(var nombre: cadena; var a: archivo);
var
  aux: char;
begin
  writeln('Opciones:');
  writeln('a: Buscar empleados por nombre o apellido');
  writeln('b: Listar todos los empleados');
  writeln('c: Listar los empleados mayores a 70 aÃ±os');
  writeln('Otra tecla: salir');
  readln(aux);
  case aux of
  'a':  BuscarNomApe(nombre, a);
  'b':  ListarTodos(nombre, a);
  'c':  MayoresASetenta(nombre, a);
  else writeln('Menu');
  end;
  close(a);
end;

function ExisteEmpleado(var a: archivo; num: integer): boolean;
var
  existe: boolean;
  e: empleados;
begin
  existe:= false;
  seek(a, 0);
  while(not eof(a)) do begin
    read(a, e);
    if(e.nro = num) then
      existe:= true;
  end;
  ExisteEmpleado:= existe;
end;

//a. AÃ±adir uno o mÃ¡s empleados al final del archivo con sus datos ingresados por
//teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
//un nÃºmero de empleado ya registrado (control de unicidad).
procedure AniadirEmpleados(var nombre: cadena; var a: archivo);
  var
    e: empleados;
  begin
  assign(a, nombre);
  reset(a);
  writeln('Ingrese los datos del empleado que quiere aÃ±adir');
  writeln('Ingrese el apellido del empleado');
  readln(e.apellido);
  while (e.apellido <> corte) do begin
    writeln('Ingrese el numero del empleado');
    readln(e.nro);
    writeln('Ingrese el nombre');
    readln(e.nombre);
    writeln('Ingrese la edad');
    readln(e.edad);
    writeln('Ingrese el dni');
    readln(e.dni);
    if(ExisteEmpleado(a, e.nro) = false) then begin
      seek(a, fileSize(a));
      write(a, e);
      writeln('El empleado numero ' ,e.nro, ' se añadio con éxito.');
    end
    else
      writeln('El empleado con numero ' ,e.nro, ' ya existe. Intente nuevamente.');
    writeln('Ingrese un nuevo apellido de un empleado distinto a "fin"');
    readln(e.apellido);
  end;
  close(a);
end;

procedure Modificar(var a: archivo; num: integer);
  var
    e: empleados;
    edad: integer;
  begin
    seek(a, 0);
    while (not eof(a)) do begin
      read(a, e);
      if(e.nro = num) then begin
        writeln('Ingrese la nueva edad del empleado ' ,e.nombre, ' ' ,e.apellido, '.');
        readln(edad);
        e.edad:= edad;
        seek(a, filePos(a)-1);
        write(a, e);
      end;
    end;
  end;

//b. Modificar la edad de un empleado dado.
procedure ModificarEdad(var nombre: cadena; var a: archivo);
  var
    num: integer;
  begin
    assign(a, nombre);
    reset(a);
    writeln('Ingrese el numero del empleado al que le quiere modificar la edad.');
    readln(num);
    if (ExisteEmpleado(a, num) = false) then
      writeln('El empleado con numero ' ,num, ' no existe.')
    else begin
      Modificar(a, num);
      writeln('La edad del empleado se modificó con éxito');
    end;
    close(a);
  end;

//c. Exportar el contenido del archivo a un archivo de texto llamado
//todos_empleados.txt.
procedure ExportarTxt(var nombre: cadena; var a: archivo; var txt: text);
  var
    e: empleados;
  begin
    assign(txt, 'todos_empleados.txt');
    assign(a, nombre);
    reset(a);
    rewrite(txt);
    while (not eof(a)) do begin
      read(a, e);
      writeln(txt, e.nro, ' ' ,e.dni, ' ' ,e.edad, ' ' ,e.nombre, ' ' ,e.apellido);
    end;
    close(a);
    close(txt);
    writeln('El txt todos_empleados se creo con exito');
  end;
//d. Exportar a un archivo de texto llamado: faltaDNIEmpleado.txt, los empleados
//que no tengan cargado el DNI (DNI en 00).
procedure ExportarTxtSinDni(var nombre: cadena; var a: archivo; var txt: text);
  var
    e: empleados;
  begin
    assign(a, nombre);
    assign(txt, 'faltaDNIEmpleado.txt');
    reset(a);
    rewrite(txt);
    while (not eof(a)) do begin
      read(a, e);
      if(e.dni = 0) then
        writeln(txt, e.nro, ' ' ,e.dni, ' ' ,e.edad, ' ' ,e.nombre, ' ' ,e.apellido);
    end;
    close(a);
    close(txt);
    writeln('El txt faltaDNIEmpleado se creo con exito');
  end;

  {1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}
procedure RealizarBaja(var nombre: cadena; var a: archivo);
var 
  apellido: cadena;
  e: empleados;
  regAux: empleados;
  pos: integer;
begin
  writeln('Ingrese el apellido del empleado que quiere eliminar del archivo');
  readln(apellido);
  assign(a, nombre); 
  reset(a);
  while (not eof(a)) do begin
    read(a, e);
    if (e.apellido = apellido) then begin
      pos:= filePos(a);
      seek(a, fileSize(a)-1);
      read(a, e);
      seek(a, pos-1);
      write(a, e);
      Truncate(a);
    end;
  end;
  close(a);
  writeln('Datos procesados. El archivo ahora contiene los siguientes empleados:');
  ListarTodos(nombre, a);
end;

var
  a: archivo;
  nombre: cadena;
  aux: char;
  txt: text;
begin
  repeat
  writeln('Ingrese el nombre del archivo que quiere crear/abrir');
  readln(nombre);
  writeln('Opciones:');
  writeln('a: crear y completar un archivo llamado ' ,nombre);
  writeln('b: abrir el archivo ' ,nombre);
  writeln('c: aÃ±adir empleados al archivo' ,nombre);
  writeln('d: modificar edad de un empleado del archivo ' ,nombre);
  writeln('e: exportar el contenido de ' ,nombre, ' a un nuevo archivo de texto');
  writeln('f: exportar a un nuevo archivo de texto los empleados de ' ,nombre, ' que no tengan cargado el dni.');
  writeln('g: SALIR DEL MENU');
  readln(aux);
  case aux of
  'a':  CrearArchivo(nombre, a);
  'b':  AbrirArchivo(nombre, a);
  'c':  AniadirEmpleados(nombre, a);
  'd':  ModificarEdad(nombre, a);
  'e':  ExportarTxt(nombre, a, txt);
  'f':  ExportarTxtSinDni(nombre, a, txt);
  'w': RealizarBaja(nombre, a);
  'g': writeln('Adiós! (Presione Enter p/salir)');
  else writeln('Opción inválida.');
  end;
  until (aux='g');
  readln();
end.
