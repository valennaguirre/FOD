program ej6;
uses
  Sysutils;
const
  valor_alto = 9999;
  dimF = 5;
type
  cadena = string[30];
  sis = record
	cod_usuario: integer;
	fecha: cadena;
	tiempo_sesion: integer;
  end;

  detalle = file of sis;
  reg_detalle = array[1..dimF] of sis;
  arc_detalle = array[1..dimF] of detalle;

procedure Leer(var d: detalle; var dato: sis);
begin
	if(not eof(d)) then
	  read(d, dato)
	else
	  dato.cod_usuario := valor_alto;
end;

procedure Minimo(var det: arc_detalle; var reg_d: reg_detalle; var min: sis);
var
  i: integer; 
  min_pos: integer;
begin
  min.cod_usuario:= 9999;
  for i:= 1 to dimF do begin
    if (reg_d[i].cod_usuario < min.cod_usuario) then begin
      min:= reg_d[i];
      min_pos:= i;
    end
    else if (reg_d[i].cod_usuario = min.cod_usuario) then begin
    	if (reg_d[i].fecha < min.fecha) then begin
    	  min:= reg_d[i];
    	  min_pos:= i;
    	end;
    end;
  end;
  Leer(det[min_pos], min);
end;

procedure CrearMaestro(var mae: detalle; var det: arc_detalle; var reg_d: reg_detalle);
var 
  min, regM: sis;
begin

  rewrite(mae);
  regM.tiempo_sesion:= 0;
  Minimo(det, reg_d, min);
  while (min.cod_usuario <> valor_alto) do begin 
    regM.cod_usuario:= min.cod_usuario;
    regM.fecha:= min.fecha;
    while (min.cod_usuario = regM.cod_usuario) and (min.fecha = regM.fecha) do begin 
      regM.tiempo_sesion:= regM.tiempo_sesion+min.tiempo_sesion;
      Minimo(det, reg_d, min);
    end;
    write(mae, regM);
  end;
  writeln('Se creo el archivo maestro.');
  close(mae);
end;

procedure CerrarDetalles(var det: arc_detalle);
var 
  i: integer;
begin
  for i:= 1 to dimF do 
    close(det[i]); 
end;

var
  mae: detalle;
  reg_d: reg_detalle;
  det: arc_detalle;
  i: integer;
  nom_fis: cadena;
begin
  for i:= 1 to dimF do begin
    assign(det[i], 'detEj6' + IntToStr(i));
    reset(det[i]);
    Leer(det[i], reg_d[i]);
  end;
  nom_fis:= '/var/log/maestroEj6';
  AssignFile(mae, nom_fis);
  CrearMaestro(mae, det, reg_d);
  CerrarDetalles(det);
  readln(); 
end.
