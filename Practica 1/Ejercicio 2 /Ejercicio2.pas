Program Ej3;
type
	kilosA = file of integer;

procedure crearArchivo(var archKilos: kilosA);
var
	str : string[15];
begin 
	writeln(' Ingrese un nombre para el archivo: ');
	readln(str);
	assign(archKilos,str);
end;

procedure inicializarArchivo(var archKilos : kilosA);
var
	aux : integer;
begin
	rewrite(archkilos);
	writeln('Ingrese la cantidad de kilos recolectados (Ingrese 0 para finalizar la carga)');
	readln(aux);
	while (aux <> 0) do begin
		write(archKilos,aux);	
		writeln('Ingrese la cantidad de kilos recolectados (Ingrese 0 para finalizar la carga)');
		readln(aux);
	end;
	close(archKilos);
end;

var
	archKilos : kilosA;
	total,aux,promedio,maximos,cant : integer;
begin
	cant:=0;
	maximos:=0;
	total:=0;
	crearArchivo(archKilos);
	inicializarArchivo(archKilos);
	reset(archKilos);
	writeln('Informe de de kilos de azucar recolectados');
	while (not eof(archKilos)) do begin
		cant+=1;
		read(archKilos,aux);
		writeln('La cantidad de kilos recolectados en el dia ',cant,' son ',aux);
		if ( aux > 18000) then 
			maximos+=1;
		total:= total + aux;
	end;
	promedio:= total div cant;
	writeln('El promedio recolectado de kilos por dia es: ',promedio);
	writeln('La cantidad de dias que se recolectareon mas de 18000 kilos de azucar son: ',maximos);
end.
	

	
		


