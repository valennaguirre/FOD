{3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. 

Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas. 
De cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:

● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program ej3;
const
  valor_alto = 9999;
type
cadena = string[20];
producto = record
  codigo: integer;
  nombre: cadena;
  precio: real;
  stock: integer;
  minimo: integer;
end;

venta_prod = record
  codigo: integer;
  cant: integer;
end;

maestro = file of producto;
detalle = file of venta_prod;

procedure Leer(var a: detalle; var dato: venta_prod);
begin
	if (not eof(a)) then
	  read(a, dato)
	else
	  dato.codigo:= valor_alto;
end;

procedure ActualizarMaestro(var mae: maestro; var det: detalle);
var 
  p: producto;
  vp: venta_prod;
  totalVendido: integer;
  aux: integer;
begin
	assign(mae, 'maestroEj3');
	assign(det, 'detalleEj3');
	reset(mae);
	reset(det);
	read(mae, p);
	leer(det, vp);
	while (vp.codigo <> valor_alto) do begin
	  aux:= vp.codigo;
	  totalVendido:= 0;
		while (aux = vp.codigo) do begin
		  totalVendido:= totalVendido+vp.cant;
		  leer(det, vp);
		end;
		while(p.codigo <> aux) do
		  read(mae, p);
		seek(mae, filePos(mae)-1);
		write(mae, p);
		if(not eof(mae)) then
		  read(mae, p);
	end;
	close(det);
	close(mae);
	writeln('Se actualizo el maestro con el detalle.');
end;

procedure ListarStockMenorAlMinimo(var mae: maestro; var txt: text);
var 
  p: producto;
begin
	assign(mae, 'maestroEj3');
	assign(txt, 'stock_minimo.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae)) do begin
	  read(mae, p);
	  if(p.stock<p.minimo) then
	    writeln(txt, p.codigo, ' ' ,p.precio:3:2, ' ' ,p.stock, ' ' ,p.minimo, ' ' ,p.nombre);
	end;
	close(txt);
	close(mae);
	writeln('Se creo el archivo txt');
end;


var
  mae: maestro;
  det: detalle;
  txt: text;
  aux: char;
begin
	writeln('Opciones:');
	writeln('a: Actualizar stock del archivo de productos con el archivo de ventas realizadas');
	writeln('b: Listar productos con stock menor al mínimo en un archivo txt');
	readln(aux);
	case (aux) of
	'a': ActualizarMaestro(mae, det);
	'b': ListarStockMenorAlMinimo(mae, txt);
	else
	  writeln('Adios');
    end;
	readln();	
end.
