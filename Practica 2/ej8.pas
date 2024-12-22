{8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}

program ej8;
type 
  cadena = string[25];
  cliente = record
    cod: integer;
    nombre: cadena;
    apellido: cadena;
  end;

  regMaestro = record
    cli: cliente;
    ano: integer;
    mes: integer;
    dia: integer;
    monto: real;
  end;

  maestro = file of regMaestro;
  vectorMeses = array [1..12] of real;

{8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: 

los datos personales del cliente, 
el total mensual (mes por mes cuánto compró) 
y finalmente el monto total comprado en el año por el cliente. 

Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}

procedure VaciarVector(var vMeses: vectorMeses);
var 
  i: integer;
begin
  for i:= 1 to 12 do
    vMeses[i]:= 0;
end;

procedure LeerMaestro(var mae: maestro; var totalEmpresa: real);
var 
  regM, ant: regMaestro;
  totalAnio: real;
  vMeses: vectorMeses;
  i: integer;
begin
  assign(mae, 'MaestroEj8');
  reset(mae);
  totalAnio:= 0;
  totalEmpresa:= 0;
  read(mae, regM);
  while (not eof(mae)) do begin
  	ant:= regM;
  	while (regM.cli.cod = ant.cli.cod) do begin
  	  while(regM.mes = ant.mes) do begin
  	    vMeses[regM.mes]:= vMeses[regM.mes]+regM.monto;
  	    ant:= regM;
  	    if(not eof(mae)) then
  	      read(mae, regM);
      end;
    end;
  	writeln(ant.cli.cod, '' ,ant.cli.nombre, '' ,ant.cli.apellido);
  	writeln('Total Mes a Mes:');
  	for i:= 1 to 12 do begin
  	  if(vMeses[i] > 0) then begin
  	    writeln('Mes ' ,i, ': ' ,vMeses[i]:3:2);
  	    totalAnio:= totalAnio+vMeses[i];
  	  end;
  	end;
  	writeln('Monto total comprado en el año: ' ,totalAnio:3:2);
  	writeln('');
  	VaciarVector(vMeses);
  	totalEmpresa:= totalEmpresa+totalAnio;
  	totalAnio:= 0;
  end;

end;


var 
  mae: maestro;
  totalEmpresa: real;
begin
  LeerMaestro(mae, totalEmpresa);
  writeln('Total de ventas obtenido por la empresa: ' ,totalEmpresa:3:2);
  readln();
end.
