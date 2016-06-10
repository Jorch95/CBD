Program Ejercicio1;
Uses SysUtils;
Const
	Bloque = 64;
	CapacBloque = Bloque-SizeOF(Word);
	PorcCarga = 0.9; {Porcentaje de carga de los bloque(se deja espacio disponible por si se actualizan los regustros aumentando su longitud, para no tener que cambiarlos de bloque)}

TYPE

rEmpleado = record
	dni: Longint;	
	apYnom : String;
	fechaNac: Longint;
end;

tBloque = record
	cantRegs: Word; {Cantidad actual de registros en el bloque}
	contenido: Array[1..CapacBloque] of Byte; 
end;
	
AEmpleados = record
	arch : File of tBloque; {Archivo empleados}
	espLibre : File of Word; {archivo de control de bytes libres por bloque del archivo de empleados}
	bloque : tBloque; {ultimo bloque leido de empleados}
	iBloque : Word; {Indice de posicion dentro del bloque}
	espLibreBloque : Word;
end;

Var
	re: rEmpleado;
	ae: AEmpleados;
	dni: Longint;
	apYnom: String;
	fecha: longint;

Procedure agregar(var ae: AEmpleados; var re: rEmpleado);
var
	tamReg:Byte; libres:Word; disponibles:integer;
	tamanio:integer;
begin
	reset(ae);
	With ae do begin
		seek(espLibre,0);
		tamReg:=(Length(re)+1); {Calculo el espacio necesario ara almacenar la info.}
		tamanio:=tamReg;
		Writeln('Espacio del registro: ',tamanio,' ');
		repeat
		read(espLibre,libres);{Leo el espacio libre de los bloques.}
		disponibles:=libres-Round((1-PorcCarga)*CapacBloque);{bytes libres menos lo que no se pueden usar para altas.}
		until EOF(espLibre) or (disponibles>=tamReg);
		if (EOF(espLibre)) then begin
			bloque.cantRegs:=0; 
			libres:=CapacBloque;
			iBloque:=1;
			seek(arch,FileSize(arch));
		end else begin
			seek(arch, FilePos(espLibre)-1);
			read(arch,bloque);
			iBloque:=CapacBloque-libres+1;
			seek(arch,FilePOs(espLibre)-1);
			seek(espLibre,FilePos(espLibre)-1);
		end;
		Move(re,bloque.contenido[iBloque],tamReg);{Mueve 're' a contenido[iBloque] desplazandolo tamReg}
		Inc(bloque.cantRegs);
		Dec(libres,tamReg);	
		write(arch,bloque);
		write(espLibre,libres);
	end; {del With}
	close(ae);
end;

{Procedure imprimir(var ae:AEmpleados);
var
	re:rEmpleado;
begin
	reset(ae);
}			
Begin
	Writeln('Comienzo del programa');
	rewrite(ae);
	assign(ae,'file');	
	writeln('Agrega un empleado');
	Writeln('Dni: '); readln(dni);
	writeln('Apellido y nombre'); readln(apYnom);
	writeln('Fecha de nacimiento'); readln(fecha);
	while(dni <> 9999) do begin
		with re do
			dni:=dni;	
			apYnom:=apYnom;
			fechaNac:=fecha;
		end;
		agregar(ae,re);
		writeln('Agrega un empleado');
		Writeln('Dni: '); readln(dni);
		writeln('Apellido y nombre'); readln(apYnom);
		writeln('Fecha de nacimiento'); readln(fecha);
	end;
	writeln('termino la carga');
end.
	












