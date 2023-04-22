// 1. Una empresa posee un archivo con informaciÃ³n de los ingresos percibidos por diferentes
// empleados en concepto de comisiÃ³n, de cada uno de ellos se conoce: cÃ³digo de empleado,
// nombre y monto de la comisiÃ³n. La informaciÃ³n del archivo se encuentra ordenada por
// cÃ³digo de empleado y cada empleado puede aparecer mÃ¡s de una vez en el archivo de
// comisiones.

// Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
// consecuencia, deberÃ¡ generar un nuevo archivo en el cual, cada empleado aparezca una
// Ãºnica vez con el valor total de sus comisiones.

// NOTA: No se conoce a priori la cantidad de empleados. AdemÃ¡s, el archivo debe ser
// recorrido una Ãºnica vez.


program Ej1;
const valorAlto = 9999;
type
    str5 = string[5];
    empleado = record 
        codigo: integer;
        nombre: str5;
        monto: integer;
    end;
    archivo = file of empleado;

// procedure CrearBinario(var archivo_logico: archivo);
// var 
//     archivo_fisico: String;
//     txt: text;
//     n: empleado;
// begin
//     writeln('Ingrese el nombre que le quiere poner al archivo binario.');
//     readln(archivo_fisico);
//     assign(archivo_logico, archivo_fisico);
//     rewrite(archivo_logico);
//     assign(txt, 'detalle.txt');
//     reset(txt);
//     while not eof (txt) do begin 
//         readln(txt, n.codigo, n.monto, n.nombre);
//         write(archivo_logico, n);
//     end;
//     writeln('Archivo cargado.');    
//     close(archivo_logico);
//     close(txt);
// end;

// procedure ExportarArchivoDeTexto(var archivo_logico: archivo);
// var 
//     txt: text; // el nuevo archivo sera un txt
//     n: empleado; // cambiar por la variable que corresponda al registro
//     archivo_fisico, nuevotxt: String;
// begin
//     writeln('Ingrese el nombre del archivo que quiere convertir a txt');
//     readln(archivo_fisico);
//     assign(archivo_logico, archivo_fisico);
//     writeln('Se exportaran los datos del archivo fuente a un archivo txt');
//     writeln('Ingrese el nombre que le quiere poner al nuevo archivo txt');
//     readln(nuevotxt);
//     assign(txt, nuevotxt);
//     rewrite(txt);
//     reset(archivo_logico);
//     while not eof (archivo_logico) do begin 
//         read(archivo_logico, n);
//         writeln(txt, n.codigo, ' ' ,n.monto, ' ' ,n.nombre);  // y asi tantos registros haya... procurar que los strings queden últimos. cambiar por los nombres de los campos del registro.
//     end;
//     close(archivo_logico);
//     close(txt);
//     writeln('Se creo correctamente el archivo txt.');
// end;

procedure Leer(var arc: archivo; var reg: empleado);
begin
    if not eof (arc) then
        read(arc, reg)
    else
        reg.codigo := valorAlto;
end;

var 
    reg: empleado;
    det, mae: archivo;
    total: integer;
    aux: empleado;
begin
    //CrearBinario(mae);
    // ExportarArchivoDeTexto(mae);
    total:= 0;
    assign(det, 'det');
    assign(mae, 'mae');
    reset(det);
    reset(mae);
    leer(det, reg);
    while (reg.codigo <> valorAlto) do begin
        aux:= reg;
        total:= 0;
        while (aux.codigo = reg.codigo) do begin
            writeln(reg.codigo);
            total:= total+reg.monto;
            leer(det, reg);
        end;
        aux.monto:= total;
        write(mae, aux);
    end;
    writeln('llega');
    close(det);
    close(mae);      
    writeln('Fin');
    readln();
end.
