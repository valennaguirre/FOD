{3. Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.}

program Ej3;
type 
    str = string[20];
    empleado = record
        numEmp: integer;
        apellido: str;
        nombre: str;
        edad: integer;
        dni: integer;
    end;
    archivo = file of empleado;

procedure LeerEmpleado(var e: empleado);
begin
    writeln('Ingrese: apellido, numEmp, nombre, edad y DNI, si pones fin primero se termina');
    readln(e.apellido);
    if (e.apellido <> 'fin') then begin
        readln(e.numEmp);
        readln(e.nombre);
        readln(e.edad);
        readln(e.dni);
    end;    
end;

procedure CrearArchivo(var archivo_fisico: str; var archivo_logico: archivo; var e: empleado);
begin
    assign(archivo_logico, archivo_fisico);
    rewrite(archivo_logico);
    LeerEmpleado(e);
    while (e.apellido <> 'fin') do begin 
        write(archivo_logico, e);
        LeerEmpleado(e);
    end;
end;

procedure AbrirArchivo(var archivo_logico: archivo; archivo_fisico: str; e: empleado);
var
    nombre: str;
    existe: boolean;
begin
    existe:= false;
    writeln('Ingrese un nombre a buscar en el archivo:');
    readln(nombre);
    assign(archivo_logico, archivo_fisico);
    writeln('');
    reset(archivo_logico);
    while not eof (archivo_logico) do begin 
        read(archivo_logico, e);
        if (e.nombre = nombre) then begin
            existe:= true;
            writeln('Empleado ' ,nombre, ': ');
            writeln('Nombre: ', e.nombre:5,', Apellido: ', e.apellido:5, ', Num. de emp.: ', e.numEmp:5, ', DNI: ', e.dni:5, ', Edad: ', e.edad);
            writeln('================');
        end;
    end;
    if (existe = false) then
        writeln('No se encontro ningun empleado con el nombre ingresado.');
    writeln('  ');
    reset(archivo_logico);
    writeln('Todos los empleados: ');
    while not eof (archivo_logico) do begin 
        read(archivo_logico, e);
        writeln('Nombre: ', e.nombre:5,', Apellido: ', e.apellido:5, ', Num. de emp.: ', e.numEmp:5, ', DNI: ', e.dni:5, ', Edad: ', e.edad);
        // writeln(e.apellido);
        // writeln(e.numEmp);
        // writeln(e.dni);
        // writeln(e.edad);
        writeln('================');
    end;
    writeln('  ');
    reset(archivo_logico);
    while not eof (archivo_logico) do begin 
        read(archivo_logico, e);
        if(e.edad>=70) then begin
            writeln('Empleado proximo a jubilarse: ');
            writeln('Nombre: ', e.nombre:5,', Apellido: ', e.apellido:5, ', Num. de emp.: ', e.numEmp:5, ', DNI: ', e.dni:5, ', Edad: ', e.edad);
            writeln('================');
        end;
    end;
    close(archivo_logico);
end;

var
    archivo_fisico: str;
    archivo_logico: archivo;
    e: empleado;
    o: integer;
begin
    writeln('Ingrese nombre de archivo:');
    readln(archivo_fisico);
    writeln('Ingrese una de las siguientes opciones:');
    writeln('-----------------------------------------------------');
    writeln('1: crear archivo');
    writeln('2: abrir a');
    writeln('0: Salir!');
    writeln('-----------------------------------------------------');
    readln(o);
    case o of 
        1: CrearArchivo(archivo_fisico, archivo_logico, e);
        2: AbrirArchivo(archivo_logico, archivo_fisico, e);
        0: writeln('Au revoir.');
    end;
    readln();
end.





