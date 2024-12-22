//4. Dada la siguiente estructura:
program ej4;
type
  reg_flor = record
	nombre: String[45];
	codigo:integer;
  end;
  tArchFlores = file of reg_flor;

{Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:

Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente}

procedure LeerFlor(var flor: reg_flor);
begin
  writeln('Ingrese un nombre de flor');
  readln(flor.nombre);
  writeln('Ingrese un codigo de flor');
  readln(flor.codigo);
end;

procedure agregarFlor (var a: tArchFlores; nombre: string;
codigo:integer);
var
  regAct, flor: reg_flor;
begin
  assign(a, nombre);
  reset(a);
  if (codigo = 0) then begin
    seek(a, fileSize(a));
    LeerFlor(flor);
    write(a, flor);
  end
  else begin
    seek(a, codigo*-1);
    read(a, regAct);
    seek(a, filePos(a)-1);
    LeerFlor(flor);
    write(a, flor);
    seek(a, 0);
    write(a, regAct);
  end;
  writeln('Se agregó una flor');
  close(a);
end;

{b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}

procedure ListarFloresNoEliminadas(var a: tArchFlores; nombre: string);
var
  flor: reg_flor;
begin
  assign(a, nombre);
  reset(a);
  while (not eof(a)) do begin
    read(a, flor);
    if (flor.codigo > 0) then
      writeln(flor.codigo, ' ' ,flor.nombre);
  end;
end;

procedure LeerCabecera(var a: tArchFlores; nombre: string);
var
  codigo: integer;
  flor: reg_flor;
begin
  assign(a, nombre);
  reset(a);
  read(a, flor);
  codigo:= flor.codigo;
  close(a);
  agregarFlor(a, nombre, codigo);
end;

var
  a: tArchFlores;
  flor: reg_flor;
  nombre: string;
  opc: integer;
begin
  nombre:= 'p3ej4';
  {assign(a, nombre);
  rewrite(a);
  flor.codigo:= 0;
  write(a, flor);
  writeln('Archivo creado');}
  writeln('Opciones');
  writeln('1: Agregar un elemento al archivo');
  writeln('2: Listar los elementos del archivo');
  readln(opc);
  case opc of
       1: LeerCabecera(a, nombre);
       2: ListarFloresNoEliminadas(a, nombre);
  end;
  readln();
end.
