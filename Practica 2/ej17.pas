{17. Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.
Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
listado con el siguiente formato:

Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
posibles.

}

program ej17;
const 
  valor_alto = 32767;
type
  cadena = string[20];
  info = record
    cod_localidad: integer;
    nom_localidad: cadena;
    cod_municipio: integer;
    nom_municipio: cadena;
    cod_hospital: integer;
    nom_hospital: cadena;
    fecha: cadena;
    cant_positivos: integer;
  end;
  reg_detalle = record
    nom_localidad: cadena;
    nom_municipio: cadena;
    cant_positivos: integer;
  end;
  archivo = file of info; //orden: loc-muni-hosp.
  detalle = file of reg_detalle;

  //datos que me faltan:
  //total casos municipio (suma de los hospitales.)
  //total casos localidad (suma municipios.)
  //total casos provincia (suma localidades.)

  procedure ArmarDetalleMuni(var arc_detalle: detalle; nomLoc: cadena; nomMuni: cadena; totMuni: integer);
  var
    r: reg_detalle;
  begin
    r.nom_localidad:= nomLoc;
    r.nom_municipio:= nomMuni;
    r.cant_positivos:= totMuni;
    write(arc_detalle, r);
  end;

  procedure Leer(var a: archivo; var dato: info);
  begin
    if(not eof(a)) then
      read(a, dato)
    else
      dato.cod_localidad:= valor_alto;
  end;  

  procedure RecorrerArchivo(var a: archivo; var nombre: string; var arc_detalle: detalle);
  var
    i, ant: info;
    total_muni, total_loc, total_prov: integer;
  begin
    assign(a, nombre);
    assign(arc_detalle, 'detalleMilQuinientos');
    rewrite(arc_detalle);
    reset(a);
    total_muni:= 0;
    total_loc:= 0;
    total_prov:= 0;
    Leer(a, i);
    if(i.cod_localidad <> valor_alto) then begin
	    writeln('Nombre localidad: ' ,i.nom_localidad);
	    writeln('  Nombre municipio: ' ,i.nom_municipio);
	    writeln('	Nombre hospital: ' ,i.nom_hospital, '..... cantidad de casos: ' ,i.cant_positivos);
	    total_muni:= total_muni+i.cant_positivos;
	end;
	ant:= i;
	Leer(a, i);
    while(i.cod_localidad <> valor_alto) do begin
      if (i.cod_localidad <> ant.cod_localidad) then begin
        writeln('Cantidad de casos municipio ' ,ant.cod_municipio, ': ' ,total_muni);
        writeln('....................');
        if(total_muni > 1500) then
          ArmarDetalleMuni(arc_detalle, ant.nom_localidad, ant.nom_municipio, total_muni);
        total_loc:= total_loc+total_muni;
        total_muni:= 0
      	writeln('Cantidad de casos localidad ' ,ant.cod_localidad,': ' ,total_loc);
      	writeln('--------------------');
      	total_prov:= total_prov+total_loc;
      	total_loc:= 0;
      	writeln('Nombre localidad: ' ,i.nom_localidad);
	    writeln('  Nombre municipio: ' ,i.nom_municipio);      	
      end
      else if (i.cod_municipio <> ant.cod_municipio) then begin
        writeln('Cantidad de casos municipio ' ,ant.cod_municipio, ': ' ,total_muni);
        writeln('....................');
        if(total_muni > 1500) then
          ArmarDetalleMuni(arc_detalle, ant.nom_localidad, ant.nom_municipio, total_muni);
        total_loc:= total_loc+total_muni;
        total_muni:= 0;
	    writeln('  Nombre municipio: ' ,i.nom_municipio);
      end;
      writeln('	Nombre hospital: ' ,i.nom_hospital, '..... cantidad de casos: ' ,i.cant_positivos);
	  total_muni:= total_muni+i.cant_positivos;
	  ant:= i;
      Leer(a, i);
	end;
    writeln('Cantidad de casos municipio ' ,ant.cod_municipio, ': ' ,total_muni);
    writeln('....................');
    if(total_muni > 1500) then
      ArmarDetalleMuni(arc_detalle, ant.nom_localidad, ant.nom_municipio, total_muni);
    total_loc:= total_loc+total_muni;
    writeln('Cantidad de casos localidad ' ,ant.cod_localidad,': ' ,total_loc);
    writeln('--------------------');
    total_prov:= total_prov+total_loc;

    writeln('Cantidad de casos total en la provincia: ' ,total_prov);
    close(a);
    close(arc_detalle);
  end;

  procedure ExportarATxt(var arc_detalle: detalle; var txt: text);
  var 
    r: reg_detalle;
  begin
    assign(arc_detalle, 'detalleMilQuinientos');
    assign(txt, 'txtDetalleHospitales.txt');
    reset(arc_detalle);
    rewrite(txt);
    while not eof(arc_detalle) do begin
      read(arc_detalle, r);
      write(txt, r.cant_positivos, '' ,r.nom_municipio, '' ,r.nom_localidad);
    end;
    close(arc_detalle);
    close(txt);
  end;
var 
  a: archivo;
  nombre: cadena;
  txt: text;
  arc_detalle: detalle;
begin
  nombre:= 'archivoHospitales';
  RecorrerArchivo(a, nombre, arc_detalle);
  ExportarATxt(arc_detalle, txt);
  readln();
end;