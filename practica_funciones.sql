/*
	Práctica de Funciones Ignacio D. López
*/

--CREAR LA BASE DE DATOS
create database super
use super

--CREAR LAS TABLAS
create table proveedores(
id_proveedor int primary key,
razon_social nvarchar(60))

create table productos(
id_producto int primary key,
descripcion nvarchar (60),
precio_venta decimal(18,2),
id_tasa_iva int,
id_gondola int,
id_proveedor int references proveedores(id_proveedor))


--CARGA DE DATOS INSERT

insert into proveedores(id_proveedor, razon_social)
values (1,'Arcor'),(2,'Paladini'), (3, 'Villavicencio')

insert into productos(id_producto, descripcion, precio_venta, id_tasa_iva, id_gondola, id_proveedor)
values (1,'Mermelada Durazno', 150, 20, 3, 1), (2,'Jamon Cocido', 400, 20, 2, 2), (3,'Agua Mineral', 140, 20, 1, 3)


--Select de las Tablas

select * from proveedores

select * from productos


--FUNCIONES

/* Función de Sistema Average: */

select avg (precio_venta) from productos --Promedio

select cast (round(avg(precio_venta), 2) as decimal (18,2)) from productos --Con Cast lo convierto a 18,2, ejemplo: $18,50 (para que sea utilizable).

--Función Count:
select count (id_producto) from productos --Cantidad de productos de la tabla .

--Función Max
select max (precio_venta) from productos --Muestra el producto más caro.

-- --

/* Funciónes Definidas por el Usuario */

--Escalar, le pasamos el valor neto y me lo devuelve sin iva.

create function fn_BaseImponible(@importe decimal(18,2))
returns decimal (18,2)
as
begin
	return (@importe / 1.21)
end

select dbo.fn_BaseImponible(100) -- 100 = importe personalizable. El resultado es el importe sin el iva.

select descripcion, dbo.fn_BaseImponible(precio_venta) as netos from productos --Ver todos los prodcutos sin el iva.

select descripcion, dbo.fn_BaseImponible(precio_venta) as neto, precio_venta as final from productos


--Función tipo tabla
create function fn_prod_gond (@gond int)
returns table
as
return(select * from productos where id_gondola = @gond)


select * from fn_prod_gond (2) -- Lo probamos


--Función tipo tabla, otro ejemplo. Resultado -> descripcion concatenada con el precio
create function fn_descr_precio (@gond int)
returns @descr_precio table
(
descr_precio nvarchar(60)
)
as
begin
insert into @descr_precio
select (Descripcion +',' + convert(nvarchar(20), precio_venta)) from productos where id_gondola = @gond
return
end


select * from fn_descr_precio(2) --Lo probamos