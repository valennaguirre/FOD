{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. 
Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program Ej2;
type
  cadena = string[30];
  asistente = record
    nro: integer;
    ape: cadena;
    nom: cadena;
    mail: cadena;
    telefono: cadena;
    dni: integer;
  end;
  archivo = file of asistente;

procedure CrearArchivo(var a: archivo; var nombre: cadena);
var 
  p: asistente;
begin 
  assign(a, nombre);
  rewrite(a);
  writeln('Ingrese un numero de asistente');
  readln(p.nro);
  while (p.nro <> 9999) do begin
    writeln('Ingrese: apellido, nombre, mail, telefono y dni uno por uno');
    readln(p.ape);
    readln(p.nom);
    readln(p.mail);
    readln(p.telefono);
    readln(p.dni);
    write(a, p);
    writeln('Ingrese un nuevo numero de asistente');
    readln(p.nro);
  end;
  close(a);
  writeln('Archivo creado');
end;

procedure Leer(var a: archivo; var p: asistente);
begin 
	if (not eof(a)) then
		read(a, p)
	else
		p.nro:= 9999;
end;


procedure RealizarBajas(var a: archivo; var nombre: cadena);
var 
  p: asistente;
begin
  assign(a, nombre);
  reset(a);
  Leer(a, p);
  while (p.nro <> 9999) do begin
	  if (p.nro<1000) then begin
	    seek(a, filePos(a)-1);
	    p.nom:= '***';
	    p.ape:= '***';
	    write(a, p);
	  end;
      Leer(a, p);
  end;
  close(a);
  writeln('Se realizaron las bajas correspondientes.');
end;

procedure ListarTodos(var a: archivo; var nombre: cadena);
var
  p: asistente;
begin
  writeln('Todos los asistentes:');
  assign(a, nombre);
  reset(a);
  while(not eof(a)) do begin
      read(a, p);
      writeln(p.nro);
      writeln(p.ape);
      writeln(p.nom);
      writeln(p.mail);
      writeln(p.telefono);
      writeln(p.dni);
  end;
  close(a);
end;

var 
  a: archivo;
  nombre: cadena;
  aux: integer;
begin 
  writeln('Ingrese un nombre de archivo');
  readln(nombre);
  repeat
  writeln('1: Crear archivo');
  writeln('2: Listar todos los asistentes');
  writeln('3: Realizar bajas');
  writeln('4: Salir');
  readln(aux);
  case aux of 
    1: CrearArchivo(a, nombre);
    2: ListarTodos(a, nombre);
    3: RealizarBajas(a, nombre);
    4: writeln('Adios');
  end;
  until (aux = 4);
  readln();
 end.
