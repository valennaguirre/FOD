{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}

program Ej1;
type
    archivo = file of integer;
    str = string[12];

var 
    arc_logico: archivo;
    nro: integer;
    arc_fisico: str;
begin
    writeln('Ingrese el nombre del archivo');
    readln(arc_fisico);
    assign(arc_logico, arc_fisico);
    rewrite(arc_logico); //con esto se crea el archivo
    readln(nro);
    while(nro <> 30000)do
    begin
        write(arc_logico,nro);
        readln(nro);
    end;
    close(arc_logico);//cerrar siempre el archivo usado.
end.
