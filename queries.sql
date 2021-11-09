mysql -u root -p;
show databases;
use tienda;
select nombre from producto;
select nombre, precio from producto;
select * from producto;
select nombre,precio,precio*0.80 from producto;
select nombre,precio as euros,precio*0.80 as dolars from producto;
select ucase(nombre) nombre, precio from producto;
select lcase(nombre) nombre, precio from producto;
select nombre, ucase(left(nombre,2)) from fabricante;
select nombre, round(precio) from producto;
select nombre, truncate(precio,0) from producto;
select codigo_fabricante from producto;
select codigo_fabricante from producto group by codigo_fabricante;
select nombre from fabricante order by nombre asc;
select nombre from fabricante order by nombre desc;
select nombre from productos order by nombre asc, precio desc;
-- no tiene sentido ya que no hay dos productos de nombre identico
select * from fabricante limit 0,5;
select * from fabricante limit 3,2;
select nombre,precio from producto order by precio asc limit 0,1;
select nombre,precio from producto order by precio desc limit 0,1;
select nombre from producto where codigo_fabricante = 2;
select producto.nombre, producto.precio, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo;
select producto.nombre, producto.precio, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo order by fabricante.nombre;
select producto.codigo, producto.nombre, fabricante.codigo, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo;
select producto.nombre, producto.precio, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo order by producto.precio asc limit 0,1;
select producto.nombre, producto.precio, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo order by producto.precio desc limit 0,1;
select producto.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo and fabricante.nombre = "Lenovo";
select producto.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo and fabricante.nombre = "Crucial" and producto.precio>200;
select producto.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo and (fabricante.nombre = "Asus" or fabricante.nombre = "Hewlett-Packard" or fabricante.nombre = "Seagate");
select producto.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo and fabricante.nombre in ("Asus","Hewlett-Packard","Seagate");
select producto.nombre, producto.precio, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo and fabricante.nombre like '%e';
select producto.nombre, producto.precio, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo and fabricante.nombre like '%w%';
select producto.nombre, producto.precio, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo and producto.precio > 180 order by producto.precio desc, fabricante.nombre asc;
-- no tiene sentido ya que no hay dos productos del mismo precio y de fabricantes distintos
select fabricante.codigo, fabricante.nombre from producto, fabricante where producto.codigo_fabricante = fabricante.codigo group by fabricante.codigo;
select fabricante.codigo, fabricante.nombre, producto.nombre from fabricante left JOIN producto ON producto.codigo_fabricante = fabricante.codigo;
select fabricante.codigo, fabricante.nombre from fabricante left JOIN producto ON producto.codigo_fabricante = fabricante.codigo where producto.codigo_fabricante is null;
select * from producto where codigo_fabricante = (select codigo from fabricante where nombre = "Lenovo");
select * from producto where precio = (select max(precio) from producto where codigo_fabricante = "2");
select nombre from producto where codigo_fabricante = "2" and precio = (select max(precio) from producto where codigo_fabricante = "2");
select nombre from producto where codigo_fabricante = "3" and precio = (select min(precio) from producto where codigo_fabricante = "3");
select * from producto where precio >= (select max(precio) from producto where codigo_fabricante = "2");
select * from producto where codigo_fabricante = "1" and precio > (select avg(precio) from producto where codigo_fabricante = "1");
------
-- Base universidad
------
create database universidad
exit
-- desde la linea de comandos
mysql -u root -p universidad<schema_universidad.sql
use universidad;
show tables;
--
-- querys --
--
select apellido1, apellido2, nombre from persona where tipo='alumno' order by apellido1 asc, apellido2 asc, nombre asc;
select apellido1, apellido2, nombre from persona where tipo='alumno' and telefono is null order by apellido1 asc, apellido2 asc, nombre asc;
select apellido1, apellido2, nombre from persona where tipo='alumno' and fecha_nacimiento like '1999%' order by apellido1 asc, apellido2 asc, nombre asc;
select apellido1, apellido2, nombre from persona where tipo='profesor' and telefono is null and nif like '%k' order by apellido1 asc, apellido2 asc, nombre asc;
select nombre from asignatura where curso ='3' and cuatrimestre='1' and id_grado='7';
select apellido1, apellido2, persona.nombre, departamento.nombre  from persona, departamento, profesor where tipo='profesor' and persona.id = id_profesor and id_departamento = departamento.id  order by apellido1 asc, apellido2 asc, persona.nombre asc;
select asignatura.nombre, anyo_inicio, anyo_fin from alumno_se_matricula_asignatura, asignatura, curso_escolar where id_alumno=(select id from persona where nif='26902806M') and asignatura.id = id_asignatura and curso_escolar.id = id_curso_escolar;
--
--Retorna un llistat amb el nom de tots els departaments que tenen professors que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
--
--Según la tabla profesor cada profesor está asignado a un departamento, por lo que no le encuentro sentido a la consulta.
--
select distinct id_alumno from alumno_se_matricula_asignatura where id_curso_escolar='5';
--
-- consultas join
--
-- no me salen correctamente, asi que lo repasaré para ver donde tengo el problema.
--

-- consultes resum
select count(*) from persona where tipo = 'alumno';
select count(*) from persona where tipo = 'alumno' and fecha_nacimiento like '1999%';
select departamento.nombre, count(*) as numero from profesor, departamento where profesor.id_departamento = departamento.id group by id_departamento order by numero desc;
--
select departamento.nombre, profesor.id_profesor from departamento left join profesor on profesor.id_departamento = departamento.id order by id_departamento, id_profesor; 
select departamento.nombre, count(profesor.id_departamento) from departamento left join profesor on profesor.id_departamento = departamento.id group by profesor.id_departamento;
--Can LEFT join have NULL values?
--When the on clause evaluates to "false" or NULL , the left join still keeps all rows in the first table with NULL values for the second table. If either sub_id or id is NULL , then your on clause evaluates to NULL , so it keeps all rows in the first table with NULL placeholders for the columns in the second.
--
-- Me ocurre exactamente esto...
--
-- Siguiente, hecho de dos maneras... identico problema
select grado.nombre, count(asignatura.id_grado) from grado, asignatura where grado.id = asignatura.id_grado group by asignatura.id_grado;
select grado.nombre, count(0) as numero from grado left join asignatura on grado.id = asignatura.id_grado group by asignatura.id_grado order by numero desc;
--
select grado.nombre, count(0) as numero from grado left join asignatura on grado.id = asignatura.id_grado group by asignatura.id_grado having numero > 40;
select grado.nombre, asignatura.tipo, sum(asignatura.creditos) as creditos from grado, asignatura where grado.id = asignatura.id_grado group by id_grado, tipo;
select anyo_inicio, count(id_alumno) from curso_escolar, alumno_se_matricula_asignatura where id = id_curso_escolar group by id_curso_escolar;
select id_profesor, count(id) from asignatura group by id_profesor;
select persona.id, persona.nombre, persona.apellido1, persona.apellido2, count(asignatura.id) from persona left join asignatura on persona.id = id_profesor group by id_profesor; -- identico problema de acumular los null en el primer registro que encuentra
select * from persona where tipo= "alumno" and fecha_nacimiento = (select max(fecha_nacimiento) from persona);

