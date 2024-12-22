{4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. 

Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. 

Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program ej4;
const
  valor_alto = 'ZZZ';
type
	cadena = string[20];
	provincia = record
	  nombre: cadena;
	  total_alf: integer;
	  total_enc: integer;
	end;

	det_provincia = record
	  nombre: cadena;
	  cod_localidad: integer;
	  cant_alf: integer;
	  cant_enc: integer;
	end;

	maestro = file of provincia;
	detalle = file of det_provincia;

procedure Leer(var det: detalle; var dato: det_provincia);
begin
	if (not eof(det)) then
	  read(det, dato)
	else
	  dato.nombre:= valor_alto;
end;

procedure Minimo(r1: det_provincia; r2: det_provincia; var min: det_provincia);
var 
  det1, det2: detalle;
begin
	if(r1.nombre < r2.nombre) then begin
	  min:= r1;
	  leer(det1, r1);
	end
	else begin
	  min:= r2;
	  leer(det2, r2);
	end;
end;

procedure ActualizarMaestro(var mae: maestro; var det1: detalle; var det2: detalle);
var 
  r1, r2, min: det_provincia;
  p: provincia;
begin
  assign(det1, 'detalle1Ej4');
  assign(det2, 'detalle2Ej4');
  assign(mae, 'maestroEj4');
  reset(det1);
  reset(det2);
  rewrite(mae);
  Leer(det1, r1);
  Leer(det2, r2);
  Minimo(r1, r2, min);
  while (min.nombre <> valor_alto) do begin
    p.nombre:= min.nombre;
    p.total_alf:= 0;
    p.total_enc:= 0;
    while (p.nombre = min.nombre) do begin
      p.total_alf:= p.total_alf+min.cant_alf;
      p.total_enc:= p.total_enc+min.cant_enc;
      Minimo(r1, r2, min);
    end;
    write(mae, p);
  end;
  close(det1);
  close(det2);
  close(mae);
  writeln('Archivo maestro creado satisfactoriamente.');
end;

var
  mae: maestro;
  det1, det2: detalle;
begin
  ActualizarMaestro(mae, det1, det2);
  readln();
end.
