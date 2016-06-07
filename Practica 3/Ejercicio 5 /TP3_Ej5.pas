program TP3_Ej5;

CONST
	VALOR_ALTO = 9999;
	VALOR_FIN = '-80';
	VALOR_BASURA = '-10';
	NOMBRE_FILE = 'fileMarca';
TYPE

	tRegMarca = Record
		codigo_marca : integer;
		nombre : string;
	end;
	
	tArchRopaDeportiva = file of tRegMarca;

VAR
	fL_RP : tArchRopaDeportiva;
	ropDep : tRegMarca;
	eleccion : integer;
	

Procedure LeerArchivo(var fL_RP : tArchRopaDeportiva);
var
	ropDep : tRegMarca;
Begin
	reset(fL_RP);	
	writeln('-----INICIO-----');
	while (not EOF(fL_RP)) do begin
		read(fL_RP,ropDep);
		writeln(ropDep.codigo_marca,' |-| ',ropDep.nombre);
	end;
	writeln('-----FIN-----');
	close(fL_RP);
End;

Procedure CrearArchivo(var fL_RP : tArchRopaDeportiva);
var
	ropDep : tRegMarca;
Begin
	rewrite(fL_RP);
	writeln('--- CREAR ---');
	write('codigo: ');
	readln(ropDep.codigo_marca);
	write('nombre: ');
	readln(ropDep.nombre);
	while (ropDep.codigo_marca <> 0000) do begin
		write(fL_RP,ropDep);
		write('codigo: ');
		readln(ropDep.codigo_marca);
		write('nombre: ');
		readln(ropDep.nombre);
	end;
	writeln('--- CREAR - FIN ---');
	close(fL_RP);
End;

Procedure Leer(var arch : tArchRopaDeportiva; var regRopa : tRegMarca);
Begin
	if (EOF(arch)) then begin
		regRopa.codigo_marca:=VALOR_ALTO;
		regRopa.nombre:=VALOR_BASURA;
	end else begin
		read(arch, regRopa);
	end;
End;

Procedure Agregar(var arch : tArchRopaDeportiva; marca : tRegMarca);
{Abre el archivo y agrega la marca recibida como parámetro manteniendo la política
descripta anteriormente}
var
	regRopa, regAux : tRegMarca;
	valorNumerico, error : integer;
Begin
	reset(arch); {Reabre el archivo}
	Leer(arch, regRopa); {Lee el primer registro que determina si hay o no registros borrados}
	Val(regRopa.nombre, valorNumerico, error);
	if (error = 0) then begin {Si no hubo ningun error..}
		if (valorNumerico = 0) then begin {..y no hay registros borrados, se va a el final del archivo}
			seek(arch, FileSize(arch));
			write(arch, marca);
		end else begin {..y hay registros borrados, se va a la posicion obtenida y se setea el inicio del archivo}
			seek(arch, valorNumerico);
			Leer(arch, regRopa); {Obtengo la posicion encadenada de otro registro borrado}
			seek(arch, FilePos(arch)-1); 	{Agrego el..}
			write(arch, marca);				{..registro a agregar.}

			regAux.nombre:=regRopa.nombre;
			seek(arch, 0);
			write(arch,regAux);
		end;
	end;
	
	close(arch);
End;


Procedure Eliminar(var arch: tArchRopaDeportiva; marca: tRegMarca);
{Abre el archivo y elimina la marca recibida como parámetro manteniendo la política
descripta anteriormente}
var
	auxRopa,regRopa: tRegMarca;
	posRelativoReg, posUltElim : integer;
Begin
	posUltElim:=0; 
	posRelativoReg:=-1;
	reset(arch); {Reabre el archivo}
	Leer(arch, regRopa); {Lee el primer registro que determina si hay o no registros borrados}
	posUltElim:=regRopa.nombre;
		while ((regRopa.codigo_marca <> VALOR_ALTO) and (marca.codigo_marca <> regRopa.codigo_marca)) do begin {Mientras no se termine el archivo y no se encuentre el ultimo registro eliminado}
			writeln('----------- ACA ----------- : ', regRopa.nombre);
			Leer(arch, regRopa);
		end;
		if (marca.codigo_marca = regRopa.codigo_marca) then
			posRelativoReg:=FilePos(arch)-1;
		
		writeln('----------- ACA ----------- A eliminar: ', regRopa.nombre);
		if (auxRopa.nombre='0')then begin
			seek(arch, posRelativoReg);
			Str(0,regRopa.nombre);
			regRopa.codigo_marca:=-10; {Dato que no importa, es basura}
			write(arch, regRopa);
	
			seek(arch, 0);
			Str(posRelativoReg,regRopa.nombre); {Seteo el nuevo registro en los linkeados de los registros eliminados}
			regRopa.codigo_marca:=-10; {Dato que no importa, es basura}
			write(arch, regRopa);
			close(arch);
		end else begin
			seek(arch, posRelativoReg);
			Str(posUltElim,regRopa.nombre);
			regRopa.codigo_marca:=-10; {Dato que no importa, es basura}
			write(arch, regRopa);
		
			seek(arch,0);
			regRopa.codigo_marca:=-10;
			Str(posRelativaReg,regRopa.nombre);
			write(arch, regRopa);
			close(arch);
		end;
End;


BEGIN
	assign(fL_RP, NOMBRE_FILE);
	{}
	ropDep.codigo_marca:=-5;
	ropDep.nombre:='0';
	rewrite(fL_RP);
	write(fL_RP,ropDep);
	close(fL_RP);
	{}
	
	writeln('----->> Elegir: Agregar      (1) ');
	writeln('                Eliminar     (2) ');
	writeln('                Salir        (3) ');
	write('Elige: ');readln(eleccion);
	
	while (eleccion <> 3) do begin
		case eleccion of
			1:
			begin
				writeln('    - AGRAGAR -');
				write('codigo: ');
				readln(ropDep.codigo_marca);
				while (ropDep.codigo_marca <> 0000) do begin
					write('nombre: ');
					readln(ropDep.nombre);
					Agregar(fL_RP, ropDep);
					write('codigo: ');
					readln(ropDep.codigo_marca);
				end;
				writeln('    - -');
			end;
			2:
			begin
				writeln('    - ELIMINAR -');
				write('codigo: ');
				readln(ropDep.codigo_marca);
				while (ropDep.codigo_marca <> 0000) do begin
					Eliminar(fL_RP, ropDep);
					write('codigo: ');
					readln(ropDep.codigo_marca);
				end;
				writeln('    - -');
			end;
		end;
		writeln('----->> Elegir: Agregar      (1) ');
		writeln('                Eliminar     (2) ');
		writeln('                Salir        (3) ');
		write('Elige: ');readln(eleccion);
		LeerArchivo(fL_RP);
	end;
	
END.

{     --     SEUDO-CODIGO DEL PROGRAMA     --
* 
* Agregar:
* 	Leo la cabecera, si no hubo ningun error sigo;
* 	 	Si es cero agrego al final del archivo.
*		Si es N me muevo al valor N que seria un registro eliminado.
* 			Leo ese registro, tomo el valor que dice estar el proximo registro eliminado.
* 			Retrocedo un lugar, agrego el registro a agregar.
* 			Configuro un registro auxiliar con el dato: Si no hay proximo eliminado seteo el registro auxiliar con nombre ¨0¨ (no hay registros eliminados logicamente)
* 														Si hay proximo eliminado seteo el registro auxiliar con nombre ¨K¨ (siendo K el numero del registro en nombre de la posicion N)
* 			Me muevo al registro cabecera (reg con pos cero) y escribo ese registro auxiliar que tiene los valores seteados.
* 
* 
* Eliminar:
* 	Leo la cabecera, si no hubo ningun error sigo;
* 		Si es cero solamente recorro los registros buscando el registro a eliminar, cuando lo encuentre guardo esa posicion.
* 			Me muevo a ese logar que se encontro el eliminado y le pongo una marca de eliminado y le seteo el nombre para que se reconozca que no hay mas registros enlazados (-1).
* 		(*)	Me muevo a la posicion de ultimo eliminado (en este caso cabecera) y seteo linkeando la posicion de eliminacion de este ultimo registro que se se pidio eliminar.
* 		Si no es cero, antes de (*) tengo que recorrer todo el archivo buscando el ultimo eliminado, despues de eso se hace el (*) pero en este caso si es a la posicion de ultimo eliminado.
}

