program ej6;
//cond.:
// Menu c/opciones p/:

// a) añadir uno o mas celulares al final del archivo con datos ingresados por teclado
// b) modificar stock de un celular dado
// c) exportar el contenido del archivo binario a un txt llamado "sin stock.txt" 
// con aquellos celulares que tengan stock 0.
// NOTA: las busquedas deben realizarse por nombre de celular.

type
    str = string[30];
    celular = record
        codigo: integer;
        nombre: str;
        descripcion: str;
        marca: str;
        precio: integer;
        stock_min: integer;
        stock_disp: integer;
    end;
    archivo = file of celular;

procedure LeerCelular(var cel: celular);
begin
    writeln('Ingrese nombre');
    readln(cel.nombre);
    if (cel.nombre <> 'fin') then begin 
        writeln('Codigo');
        readln(cel.codigo);
        writeln('Descripcion');
        readln(cel.descripcion);
        writeln('Marca');
        readln(cel.marca);
        writeln('Precio');
        readln(cel.precio);
        writeln('Stock minimo');
        readln(cel.stock_min);
        writeln('Stock disponible');
        readln(cel.stock_disp);
    end;
end;

procedure CrearArchivo(var archivo_logico: archivo; archivo_fisico: str);
var
    cel: celular;
begin
    rewrite(archivo_logico);
    LeerCelular(cel);
    while (cel.nombre <> 'fin') do begin
        write(archivo_logico, cel);
        LeerCelular(cel);
    end;
    writeln('Archivo ' ,archivo_fisico, ' creado con exito.');
end;

procedure CrearArchivoAPartirDeTxt(var archivo_logico: archivo; var txt: text);
var
    cel: celular;
begin
    assign(txt, 'celulares.txt');
    reset(txt);
    rewrite(archivo_logico);
    while not eof (txt) do begin 
        readln(txt, cel.codigo, cel.precio, cel.marca);
        readln(txt, cel.stock_disp, cel.stock_min, cel.descripcion);
        readln(txt, cel.nombre);
        //read(txt, cel.codigo, cel.marca);
        write(archivo_logico, cel);
    end;
    writeln('Archivo cargado.');
    close(txt);
    close(archivo_logico);
end;

procedure ImprimirStockMenorAlMinimo(var archivo_logico: archivo);
var 
    cel: celular;
begin
    writeln('Celulares con stock menor al minimo: ');
    writeln('');
    reset(archivo_logico);
    while not eof (archivo_logico) do begin 
        read(archivo_logico, cel);
        if(cel.stock_disp<cel.stock_min) then begin 
            writeln(cel.codigo, ' ' ,cel.precio, ' ', cel.marca);
            writeln(cel.stock_disp, ' ' ,cel.stock_min, ' ' ,cel.descripcion);
            writeln(cel.nombre);
            writeln('');
        end;
    end;    
    close(archivo_logico);
end;

procedure BuscarCelular(var archivo_logico: archivo);
var 
    descripcion: str;
    encontrado: boolean;
    cel: celular;
begin
    encontrado:= false;
    writeln('Ingrese la descripcion del celular que quiere buscar');
    readln(descripcion);
    reset(archivo_logico);
    while not eof (archivo_logico) and (encontrado = false) do begin
        read(archivo_logico, cel);
        if(cel.descripcion = descripcion) then begin 
            writeln('Se encontro el celular con la descripcion ' ,descripcion, '. Estos son sus datos: ');
            writeln(cel.codigo, ' ' ,cel.precio, ' ', cel.marca);
            writeln(cel.stock_disp, ' ' ,cel.stock_min, ' ' ,cel.descripcion);
            writeln(cel.nombre);
            writeln('');
            encontrado:= true;
        end;
    end;
    if(encontrado = false) then
        writeln('No se encontro el celular con la descripcion ingresada.'); 
    close(archivo_logico);   
end;

procedure ExportarArchivoDeTexto(var archivo_logico: archivo);
var 
    txt: text; // el nuevo archivo sera un txt
    cel: celular;
begin
    writeln('Se exportaran los datos del archivo fuente a un archivo txt');
    assign(txt, 'celulares.txt');
    rewrite(txt);
    reset(archivo_logico);
    while not eof (archivo_logico) do begin 
        read(archivo_logico, cel);
        writeln(txt, cel.codigo, cel.precio, cel.marca);
        writeln(txt, cel.stock_disp, cel.stock_min, cel.descripcion);
        writeln(txt, cel.nombre);
    end;
    close(archivo_logico);
    close(txt);
    writeln('Se creo correctamente el archivo txt.');
end;

procedure AgregarCelulares(var archivo_logico: archivo);
var 
    cel: celular;
begin
    reset(archivo_logico);
    LeerCelular(cel);
    seek(archivo_logico, FileSize(archivo_logico));
    while (cel.nombre <> 'fin') do begin 
        write(archivo_logico, cel);
        LeerCelular(cel);
    end;
    close(archivo_logico);
    writeln('Se ingreso "fin". Celulares agregados correctamente.');    
end;

function BuscarPos(var archivo_logico: archivo; nombre: str):integer;
var 
    cel: celular;
    encontre: boolean;
begin
    encontre:= false;
    reset(archivo_logico);
    while not eof (archivo_logico) and (encontre = false) do begin 
        read(archivo_logico, cel);
        if (cel.nombre = nombre) then begin 
            BuscarPos:= FilePos(archivo_logico)-1;
            writeln('POSICION' ,FilePos(archivo_logico)-1);
            encontre:= true;
        end;
    end;
    if(encontre = false) then
        BuscarPos:= -1;
end;

procedure ModificarCelular(var archivo_logico: archivo);
var 
    cel: celular;
    nombre: str;
    pos: integer;
    nuevostock: integer;
begin
    writeln('Ingrese el nombre del celular al que le quiere modificar su stock');
    readln(nombre);
    pos:= BuscarPos(archivo_logico, nombre);
    if (pos = -1) then
        writeln('No se encontro el celular con nombre ' ,nombre, '.')
    else begin
        reset(archivo_logico);
        seek(archivo_logico, pos);
        read(archivo_logico, cel);
        writeln('Ingrese el stock nuevo del celular ' ,nombre, '.');
        readln(nuevostock);
        cel.stock_disp:= nuevostock;
        seek(archivo_logico, pos); //?
        write(archivo_logico, cel);
        writeln('Los datos se actualizaron correctamente.');
    end; 
    close(archivo_logico);   
end;

var 
    opcion: integer;
    archivo_logico: archivo;
    archivo_fisico: str;
    txt: text;
begin 
    write('Bienvenido! ');
    writeln('Si nunca creaste un archivo, inicialmente debes crear un archivo con datos de celulares (opcion 9)');
    repeat
        writeln('Ingrese el nombre del archivo');
        readln(archivo_fisico);
        assign(archivo_logico, archivo_fisico);
        writeln('Acciones a realizar con ' ,archivo_fisico, ':');
        writeln('Ingrese una opcion: ');
        writeln('');
        writeln('=================');
        writeln('1: Crear archivo a partir de celulares.txt. ');
        writeln('2: Mostrar celulares con stock menor al minimo.');
        writeln('3: Buscar un celular por su descripcion.');
        writeln('4: Exportar archivo de texto con todos los celulares.');
        writeln('5: EJ6 Añadir celulares.');
        writeln('6: EJ6 Modificar stock de un celular.');
        writeln('7: EJ6 Exportar archivo de texto con todos los celulares sin stock disponible.');
        writeln('9: Crear archivo.');
        writeln('0: Salir del programa.');
        writeln('=================');
        readln(opcion);
        case opcion of
            1: CrearArchivoAPartirDeTxt(archivo_logico, txt);
            2: ImprimirStockMenorAlMinimo(archivo_logico);
            3: BuscarCelular(archivo_logico);
            4: ExportarArchivoDeTexto(archivo_logico);
            5: AgregarCelulares(archivo_logico);
            6: ModificarCelular(archivo_logico);
            9: CrearArchivo(archivo_logico, archivo_fisico);
            0: writeln('¡Adios!');
        end;
    until (opcion = 0);
    readln();
end.

