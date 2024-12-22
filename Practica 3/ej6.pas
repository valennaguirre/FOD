{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. x

De cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. x

Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. x

Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. x

Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo. x

Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. x

Para ello se deberá utilizar una estructura auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. x

Al finalizar este proceso de compactación del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original. x}

program ej6;
uses
	SysUtils;
type
	cadena = string[10];
	prenda = record
	  cod_prenda: integer;
	  descripcion: cadena;
	  colores: cadena;
	  tipo_prenda: cadena;
	  stock: integer;
	  precio_unitario: real;
	end;
	maestro = file of prenda;
	archActualizador = file of integer; //archivo de codigos de prendas

procedure DeTxtABinario(var a: archActualizador; var txt: text);
var
	codigo: integer;
begin    
	assign(txt, 'codej6.txt');
	assign(a, 'codigosej6');
	rewrite(a);
	reset(txt);
	while (not eof(txt)) do begin
	  readln(txt,codigo);
	  write(a, codigo);
	end;
	writeln('Archivo codigosej6 cargado.');
	close(a);
	close(txt);
 readln();
end;

procedure ActualizarPorCambioDeTemporada(var a: maestro; var aux: archActualizador);
var
  cod: integer;
  encontrado: boolean;
  reg: prenda;
begin
	assign(a, 'ej6p3');
	assign(aux, 'codigosej6');
	reset(a);
	reset(aux);
	encontrado:= false;
	while (not eof(aux)) do begin
	  read(aux, cod);
	  while (not eof(a) and encontrado = false) do begin
	    read(a, reg);
	    if(reg.cod_prenda = cod) then begin
	      seek(a, filePos(a)-1);
	      reg.stock:= -1;
	      write(a, reg);
	      encontrado:= true;
	    end;
	  end;
	  encontrado:= false;
	end;
	close(a);
	close(aux);
	writeln('Se dieron de baja las prendas incluidas en el archivo de códigos de prendas.');
end;

procedure ActualizarMaestro(var old: maestro; var nue: maestro);
var
  reg: prenda;
begin
  assign(old, 'ej6p3');
  assign(nue, 'archnuevoej6');
  reset(old);
  rewrite(nue);
  while (not eof(old)) do begin
    read(old, reg);
    if(reg.stock > -1) then
      write(nue, reg);
  end;
  close(old);
  close(nue);
  writeln('Se genero un archivo con los datos de las prendas a la venta.');
end;

procedure Imprimir(var a: maestro);
var
  reg: prenda;
begin
  assign(a, 'ej6p3');
  reset(a);
  while(not eof(a)) do begin
    read(a, reg);
    writeln(reg.cod_prenda, ' ' ,reg.descripcion, ' ' ,reg.colores, ' ' ,reg.tipo_prenda, ' ' ,reg.stock, ' ' ,reg.precio_unitario);
  end;
end;

var
  a: maestro;
  aux: archActualizador;
  nue: maestro;
  txt: text;
begin
  {DeTxtABinario(aux, txt);}
  {ActualizarPorCambioDeTemporada(a, aux);}
  ActualizarMaestro(a, nue);
  RenameFile('ej6p3', 'ej6p3maestroold');
  RenameFile('archnuevoej6', 'ej6p3');
  Imprimir(a);
  readln();
end.
