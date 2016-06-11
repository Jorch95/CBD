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
	tamReg,tamNom,tamDni,tamFecha:Byte; libres:Word; disponibles:integer;
	tamanio:integer;
	dni,fecha,nombre:String[31];
begin
	Str(re.dni,dni);
	Str(re.fechaNac,fecha);
	reset(ae.espLibre);
	reset(ae.arch);
	With ae do begin
		seek(espLibre,0);
		tamNom:=(Length(re.apYnom)+1); {Calculo el espacio necesario ara almacenar la info.}
		tamDni:=(Length(dni)+1);
		tamFecha:=(Length(fecha)+1);
		tamReg:=tamNom+tamDni+tamFecha;
		Writeln('Tamanio nombre : ',tamNom,'.');
		Writeln('Tamanio Dni: ',tamDni,'.');
		Writeln('Tamanio fecha : ',tamFecha,'.');
		writeln('Tamanio del registro completo: ',tamReg,'.');
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
		Move(re.apYnom,bloque.contenido[iBloque],tamNom);
		Move(re.dni,bloque.contenido[iBloque],tamDni);
		Move(re.fechaNac,bloque.contenido[iBloque],tamFecha);
		Inc(bloque.cantRegs);
		Dec(libres,tamReg);	
		write(arch,bloque);
		write(espLibre,libres);
	end; {del With}
	close(ae.espLibre);
	close(ae.arch);
end;

{Procedure imprimir(var ae:AEmpleados);
var
	re:rEmpleado;
begin
	reset(ae);
}			
Begin
	Writeln('Comienzo del programa');
	assign(ae.arch,'archivo');
	assign(ae.espLibre,'archivolibre');
	rewrite(ae.arch);
	rewrite(ae.espLibre);
	writeln('Agrega un empleado');
	Writeln('Dni: '); readln(dni);
	writeln('Apellido y nombre'); readln(apYnom);
	writeln('Fecha de nacimiento'); readln(fecha);
	while(dni <> 9999) do begin
		with re do begin
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
	












