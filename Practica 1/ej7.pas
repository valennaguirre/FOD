// 7. Realizar un programa que permita:
// a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
// El nombre del archivo de texto es: “novelas.txt”

// b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
// una novela y modificar una existente. Las búsquedas se realizan por código de novela.

// NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
// género y precio de diferentes novelas argentinas. De cada novela se almacena la
// información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
// información: código novela, precio, y género, y la segunda línea almacenará el nombre
// de la novela

program ej7;
type
    novela = record 
        codigo: integer;
        nombre: String;
        genero: String;
        precio: real;
    end;
    archivo = file of novela;

procedure CrearBinario(var archivo_logico: archivo);
var 
    archivo_fisico: String;
    txt: text;
    n: novela;
begin
    writeln('Ingrese el nombre que le quiere poner al archivo binario.');
    readln(archivo_fisico);
    assign(archivo_logico, archivo_fisico);
    rewrite(archivo_logico);
    assign(txt, 'novelas.txt');
    reset(txt);
    while not eof (txt) do begin 
        readln(txt, n.codigo, n.precio, n.genero);
        readln(txt, n.nombre);
        write(archivo_logico, n);
    end;
    writeln('Archivo cargado.');    
    close(archivo_logico);
    close(txt);
end;

procedure ExportarArchivoDeTexto(var archivo_logico: archivo); // no lo pide
var 
    txt: text; // el nuevo archivo sera un txt
    n: novela;
    archivo_fisico: String;
begin
    writeln('Ingrese el nombre del archivo que quiere convertir a txt');
    readln(archivo_fisico);
    assign(archivo_logico, archivo_fisico);
    writeln('Se exportaran los datos del archivo fuente a un archivo txt');
    assign(txt, 'nuevotxt.txt');
    rewrite(txt);
    reset(archivo_logico);
    while not eof (archivo_logico) do begin 
        read(archivo_logico, n);
        writeln(txt, n.codigo, ' ' ,n.precio:3:2, ' ' ,n.genero);
        writeln(txt, n.nombre);
    end;
    close(archivo_logico);
    close(txt);
    writeln('Se creo correctamente el archivo txt.');
end;

// b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
// una novela y modificar una existente. Las búsquedas se realizan por código de novela.

procedure LeerNovela(var n: novela);
begin
    writeln('Ingrese los siguientes datos: codigo, precio, genero y nombre (apretar enter cuando se ingresa el nombre) ');
    readln(n.codigo, n.precio, n.genero);
    readln(n.nombre);
end;

procedure AgregarNovela(var archivo_logico: archivo);
var
    archivo_fisico: String;
    n: novela;
begin
    writeln('Ingrese el nombre del archivo que desea actualizar.');
    readln(archivo_fisico);
    assign(archivo_logico, archivo_fisico);
    reset(archivo_logico);
    LeerNovela(n);
    seek(archivo_logico, FileSize(archivo_logico));    
    write(archivo_logico, n);
    writeln('Novela agregada con exito.');
    close(archivo_logico);    
end;

function BuscarYModificarNovela(codigo: integer; var archivo_logico: archivo):boolean;
var 
    pos: integer;
    n: novela;
    encontre: boolean;
begin
    encontre:= false;
    reset(archivo_logico);
    while (not eof (archivo_logico)) do begin 
        read(archivo_logico, n);
        if (n.codigo = codigo) then begin
            pos:= FilePos(archivo_logico)-1;
            seek(archivo_logico, pos);
            writeln('A continuacion ingrese los nuevos datos de la novela.');
            LeerNovela(n);
            write(archivo_logico, n);
            encontre:= true;
            break;
        end;
    end;
    BuscarYModificarNovela:= encontre;
end;

procedure ModificarNovela(var archivo_logico: archivo);
var 
    archivo_fisico: String;
    seencontro: boolean;
    codigo: integer;
    n: novela;
begin
    writeln('Ingrese el nombre del archivo que desea actualizar.');
    readln(archivo_fisico);
    assign(archivo_logico, archivo_fisico);
    writeln ('Ingrese el codigo de la novela que quiere modificar');
    readln(codigo);
    seencontro:= BuscarYModificarNovela(codigo, archivo_logico);
    if (seencontro = false) then
        writeln('No se encontro la novela con el codigo ' ,codigo)
    else
        writeln('Se actualizo correctamente la novela.');
    close(archivo_logico);
end;

procedure ActualizarArchivo(var archivo_logico: archivo);
var
    opc: integer;
begin
    writeln('Seleccione una opcion.');
    writeln('1: Agregar nueva novela.');
    writeln('2: Modificar novela existente.');
    readln(opc);
    case opc of
        1: AgregarNovela(archivo_logico);
        2: ModificarNovela(archivo_logico);
    end;    
end;

var 
    archivo_logico: archivo;
    opc: integer;
begin
    repeat
        writeln('======================');
        writeln('Seleccione una opcion.');
        writeln('1: Crear archivo binario a partir de novelas.txt');
        writeln('2: Actualizar archivo binario. (Agregar nueva novela o modificar existente).');
        writeln('0: Salir.');
        writeln('======================');
        readln(opc);
        case opc of
            1: CrearBinario(archivo_logico);
            2: ActualizarArchivo(archivo_logico);
            9: ExportarArchivoDeTexto(archivo_logico);
            0: writeln('Adios.');
        end;
    until (opc = 0);
    readln();
end.
