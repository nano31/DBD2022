-- 10 Dadas las siguientes relaciones
-- Vehiculo = (patente, modelo, marca, peso, km)
-- Camion = (patente, largo, max_toneladas, cant_ruedas, tiene_acoplado)
-- Auto = (patente, es_electrico, tipo_motor)
-- Services = (fecha, patente, km_service, observaciones, monto)
-- Parte = (cod_parte, nombre, precio_parte)
-- Service_Parte = (fecha, patente, cod_parte, precio)

-- 1. Listar todos los datos de aquellos camiones que tengan entre 4 y 8 ruedas, y que hayan realizado algún
-- service en los últimos 365 días. Ordenar por patente, modelo y marca.
SELECT *
FROM Camion c INNER JOIN Vehiculo v on (c.patente = v.patente)
    INNER JOIN Services s on (v.patente = s.patente)
WHERE (c.cant_ruedas between 4 and 8) and (s.fecha between '25/10/2021' and '25/10/2022')


-- 2. Listar los autos que hayan realizado el service “cambio de aceite” antes de los 13.000 km o hayan realizado el
-- service “inspección general” que incluya la parte “filtro de combustible”.

SELECT *
FROM Autos a INNER JOIN Services s on (a.patente = s.patente)
WHERE (s.km_service < 13000) OR (s.observaciones = 'inspeccion general') OR (s.observaciones = 'filtro de combustible')

-- 3. Listar nombre y precio de todas las partes que aparezcan en más de 30 service que hayan salido (partes) más
-- -- de $4.000.



-- 4. Dar de baja todos los camiones con más de 250.000 km.



-- 5. Listar el nombre y precio de aquellas partes que figuren en todos los service realizados en el corriente año.
-- 6. Listar todos los autos cuyo tipo de motor sea eléctrico. Mostrar información de patente, modelo , marca y peso.
-- 7. Dar de alta una parte, cuyo nombre sea “Aleron” y precio $&400.
-- 8. Dar de baja todos los services que se realizaron al auto con patente ‘AWA564’.
-- 9. Listar todos los vehículos que hayan tenido services durante el 2018.