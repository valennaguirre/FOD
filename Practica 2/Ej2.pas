program Ej2;
// 2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
// cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
// (cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
// un archivo detalle con el código de alumno e información correspondiente a una materia
// (esta información indica si aprobó la cursada o aprobó el final).

// Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
// haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
// programa con opciones para:

// a. Actualizar el archivo maestro de la siguiente manera:

// i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
// ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
// final.
// b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
// con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
// NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.

type
    alumno = record
        cod: integer;
        ape: String;
        nom: String;
        sinfinal: integer;
        confinal: integer;
    end;
    regdetalle = record 
        cod: integer;
        queaprobo: byte; // si aprueba final es 0, si aprueba solo cursada es 1.
    end;
    archivo = file of alumno;


// i. Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
// ii. Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
// final.

procedure ActualizoMaestro(var archivo_logico: archivo);
var 
    detalle: text;
    n: alumno;
    r: regdetalle;
    ok: boolean;
begin
    ok:= true;
    assign(archivo_logico, 'archivoalumnos');
    assign(detalle, 'detallepr2ej2.txt');
    reset(archivo_logico);
    reset(detalle);
    readln(detalle, r.cod, r.queaprobo);
    while not eof (archivo_logico) do begin 
        read(archivo_logico, n);        
        while (n.cod = r.cod) and (ok = true) do begin
            if (r.queaprobo = 0) then 
                n.confinal:= n.confinal+1
            else
                n.sinfinal:= n.sinfinal+1;
            if not eof(detalle) then
               readln(detalle, r.cod, r.queaprobo)
            else
                ok:= false;
        end;
        writeln(r.cod);
        seek(archivo_logico, FilePos(archivo_logico)-1);
        write(archivo_logico, n);
    end;
    close(archivo_logico);
    close(detalle);  
    writeln('Actualizado.');  
end;

// b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
// con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
procedure ListarMasDeCuatro(var archivo_logico: archivo);
var 
    txt: text; // el nuevo archivo sera un txt
    n: alumno; // cambiar por la variable que corresponda al registro
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
        if (n.confinal = 0) and (n.sinfinal >4) then
            writeln(txt, n.cod, ' ' ,n.sinfinal, ' ' ,n.confinal, ' ' ,n.ape, ' ' ,n.nom);  // y asi tantos registros haya... procurar que los strings queden últimos. cambiar por los nombres de los campos del registro.
    end;
    close(archivo_logico);
    close(txt);
    writeln('Se creo correctamente el archivo txt.');
end;


procedure CrearBinarioAPartirDeTxt(var archivo_logico: archivo);
var 
    archivo_fisico: String;
    txt: text;
    n: alumno; // cambiar por la variable que corresponda al registro
begin
    writeln('Ingrese el nombre que le quiere poner al archivo binario.');
    readln(archivo_fisico);
    assign(archivo_logico, archivo_fisico);
    rewrite(archivo_logico);
    assign(txt, 'alumnos.txt'); //reemplazar por el nombre del archivo txt, conservando el ".txt"
    reset(txt);
    while not eof (txt) do begin 
        readln(txt, n.cod, n.sinfinal, n.confinal, n.ape, n.nom); // cambiar por los nombres de los campos del registro. Procurar que los String se encuentren al final.
        write(archivo_logico, n);
    end;
    writeln('Archivo cargado.');    
    close(archivo_logico);
    close(txt);
end;

procedure ExportarArchivoDeTexto(var archivo_logico: archivo);
var 
    txt: text; // el nuevo archivo sera un txt
    n: alumno; // cambiar por la variable que corresponda al registro
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
        writeln(txt, n.cod, ' ' ,n.sinfinal, ' ' ,n.confinal, ' ' ,n.ape, ' ' ,n.nom);  // y asi tantos registros haya... procurar que los strings queden últimos. cambiar por los nombres de los campos del registro.
    end;
    close(archivo_logico);
    close(txt);
    writeln('Se creo correctamente el archivo txt.');
end;

var 
    archivo_logico: archivo;
begin
    //CrearBinarioAPartirDeTxt(archivo_logico);
    //ExportarArchivoDeTexto(archivo_logico);
    //ActualizoMaestro(archivo_logico); // EjA
    //ListarMasDeCuatro(archivo_logico); // EjB
    readln();
end.
