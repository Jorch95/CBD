Program Ejercicio6;
Uses SysUtil;
CONST
	VALOR_ALTO = 9999;
	VALOR_BORRADO = -1;
Type

alumno = record
	edad : integer;
	dni : integer;
	nombre : String[12];
end;

archAlum = file of alumno;
textoAlum = text;

Var
maeAlum: archAlum; textAlum: textoAlum;
alum: alumno;

{Procedure Leer(var arch : archAlum);
var 
	alum : alumno;
begin
	if (EOF(arch) ) then begin                Me incomoda usarlo.
		alum.edad=VALOR_ALTO;
		alum.nombre='eof';
		alum.dni=VALOR_BORRADO;
	end else begin
		read(arch,alum);
	end
end;
}
Procedure crearArchivo(var arch: archAlum);
var
	alum : alumno;
begin
	rewrite(arch);
	assign(arch,'fileAlumnos.dat')
	alumno.nombre=VALOR_ALTO
	alumno.dni=VALOR_ALTO;
	alumno.edad=0;
	write(arch,alumno);{Reservo la cabecera del archivo para la lista de Eliminados.}
	writeln('Archivo Creado !');
	close(arch);
end;

Procedure crearATexto(var atext : textoAlum);
var
	alum : alumno;
begin
	assign(atext, 'Alumnos.txt'); {Ya creado con archivos};
end;

Procedure altaDeAlumnos(var arch : archAlum; atext : textoAlum;);
var
	aux,alum : alumno;
begin
	reset(arch);reset(atext);
	read(arch,alum);{Asi no sobreescribo la cabecera}
	readln(atext,aux.edad,aux.dni,aux.nombre)
	while(not EOF(atext)) do begin
		alum.nombre := aux.nombre;
		alum.edad := aux.edad;
		alum.dni := aux.dni;
		write(arch, alum);
		readln(atext,aux.edad,aux.dni,aux.nombre)
	end;
	writeln('Se termino de agregar los alumnos desde el archivo de texto');
	close(arch); close(atext);
end;

Procedure imprimirAlumnos(var arch : archAlum);
var
	alum : alumno;
begin
	reset(arch); read(arch,alumno);{Abro y evito la cabecera}
	while(not EOF(arch)) do begin
		read(arch,alum);
		if ( alumno.dni = VALOR_BORRADO) then 
			writeln( 'Se encontro un registro borrado');
		else begin
			write('Alumno: '+alum.nombre+' de edad: '+alum.edad+' con numero de dni: '+alum.dni'.');
			writeln();
		end;
	end;
end;
			






	






	







	











