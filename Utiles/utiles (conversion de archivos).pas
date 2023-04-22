//módulos genéricos para copiar en caso de que se quiera convertir de archivo binario a txt o viceversa.

//procedimiento para crear un archivo binario a partir de un txt
procedure CrearBinarioAPartirDeTxt(var archivo_logico: archivo);
var 
    archivo_fisico: String;
    txt: text;
    n: nombre_registro; // cambiar por la variable que corresponda al registro
begin
    writeln('Ingrese el nombre que le quiere poner al archivo binario.');
    readln(archivo_fisico);
    assign(archivo_logico, archivo_fisico);
    rewrite(archivo_logico);
    assign(txt, 'nombredeltxt.txt'); //reemplazar por el nombre del archivo txt, conservando el ".txt"
    reset(txt);
    while not eof (txt) do begin 
        readln(txt, n.reg1, n.reg2, n.reg3); // cambiar por los nombres de los campos del registro. Procurar que los String se encuentren al final.
        readln(txt, n.reg4); // opcional: aplica si el txt tiene más de una línea de texto por registro
        write(archivo_logico, n);
    end;
    writeln('Archivo cargado.');    
    close(archivo_logico);
    close(txt);
end;

// procedimiento para crear un txt a partir de un archivo binario.
procedure ExportarArchivoDeTexto(var archivo_logico: archivo);
var 
    txt: text; // el nuevo archivo sera un txt
    n: nombre_registro; // cambiar por la variable que corresponda al registro
    archivo_fisico, nuevotxt: String;
begin
    writeln('Ingrese el nombre del archivo que quiere convertir a txt');
    readln(archivo_fisico);
    assign(archivo_logico, archivo_fisico);
    writeln('Se exportaran los datos del archivo fuente a un archivo txt');
    writeln('Ingrese el nombre que le quiere poner al nuevo archivo txt');
    readln(nuevotxt);
    assign(txt, nuevotxt);
    rewrite(txt);
    reset(archivo_logico);
    while not eof (archivo_logico) do begin 
        read(archivo_logico, n);
        writeln(txt, n.reg1, ' ' ,n.reg2, ' ' ,n.reg3);  // y asi tantos registros haya... procurar que los strings queden últimos. cambiar por los nombres de los campos del registro.
        writeln(txt, n.reg4); // opcional: ejemplo con más de una línea por registro del arch. binario
    end;
    close(archivo_logico);
    close(txt);
    writeln('Se creo correctamente el archivo txt.');
end;
