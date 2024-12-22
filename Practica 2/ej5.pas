{5. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. 

Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}

program ej5;
uses
  SysUtils;
const
  valor_alto = 9999;
  dimF= 30;
type
  cadena = string[20];
  producto = record
    codigo: integer;
    nombre: cadena;
    desc: cadena;
    stock: integer;
    minimo: integer;
    precio: real;
  end;
  
  suc = record
    codigo: integer;
    cant_vendida: integer;
  end;

  maestro = file of producto;
  detalle = file of suc;
  arc_detalle = array[1..dimF] of detalle;
  reg_detalle = array[1..dimF] of suc;


procedure Leer(var a: detalle; var dato: suc);
begin
	if(not eof(a)) then
	  read(a, dato)
	else
	  dato.codigo:= 9999;
end;

procedure Minimo(var reg_d: reg_detalle; var min: suc; var data: arc_detalle);
var
  i: integer;
  pos_min: integer;
  cod_min: integer;
begin
	cod_min:= min.codigo;
	for i:= 1 to dimF do begin
	  if(reg_d[i].codigo < cod_min) then begin
	    pos_min:= i;
	    cod_min:= reg_d[i].codigo;
	  end;
	end;
	min:= reg_d[pos_min];
	Leer(data[pos_min], reg_d[pos_min]);
end;

procedure InicializarArchivos(var d: arc_detalle; var mae: maestro; var reg_d: reg_detalle);
var 
  i: integer;
begin 
  for i:= 1 to dimF do begin
    assign(d[i], 'detEj5' + IntToStr(i));
    reset(d[i]);
    Leer(d[i], reg_d[i]);
  end;
  assign(mae, 'maestroEj5');
  reset(mae);
end;

procedure ActualizarMaestro(var mae: maestro; var d: arc_detalle; var reg_d: reg_detalle; var min: suc; var p: producto);
var 
  total: integer;
begin
  while (min.codigo <> valor_alto) do begin 
  	total:= 0;
  	while(p.codigo = min.codigo) do begin
  	  total:= total+min.cant_vendida;
  	  Minimo(reg_d, min, d);
  	end;
  	if (total <> 0) then begin
  	  seek(mae, filePos(mae)-1);
  	  p.stock:= p.stock-total;
  	  write(mae, p);
  	end;
  	if(not eof(mae)) then
  	  read(mae, p);
  end;
end;

var
  i: integer;
  d: arc_detalle;
  reg_d: reg_detalle;
  mae: maestro;
  min: suc;
  p: producto;
begin
  InicializarArchivos(d, mae, reg_d);
  min.codigo:= 9998;
  Minimo(reg_d, min, d);
  read(mae, p);
  ActualizarMaestro(mae, d, reg_d, min, p);
  close(mae);
  for i:= 1 to dimF do 
    close(d[i]);
  writeln('Se actualizo el archivo maestro.');
  readln();
end.
