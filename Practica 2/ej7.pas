{7. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.

Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:

1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

program Ej7;
uses
  Sysutils;
const
  valor_alto = 9999;
  dimF = 10;
type
  cadena = string[25];
  muni_det = record
    cod_loc: integer;
    cod_cepa: integer;
    cant_activos: integer;
    cant_nuevos: integer;
    cant_recuperados: integer;
    cant_fallecidos: integer;
  end;

  muni_mae = record
    cod_loc: integer;
    nom_loc: cadena;
    cod_cepa: integer;
    nom_cepa: cadena;
    cant_activos: integer;
    cant_nuevos: integer;
    cant_recuperados: integer;
    cant_fallecidos: integer;
  end;

  detalle = file of muni_det;
  maestro = file of muni_mae;
  arc_detalle = array [1..dimF] of detalle;
  reg_detalle = array [1..dimF] of muni_det;

procedure Leer(var d: detalle; var dato: muni_det);
begin
  if(not eof(d)) then
    read(d, dato)
  else
    dato.cod_loc:= valor_alto;
end;

procedure InicializarDetalle(var det: arc_detalle; var reg_D: reg_detalle);
var 
  i: integer;
begin
  for i:= 1 to dimF do begin
    assign(det[i], 'detEj7_' + IntToStr(i));
    reset(det[i]);
    Leer(det[i], reg_D[i]);
  end;
end;

procedure Minimo(var det: arc_detalle; var reg_D: reg_detalle; var min: muni_det);
var 
  i, pos_min: integer;
begin
  min.cod_loc:= valor_alto;
  min.cod_cepa:= valor_alto;
  for i:= 1 to dimF do begin
    if(reg_D[i].cod_loc < min.cod_loc) then
      pos_min:= i
    else if(reg_D[i].cod_loc = min.cod_loc) and (reg_D[i].cod_cepa < min.cod_cepa) then
        pos_min:= i;
  end;
  min:= reg_D[pos_min];
  Leer(det[pos_min], min);
end;

procedure CerrarDetalles(var det: arc_detalle);
var 
  i: integer;
begin
  for i:= 1 to dimF do 
    close(det[i]);
end;

{Para la actualización se debe proceder de la siguiente manera:

1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

procedure ActualizarMaestro(var mae: maestro; var det: arc_detalle; var reg_D: reg_detalle);
var 
  min: muni_det;
  regM: muni_mae;
begin 
  assign(mae, 'MaestroEj7');
  reset(mae);
  Minimo(det, reg_D, min);
  read(mae, regM);
  while (min.cod_loc <> valor_alto) do begin    
    while (regM.cod_loc = min.cod_loc) and (regM.cod_cepa = min.cod_cepa) do begin
      regM.cant_fallecidos:= regM.cant_fallecidos+min.cant_fallecidos;
      regM.cant_recuperados:= regM.cant_recuperados+min.cant_recuperados;
      regM.cant_activos:= min.cant_activos;
      regM.cant_nuevos:= min.cant_nuevos;
      Minimo(det, reg_D, min);
    end;
    seek(mae, filePos(mae)-1);
    write(mae, regM);
    if (not eof(mae)) then
      read(mae, regM);
  end;
  writeln('Maestro actualizado');
  close(mae);
  CerrarDetalles(det);
end;

procedure MasCincuentaActivos(var mae: maestro);
var 
  regM: muni_mae;
  total_activos, cant_localidades, ant: integer; 
begin
  assign(mae, 'MaestroEj7');
  reset(mae);
  cant_localidades:= 0;
  read(mae, regM);
  while (not eof(mae)) do begin
    total_activos:= 0;
    ant:= regM.cod_loc;
    while (regM.cod_loc = ant) do begin
      total_activos:= total_activos+regM.cant_activos;
      ant:= regM.cod_loc;
      if (not eof(mae)) then
        read(mae, regM);
    end;
    if (total_activos>50) then
      cant_localidades:= cant_localidades+1;
  end;
  writeln('Cantidad de localidades con mas de 50 casos activos: ' ,cant_localidades);
  close(mae);
end;

var
  mae: maestro;
  det: arc_detalle;
  reg_D: reg_detalle;
begin
  InicializarDetalle(det, reg_D);
  ActualizarMaestro(mae, det, reg_D);
  MasCincuentaActivos(mae);
  readln();
end.
