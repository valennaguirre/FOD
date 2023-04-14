{4. Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).

b. Modificar edad a uno o más empleados.

c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).

NOTA: Las búsquedas deben realizarse por número de empleado.
}

program Ej4;
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
    writeln('Ingrese: apellido, numEmp, nombre, edad y DNI. El proceso finaliza si el primer valor ingresado luego de este texto es "fin".');
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
    writeln('Archivo ' ,archivo_fisico, ' creado con exito. Presione enter para volver al menu principal.');
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
    writeln('Presione enter para volver al menu principal.');
    readln();
end;

{a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).}

function ExisteNumEmpleado(var archivo_logico: archivo; numEmp: integer):boolean;
var 
    existe: boolean;
    e: empleado;
begin
    existe:= false;
    reset(archivo_logico);
    while not eof (archivo_logico) do begin 
        read(archivo_logico,e);
        if(e.numEmp = numEmp) then begin
            existe:= true;
            break;
        end;
    end;
    ExisteNumEmpleado:= existe;
end;

procedure AgregarEmpleados(var archivo_logico: archivo; archivo_fisico: str);
var 
    e: empleado;
    contador: integer;
begin
    contador:= 0;
    writeln('Agregue empleados al archivo. Recuerde: no pueden contener un numero de empleado ya registrado.');
    writeln('Al ingresar "fin" como primer valor, termina el proceso.');
    writeln('');
    assign(archivo_logico, archivo_fisico);
    reset(archivo_logico);
    LeerEmpleado(e);
    while (e.apellido <> 'fin') do begin
        if (not ExisteNumEmpleado(archivo_logico, e.numEmp)) then begin
            seek(archivo_logico, FileSize(archivo_logico));
            write(archivo_logico, e);
            contador:= contador+1;
            LeerEmpleado(e);
        end 
        else begin
            writeln('El numero de empleado ingresado ya existe, pruebe nuevamente ingresando otro numero.');
            LeerEmpleado(e);
        end;
    end;
    close(archivo_logico);
    writeln('Se agregaron ' ,contador, ' empleados al archivo.');
    writeln('Presione enter para volver al menu principal.');
    readln();
end;

// b. Modificar edad a uno o más empleados.

procedure BuscarYModificar(var archivo_logico: archivo; num: integer);
var
   e: empleado;
begin
    seek(archivo_logico, 0);
        while not eof (archivo_logico) do begin 
            read(archivo_logico, e);
            if (e.numEmp = num) then begin 
                seek(archivo_logico, FilePos(archivo_logico)-1);
                writeln('Ingrese la edad actualizada del empleado numero ' ,e.numEmp, ' (Edad actual: ' ,e.edad, ').');
                readln(e.edad);
                write(archivo_logico, e);
                break;
            end;
        end;
    writeln('Se modifico la edad del empleado numero ' ,num, ' con exito.');
end;

procedure ModificarEdades(var archivo_logico: archivo; archivo_fisico: str);
var 
    num: integer;
begin
    writeln('');
    writeln('Ingrese el numero del empleado al que le quiere modificar la edad. (Al ingresar cero, termina el proceso y se regresa al menu principal)');
    readln(num);
    assign(archivo_logico, archivo_fisico);
    reset(archivo_logico);
    while (num <> 0) do begin
        seek(archivo_logico, 0);
        if (not ExisteNumEmpleado(archivo_logico, num)) then begin
            writeln('El numero ingresado no corresponde a ningún empleado. Intente nuevamente.');
            readln(num);
        end 
        else begin
            BuscarYModificar(archivo_logico, num);
            writeln('');
            writeln('Ingrese el numero de otro empleado al que le quiera modificar la edad, o 0 para volver al menu principal.');
            readln(num);
        end;
    end;
    close(archivo_logico);
end;

{c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.}

procedure ExportarArchivo(var archivo_logico: archivo; archivo_fisico: str);
var 
    txt: text;   
    e: empleado; 
begin
    assign(archivo_logico, archivo_fisico);
    reset(archivo_logico);
    assign(txt, 'todos_empleados.txt');
    rewrite(txt);
    while not eof(archivo_logico) do begin 
        read(archivo_logico,e);
        writeln(txt, e.apellido:5, ' ', e.nombre:5, ' ', e.edad:5, e.numEmp:5, e.dni);
    end;
    close(txt);
    close(archivo_logico);
    writeln('Txt exportado correctamente. Presione enter para volver al menu principal.');
    readln();
end;

{d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).}

procedure ExportarArchivoSinDNI(var archivo_logico: archivo; archivo_fisico: str);
var
    txt: text;
    e: empleado;
begin
    assign(archivo_logico, archivo_fisico);
    reset(archivo_logico);
    assign(txt, 'faltaDNIEmpleado.txt');
    rewrite(txt);
    while not eof(archivo_logico) do begin 
        read(archivo_logico, e);
        if (e.dni = 0) then 
            writeln(txt, e.apellido:5, ' ', e.nombre:5, ' ', e.edad:5, e.numEmp:5, e.dni);
    end;
    close(txt);
    close(archivo_logico);
    writeln('Txt exportado correctamente. Presione enter para volver al menu principal.');
end;

procedure SeleccionarArchivo(var archivo_fisico: str);
begin
    writeln('Ingrese nombre de archivo:');
    readln(archivo_fisico);
end;

var
    archivo_fisico: str;
    archivo_logico: archivo;
    e: empleado;
    o: integer;
begin
    SeleccionarArchivo(archivo_fisico);
    repeat
        writeln('Archivo actual: ' ,archivo_fisico);
        writeln('Ingrese una de las siguientes opciones:');
        writeln('-----------------------------------------------------');
        writeln('1: Crear nuevo archivo');
        writeln('2: Abrir archivo');
        writeln('3: Agregar datos al archivo');
        writeln('4: Modificar edades de empleados');
        writeln('5: Exportar todos los empleados a un nuevo archivo .txt');
        writeln('6: Exportar todos los empleados sin DNI cargado a un nuevo archivo .txt');
        writeln('7: Cambiar archivo actual');
        writeln('0: Salir!');
        writeln('-----------------------------------------------------');
        readln(o);
        case o of 
            1: CrearArchivo(archivo_fisico, archivo_logico, e);
            2: AbrirArchivo(archivo_logico, archivo_fisico, e);
            3: AgregarEmpleados(archivo_logico, archivo_fisico);
            4: ModificarEdades(archivo_logico, archivo_fisico);
            5: ExportarArchivo(archivo_logico, archivo_fisico);
            6: ExportarArchivoSinDNI(archivo_logico, archivo_fisico);
            7: SeleccionarArchivo(archivo_fisico);
            0: writeln('Au revoir.');
        end;
    until (o = 0);
    readln();
end.





