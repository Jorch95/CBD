Program EjercicioParcial1;
CONST
VALOR_BORRADO = -10;
Type

producto = record
	cod:integer;
	nombre:string;
	desc:string;
	stock:integer;
end;

aProducto= file of producto;

Var
aProd: aProducto;
aText: text;
rProd: producto;

Procedure crearArchivoB(var aProd: aProducto);
var
	rProd:producto;
begin
	assign(aProd,'fileprod.dat');
	rewrite(aProd);
	rProd.stock:=0;{Uso stock para marcar que no hay ningun eliminado}
	write(aProd,rProd);{De esta forma me reservo la cabecera}
	close(aProd);
end;

Procedure crearArchivoT(var aText: text);
begin
	assign(aText,'productos.txt');{Ya esta creado el archivo y cargado}
	Writeln('Archivo de texto asignado, ya creado previamente con la informacion');
end;

Procedure agregar(var aProd: aProducto; rProd:producto);
var
	aux:producto;
	nLibre:Word;
begin
	reset(aProd);
	read(aProd,aux);
	nLibre:=aux.stock;
	if(nLibre=0) then begin
		seek(aProd,FileSize(aProd));{No hay ningun espacio para aprovechar, se agrega al final}
	end else begin
		seek(aProd,nLibre);
		read(aProd,aux);{Aca guardo el proximo en la lista para poner en la cabecera}
		seek(aProd,(FilePos(aProd)-1));
	end;
	write(aProd,rProd);{Se guarda el dato}
	seek(aProd,0);
	write(aProd,aux);{Si no habia ninguno eliminado, simplemente se vuelve a sobreescribir el mismo dato que habia en la cabecera}
	close(aProd);
end;

Procedure borrar(var aProd: aProducto; cod:integer);
var
	iUlt,aux:producto;
	posRelativa:Word;
	ultElim:Word;
begin
	reset(aProd);
	read(aProd,iUlt);
	ultElim:=iUlt.stock;{Posicion del ultimo eliminado}
	repeat read(aProd,aux) until aux.cod=cod;
	if (aux.cod=cod) then begin
		posRelativa:= (FilePos(aProd)-1);{Posicion de la nueva cabecera de la lista}
		aux.cod:=VALOR_BORRADO;
		aux.stock:=ultElim;
		seek(aProd,FilePos(aProd)-1);
		write(aProd,aux);
		iUlt.stock:=posRelativa;
		seek(aProd,0);
		write(aProd,iUlt);
	end else begin
		Writeln('no se encontro el codigo en el archivo');
		Writeln('Elija otro: ');
	end;
	Writeln('Saliste del proceso eliminar');
	close(aProd);
end;
			
Begin
	Writeln('Empieza el programa principal');
	crearArchivoB(aProd);
	crearArchivoT(aText);
	Writeln('Archivos creados');
	Writeln('Empieza la carga: ');
	reset(aText);	
{	readln(aText,rProd.cod,rProd.nombre);
	writeln('dato cod: ',rProd.cod,' dato nombre: ', rProd.nombre);
	readln(aText,rProd.desc);
	writeln('dato descripcion: ',rProd.desc);
	readln(aText,rProd.stock);
	writeln('dato stock: ',rProd.stock);}
	while(not EOF(aText)) do begin
		Writeln('Se siguen leyendo');
		readln(aText,rProd.cod,rProd.nombre);
		writeln('dato cod: ',rProd.cod,' dato nombre: ', rProd.nombre);
		readln(aText,rProd.desc);
		writeln('dato descripcion: ',rProd.desc);
		readln(aText,rProd.stock);
		writeln('dato stock: ',rProd.stock);
		agregar(aProd,rProd);
	end;
	writeln('Termino la carga');
	writeln('Luego hago la parte de eliminar');
	close(aText);
end.

	







