-- Ejercicio 2
-- AGENCIA (RAZON_SOCIAL, dirección, telef, e-mail)
-- CIUDAD (CODIGOPOSTAL, nombreCiudad, añoCreación)
-- CLIENTE (DNI, nombre, apellido, teléfono, dirección)
-- VIAJE( FECHA,HORA,DNI, cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)
-- //cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje

-- 1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de
-- ‘La Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y
-- luego por teléfono.

SELECT a.RAZON_SOCIAL, a.direccion, a.telefono
FROM Viaje v 
    INNER JOIN Agencia a ON (v.razon_social = a.razon_social)
    INNER JOIN Cliente c ON (v.DNI = c.DNI)
WHERE (v.razon_social IN (
    SELECT v.razon_social
    FROM Viaje v INNER JOIN Ciudad c (v.cpOrigen = c.CODIGOPOSTAL)
    WHERE (c.nombreCiudad = 'La Plata') AND (c.apellido = 'Roma')
    ORDER BY v.razon_social, a.telef
))

-- 2. Listar fecha, hora, datos personales del cliente, ciudad origen y destino de viajes realizados
-- en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’.

SELECT v.fecha, v.hora, c.DNI, c.nombre, c.apellido, c.telefono, c.direccion, origen.nombre, destino.nombre
FROM Viajes v
    INNER JOIN Cliente c ON (v.DNI = c.DNI)
    INNER JOIN Ciudad origen ON (v.cpOrigen = origen.CODIGOPOSTAL)
    INNER JOIN Ciudad destino ON (v.cpDestino = detino.CODIGOPOSTAL)
WHERE (v.fecha BETWEEN '01/01/2019' AND '31/01/2019') AND (v.descripcion = 'Demorado')

-- 3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección
-- de mail que termine con ‘@jmail.com’.

SELECT *
FROM Agencias a
    INNER JOIN Viajes v ON (v.razon_social = a.RAZON_SOCIAL)
WHERE (v.fecha BETWEEN '01/01/2019' AND '31/12/2019') OR (a.email = '%@jmail.com')

-- 4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
-- Brandsen’

SELECT c.DNi, c.nombre, c.apellido, c.telefono, c.direccion
FROM Viaje v 
    INNER JOIN Ciudad destino ON (v.cpDestino = destino.CODIGOPOSTAL)
    INNER JOIN Cliente c ON (v.DNI = c.DNI)
WHERE (destino.nombre = 'Coronel Brandsen')
EXCEPT(
    SELECT c.DNi, c.nombre, c.apellido, c.telefono, c.direccion
    FROM Viaje v 
        INNER JOIN Ciudad destino ON (v.cpDestino = destino.CODIGOPOSTAL)
        INNER JOIN Cliente c ON (v.DNI = c.DNI)
    WHERE NOT (destino.nombre = 'Coronel Brandsen')
)

-- 5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’.

SELECT COUNT(*) as 'Cantida de Viajes'
FROM Agencia a
    INNER JOIN Viaje v ON (a.RAZON_SOCIAL = v.razon_social)
    INNER JOIN Ciudad destino ON (v.cpDestino = destino.CODIGOPOSTAL)
WHERE (a.RAZON_SOCIAL = 'TAXI Y') AND (destino.nombreCiudad = 'Villa Elisa')

-- 6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias.

SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Agencia a
    INNER JOIN Cliente c
WHERE

-- 7. Modificar el cliente con DNI: 38495444 actualizando el teléfono a: 221-4400897.

UPDATE Cliente SET telefono = '221-4400897' WHERE DNI = '38495444'

-- 8. Listar razon_social, dirección y teléfono de la/s agencias que tengan mayor cantidad de
-- viajes realizados.

SELECT a.RAZON_SOCIAL, a.direccion, a.telefono
FROM Agencia a INNER JOIN Viaje v ON (a.RAZON_SOCIAL = v.razon_social)
GROUP BY a.RAZON_SOCIAL, a.direccion, a.telefono
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM Viaje v
    GROUP BY v.razon_social
)

-- 9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes.

SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c INNER JOIN Viaje v ON (c.DNI = v.DNI)
GROUP BY c.nombre, c.apellido, c.direccion, c.telefono
HAVING COUNT(*) >= 10

-- 10. Borrar al cliente con DNI 40325692.
DELETE FROM Viaje WHERE DNI = '40325692'
DELETE FROM Cliente WHERE DNI = '40325692'