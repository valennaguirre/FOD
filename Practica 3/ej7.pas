{7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. x

El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. x

Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. x

Para ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. x

Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados. x

Nota: Las bajas deben finalizar al recibir el código 500000 x}

program ej7;
const
  corte = 500000;
type
  cadena = string[10];
  especie = record
    codigo: integer;
    nombre: cadena;
    familia: cadena;
    descripcion: cadena;
    zona_geo: cadena;
  end;

  archivo = file of especie;

procedure BorradoLogico(var a: archivo; cod: integer; var encontrado: boolean);
var
  esp: especie;
begin
	while (not eof(a)) and (encontrado = false) do begin
	  read(a, esp);
	  if (esp.codigo = cod) then begin
	  	seek(a, filePos(a)-1);
	  	esp.codigo:= -1;
	  	write(a, esp);
	    encontrado:= true;
	  end;
	end;
end;

procedure BorradoFisico(var a: archivo);
var
  encontrado: boolean;
  esp: especie;
  posAux: integer;
begin
	seek(a, 0);
    encontrado:= false;
	while (not eof(a)) and (encontrado = false) do begin
	  read(a, esp);
	  if(esp.codigo < 0) then begin
	    posAux:= filePos(a)-1;
	    seek(a, fileSize(a)-1);
	    read(a, esp);
	    seek(a, posAux);
	    write(a, esp);
        seek(a, fileSize(a)-1);
	    Truncate(a);
	    encontrado:= true;
	  end;
	end;
end;

procedure DarDeBaja(var a: archivo; var cod: integer);
var
  encontrado: boolean;
begin
	assign(a, 'p3ej7');
	reset(a);
	encontrado:= false;
	BorradoLogico(a, cod, encontrado);
	if (encontrado) then begin
		BorradoFisico(a);
		writeln('Se elimino el elemento con codigo ' ,cod, '.');
	end
	else
	  writeln('No se pudo eliminar: el codigo no existe en el archivo.');
 close(a);
end;

procedure DeTxtABinario(var a: archivo; var txt: text);
var
	esp: especie;
begin    
	assign(txt, 'ptresej7.txt');
	assign(a, 'p3ej7');
	rewrite(a);
	reset(txt);
    readln();
	while (not eof(txt)) do begin
	  readln(txt,esp.codigo,esp.nombre,esp.familia,esp.descripcion,esp.zona_geo);
	  write(a, esp);
	end;
	writeln('Archivo p3ej7 cargado.');
	close(a);
	close(txt);
 readln();
end;

procedure ImprimirArchivo(var a: archivo);
var
  esp: especie;
begin
  assign(a, 'p3ej7');
  reset(a);
  while(not eof(a)) do begin
    read(a, esp);
    writeln(esp.codigo,esp.nombre,esp.familia,esp.descripcion,esp.zona_geo);
  end;
  close(a);
end;

var
  a: archivo;
  cod: integer;
  txt: text;
begin
    //DeTxtABinario(a,txt);
    cod:= 0;

	while (cod <> corte) do begin
		writeln('Ingrese un codigo de especie de ave a dar de baja en el archivo.');
		readln(cod);
		DarDeBaja(a, cod);
        ImprimirArchivo(a);
    end;
    writeln('Fin.');
	readln();
end.
