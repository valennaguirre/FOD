{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program Ej2;
type
    archivo = file of integer;
    str = string[12];
var
    arc_fisico: str;
    arc_logico: archivo;
    cantMenores: integer;
    cantTotal: integer;
    total: integer;
    prom: real;
    nro: integer;
begin
    writeln('Ingrese el nombre del archivo a abrir');
    readln(arc_fisico);
    assign(arc_logico, arc_fisico);
    reset(arc_logico);
    total:= 0;
    cantTotal:= 0;
    cantMenores:= 0;    
    while not eof (arc_logico) do begin 
        read(arc_logico, nro);
        cantTotal:= cantTotal+1;
        if (nro < 1500) then
            cantMenores:= cantMenores+1;
        total:= total+nro;
    end;
    prom:= total/cantTotal;
    writeln(cantMenores);
    writeln(cantTotal);
    writeln(prom:2:2);
    close(arc_logico);
    readln();
end.


