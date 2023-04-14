program pruebaabrirarchivo;
type
    archivo = file of integer;
    str = string[12];
var
    nro: integer;
    arc_logico: archivo;
    arc_fisico: str;
begin
    writeln('Ingrese el nombre del archivo a abrir');
    readln(arc_fisico);
    assign(arc_logico, arc_fisico);
    reset(arc_logico);
    writeln('a');
    while not eof (arc_logico) do begin 
        read(arc_logico, nro);
        write(nro);
    end;
    close(arc_logico);
    readln();
end.
