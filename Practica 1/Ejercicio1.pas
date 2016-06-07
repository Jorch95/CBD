{
Realizar un programa que cree un archivo y luego efectué sobre el mismo la carga de números enteros.
La información será obtenida mediante teclado, los números ingresados no están ordenados.
El nombre del archivo debe ser proporcionado por el usuario. La carga finaliza al procesar el número 0 (cero),
que debe incorporarse al archivo.
}

Program CargaEnteros;
type
  archivo = file of integer;
var
  logicname: archivo;
  filename: string[12];
  num: integer;
begin
  write('Ingrese el nombre del archivo (12 caracteres)' );
  read(filename);
  assign(logicname, filename);
  rewrite(logicname);
  writeln ('Ingrese un número entero (0 para finalizar)');
  readln (num);	
  while (num <> 0) do begin
    write(logicname, num);
    writeln ('Ingrese un número entero (0 para finalizar)');
    readln (num);
  end;
  close(logicname);
end.
