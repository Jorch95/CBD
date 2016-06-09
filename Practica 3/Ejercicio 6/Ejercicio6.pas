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
	alumno.edad=0;{Uso este campo para indicar la posicion del ultimo registro borradoa ser aprovechado}
	write(arch,alumno);{Reservo la cabecera del archivo para la lista de Eliminados.}
	writeln('Archivo Creado !');
	close(arch);
end;

Procedure crearATexto(var atext : textoAlum);
var
	alum : alumno;
begin
	assign(atext, 'Alumnos.txt'); {Ya creado con los datos};
end;

Procedure altaDeAlumnos(var arch : archAlum; var atext:textoAlum);
var
	aux,alum : alumno;
	error : integer;
	valor : Word;	
begin
	reset(arch);reset(atext);
	read(arch,alum);
	Val(alum.edad,valor,error);
	readln(atext,aux.edad,aux.dni,aux.nombre);
	while(not EOF(atext)) do begin
		alum.nombre := aux.nombre;
		alum.edad := aux.edad;
		alum.dni := aux.dni;
		if (valor= 0) then 
			seek(arch, FileSize(arch));
		else begin
			seek(arch,valor);
	`		read(arch,aux);
			seek(arch,0);
			write(arch,aux);
			seek(arch,valor);
		end;
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
		
Procedure borrarAlumnos(var arch : archAlum, alumB : alumno);
var
	alum, aux : alumno;	
	posUltElim : integer;
	posRelativo : Word;	
begin
	posUltElim:=0;
	posRelativo:=-1;
	reset(arch);
	read(arch, alum);
	posUltElim:=alum.edad;	{Guardo la direccion del ultimo eliminado, sino hay ningun eliminado tiene el valor 0 igualmente}
	while(not EOF(arch)) and (alum.dni = alumB.dni) do begin
		read(arch,alum);
	end;
	if (alum.dni = alumB.dni) then begin {Encontre el registro a borrar}
		alum.dni:= VALOR_BORRADO;
		alum.edad:= posUltElim;	{Guardo el Ultimo eliminado para mantener la referencia a la lista}
		posRelativo= (FilePos(arch)-1); {Lo uso para mantener la referencia a la lista de eliminado}
		seek(arch,FilePos(arch) -1);
		write(arch,alum); 
		writeln('Se borro el alumno con exito');
		seek(arch,0);
		Str(posRelativo,aux.edad);{para que guarda la posicion del recien eliminado en aux.edad}
		aux.nombre=VALOR_ALTO;:{No cro que}
		aux.dni=VALOR_BORRADO; { haga falta poner esto, pero por las dudas.}	
		write(arch,alum); {Asi queda el eliminado actualmente como cabecera de la lista de eliminados para ahorrar esapacio.}
	end else
		writeln('No se pudo encontrar el alumno'+alumB.dni='.');
	close(arch);
end;




	






	







	











