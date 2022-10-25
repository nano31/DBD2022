/*Ejercicio 1
    Cliente(idCliente, nombre, apellido, DNI, telefono, direccion)
    Factura (nroTicket, total, fecha, hora,idCliente (fk))
    Detalle(nroTicket, idProducto, cantidad, preciounitario)
    Producto(idProducto, descripcion, precio, nombreP, stock)*/

-- 1. Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por
-- DNI

SELECT c.idCliente, c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM Cliente c
WHERE (apellido LIKE "%Pe")

-- 2. Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras
-- solamente durante 2017.

SELECT c.nombre,c.apellido,c.DNI,c.telefono,c.direccion
FROM Cliente c INNER JOIN Factura f ON (c.idCliente = f.idCliente)
WHERE (f.fecha between 01/01/2017 and 31/12/2017)
EXCEPT (
    SELECT c.nombre,c.apellido,c.DNI,c/telefono,c.direccion
    FROM Cliente c INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    WHERE (f.fecha < 01/01/2017 and f.fecha > 31/12/2017)
)

-- 3. Listar nombre, descripción, precio y stock de productos vendidos al cliente con
-- DNI:45789456, pero que no fueron vendidos a clientes de apellido ‘Garcia’.

SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p
    INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
    INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
WHERE (c.DNI = "45789456")
EXCEPT (
    SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p
    INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
    INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
WHERE (c.apellido= "Garcia")
)

-- 4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que
-- tengan teléfono con característica: 221 (La característica está al comienzo del teléfono).
-- Ordenar por nombre.

SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p
WHERE p.idProducto NOT In (
    SELECT p.idProducto
    FROM Producto p
        INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
        INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
        INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
    WHERE (c.telefono LIKE "221%")
)
ORDER BY p.nombreP, p.idProducto
    
-- 5. Listar para cada producto: nombre, descripción, precio y cuantas veces fué vendido.
-- Tenga en cuenta que puede no haberse vendido nunca el producto.

SELECT p.nombreP,p.descripcion,p.precio, SUM (d.cantidad) as Cantidad
FROM Producto p LEFT JOIN Detalle d ON (p.idProducto = d.idProducto)
GROUP BY p.idProducto, p.nombreP, p.descripcion, p.precio

-- 6. Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los
-- productos con nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre
-- ‘prod3’.

SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM Producto p
    INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
    INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
WHERE (nombreP = 'prod1') and (c.idCliente IN(
    SELECT c.idCliente
    FROM Producto p
        INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
        INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
        INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
    WHERE (nombreP = 'prod2')
))
EXCEPT(
    SELECT c.idCliente
    FROM Producto p
        INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
        INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
        INNER JOIN  Cliente c ON (f.idCliente = c.idCliente)
    WHERE (nombreP = 'prod3')
)

-- 7. Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
-- comprado el producto ‘prod38’ o la factura tenga fecha de 2019.

SELECT f.nroTicket, f.total, f.fecha, f.hora, c.DNI
FROM Producto p
    INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
    INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
WHERE (nombreP = 'prod38') OR (f.fecha between '01/01/2019' AND '31/12/2019')

-- 8. Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’,
-- DNI:40578999, teléfono:221-4400789, dirección:’11 entre 500 y 501 nro:2587’ y el id de
-- cliente: 500002. Se supone que el idCliente 500002 no existe.

INSERT INTO Cliente (idCliente, nombre, apellido, DNI, telefono, direccion)
VALUES (500002, 'Jorge Luis', 'Castor', '40578999', '221-4400789', '11 e/ 500 y 501 nro: 2587')

-- 9. Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no
-- haya comprado el producto ´Z´.

SELECT f.nroTicket, f.total, f.fecha, f.hora
FROM Producto p
    INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
    INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
WHERE (c.nombre = 'Jorge') AND (c.apellido = 'Perez') AND (f.nroTicket NOT IN (
    SELECT f.nroTicket
    FROM Producto p
        INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
        INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
        INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
    WHERE (nombreP = 'Z')
))

-- 10. Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en
-- cuenta todas sus facturas, supere $10.000.000.

SELECT c.DNI, c.apellido, c.nombre, SUM (f.total) as montoTotal
FROM Factura f
    INNER JOIN Cliente c ON (f.idCliente = c.idCliente)
GROUP BY c.DNI, c.apellido, c.nombre
WHERE montoTotal > 10000000