{ 3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.}

program Ej3;

const
  corte = 9999;

type
  cadena = string[30];
  novela = record
    codigo: integer;
    genero: integer;
    nombre: cadena;
    duracion: integer;
    director: cadena;
    precio: real;
  end;
  archivo = file of novela;

{a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.}

procedure LeerNovela(var n: novela);
begin
  writeln('Ingrese codigo de la novela');
  readln(n.codigo);
  if (n.codigo <> corte) then begin
    writeln('Ingrese genero de la novela');
    readln(n.genero);
    writeln('Ingrese nombre de la novela');
    readln(n.nombre);
    writeln('Ingrese duracion de la novela');
    readln(n.duracion);
    writeln('Ingrese director de la novela');
    readln(n.director);
    writeln('Ingrese precio de la novela');
    readln(n.precio);
  end;
  writeln('----------');
end;

procedure CrearArchivo(var a: archivo; var nombre: cadena);
var
  n: novela;
begin
  assign(a, nombre);
  rewrite(a);
  n.codigo:= 0;
  while (n.codigo <> corte) do begin
    write(a, n);
    LeerNovela(n);
  end;
  close(a);
  writeln('Archivo creado');
end;



{Una vez abierto el archivo, brindar operaciones para:

  i. Dar de alta una novela leyendo la información desde teclado. Para
  esta operación, en caso de ser posible, deberá recuperarse el
  espacio libre. Es decir, si en el campo correspondiente al código de
  novela del registro cabecera hay un valor negativo, por ejemplo -5,
  se debe leer el registro en la posición 5, copiarlo en la posición 0
  (actualizar la lista de espacio libre) y grabar el nuevo registro en la
  posición 5. Con el valor 0 (cero) en el registro cabecera se indica
  que no hay espacio libre.}

procedure DarDeAlta(var a: archivo; var nombre: cadena);
var
  regAux, regAct: novela;
begin
  assign(a, nombre);
  reset(a);
  LeerNovela(regAux);
  read(a, regAct);
  if (regAct.codigo = 0) then begin //si no hay espacio, agrego al final
    seek(a, fileSize(a));
    write(a, regAux);
  end 
  else begin // si hay espacio, agregar en la posicion de un elemento que ha sido borrado.
    seek(a, regAct.codigo * -1);
    read(a, regAct);
    seek(a, filePos(a)-1);
    write(a, regAux);
    seek(a, 0);
    write(a, regAct);
  end;
  writeln('Se dio de alta una novela.');
  close(a);
end;

{ ii. Modificar los datos de una novela leyendo la información desde
	teclado. El código de novela no puede ser modificado.}

procedure NovelaAModificar(var n: novela);
begin
  writeln('Ingrese genero de la novela');
  readln(n.genero);
  writeln('Ingrese nombre de la novela');
  readln(n.nombre);
  writeln('Ingrese duracion de la novela');
  readln(n.duracion);
  writeln('Ingrese director de la novela');
  readln(n.director);
  writeln('Ingrese precio de la novela');
  readln(n.precio);
end;

procedure ModificarNovela(var a: archivo; var nombre: cadena);
var
  encontre: boolean;
  regActual: novela;
  regNuevo: novela;
begin
  assign(a, nombre);
  reset(a);
  writeln('Ingrese el codigo de la novela que quiere modificar');
  readln(regNuevo.codigo);
  encontre:= false;
  seek(a, 1);
  while (not eof(a)) and (encontre = false) do begin
    read(a, regActual);
    if (regActual.codigo = regNuevo.codigo) then begin
      NovelaAModificar(regNuevo);
      seek(a, filePos(a)-1);
      write(a, regNuevo);
      encontre:= true;
    end;
  end;

  if(encontre = true) then
    writeln('Se modifico correctamente la novela con codigo ' ,regNuevo.codigo)
  else
    writeln('El codigo ingresado no existe');
  close(a);
end;
	
{iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.}

procedure EliminarNovelaLogicamente(var a: archivo; var nombre: cadena);
var 
  regCabecera, regAux: novela;
  codigo: integer;
  encontre: boolean;
begin 
  assign(a, nombre);
  reset(a);
  writeln('Ingrese el codigo de la novela que desea eliminar');
  readln(codigo);
  encontre:= false;
  read(a, regCabecera);
  while (not eof(a)) and (encontre = false) do begin
    read(a, regAux);
    if (regAux.codigo = codigo) then begin
      seek(a, filePos(a)-1);
      write(a, regCabecera);
      seek(a, 0);
      regCabecera.codigo := regAux.codigo * -1;
      write(a, regCabecera);
      encontre:= true;
    end;
  end;
  if (encontre) then
    writeln('Se elimino la novela con codigo ' ,codigo, ' correctamente')
  else
    writeln('No se encontro el codigo de novela ingresado');
  close(a);
end;

{b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).}

procedure AbrirArchivo(var a: archivo; var nombre: cadena);
var
  aux: integer;
begin
	repeat
	writeln('1. Dar de alta una novela');
	writeln('2. Modificar datos de una novela');
	writeln('3. Eliminar una novela por su codigo');
  writeln('4: Salir de este menu');
	readln(aux);
	case aux of
		1: DarDeAlta(a, nombre);
		2: ModificarNovela(a, nombre);
		3: EliminarNovelaLogicamente(a, nombre);
	end;
	until (aux = 4);
end;

{c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}

procedure ListarEnTxt(var a: archivo; var nombre: cadena);
var
  txt: text;
  n:  novela;
begin
  assign(a, nombre);
  reset(a);
  assign(txt, 'kuatiahaipyre.txt');
  rewrite(txt);
  seek(a, 1);
  while (not eof(a)) do begin //las borradas las inserto en el txt del mismo modo que a las demás?
    read(a, n);
    writeln(txt, n.codigo, '', n.genero, '', n.duracion, '', n.precio:3:2, '', n.director, '', n.nombre);
  end;
  close(a);
  close(txt);
  writeln('Txt generado correctamente');
end;

procedure ImprimirArchivo(var a: archivo; var nombre: cadena);
var
  n: novela;
begin
  assign(a, nombre);
  reset(a);
  seek(a, 1);
  while (not eof(a)) do begin
    read(a, n);
    writeln(n.codigo, n.genero, n.duracion, n.precio:3:2, n.director, n.nombre);
  end;
  close(a);
end;

procedure Menu(var a: archivo; var nombre: cadena);
var
  opc: integer;
begin
  repeat
    writeln('Opciones:');
    writeln('1: Crear el archivo ' ,nombre, ' y cargarlo de datos de novelas');
    writeln('2: Abrir el archivo ' ,nombre);
    writeln('3: Listar en un txt todas las novelas del archivo ' ,nombre);
    writeln('4: Consultar datos del archivo'); //esta opcion no forma parte del ejercicio, es solo para consultar los datos
    writeln('5: Salir.');
    readln(opc);
    case opc of 
      1: CrearArchivo(a, nombre);
      2: AbrirArchivo(a, nombre);
      3: ListarEnTxt(a, nombre);
      4: ImprimirArchivo(a, nombre);
      5: writeln('Aguije terere jere!');
    else
      writeln('Opcion invalida.');
    end;
  until (opc = 5);
end;


//----programa principal----
var
a: archivo;
nombre: cadena;
begin
  writeln('Ingrese un nombre de archivo');
  readln(nombre);
  Menu(a, nombre);
  readln();
end.

