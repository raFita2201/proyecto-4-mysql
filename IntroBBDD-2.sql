-- =====================================================
-- Proyecto 4: SQL - Introducción a bases de datos
-- Base de datos: demo (esquema bookings) - PostgreSQL
-- Versión de la demo: demo-20250901-3m
-- =====================================================

-- Al conectar a la base demo ya viene configurado, pero no molesta
SET search_path TO bookings, public;

-- -----------------------------------------------------
-- 1. Vuelos con estado 'On Time' y su identificador
--    (en esta versión el número de vuelo es route_no)
-- -----------------------------------------------------
SELECT flight_id, route_no, status
FROM flights
WHERE status = 'On Time';

-- -----------------------------------------------------
-- 2. Reservas con importe total superior a 1.000.000 (rublos)
-- -----------------------------------------------------
SELECT *
FROM bookings
WHERE total_amount > 1000000;

-- -----------------------------------------------------
-- 3. Datos de los modelos de avión
--    En esta versión la tabla es airplanes_data
--    (el modelo está en JSON con traducciones)
-- -----------------------------------------------------
SELECT *
FROM airplanes_data;

-- -----------------------------------------------------
-- 4. Identificadores de vuelo con Boeing 737 (código 733)
--    El avión se define en la ruta, y la vista timetable
--    ya une vuelos y rutas
-- -----------------------------------------------------
SELECT flight_id
FROM timetable
WHERE airplane_code = '733';

-- Alternativa equivalente uniendo las tablas a mano:
-- SELECT f.flight_id
-- FROM flights f
-- JOIN routes r ON r.route_no = f.route_no
--              AND r.validity @> f.scheduled_departure
-- WHERE r.airplane_code = '733';

-- -----------------------------------------------------
-- 5. Tickets comprados por personas llamadas Irina
--    ILIKE no distingue mayúsculas de minúsculas
-- -----------------------------------------------------
SELECT *
FROM tickets
WHERE passenger_name ILIKE 'irina %';

-- =====================================================
-- OPCIONALES
-- =====================================================

-- -----------------------------------------------------
-- 6. Ciudades con más de un aeropuerto
-- -----------------------------------------------------
SELECT city, COUNT(*) AS num_aeropuertos
FROM airports
GROUP BY city
HAVING COUNT(*) > 1;

-- -----------------------------------------------------
-- 7. Número de vuelos por modelo de avión
-- -----------------------------------------------------
SELECT a.model, COUNT(*) AS num_vuelos
FROM timetable t
JOIN airplanes a ON a.airplane_code = t.airplane_code
GROUP BY a.model
ORDER BY num_vuelos DESC;

-- -----------------------------------------------------
-- 8. Reservas con varios pasajeros
--    Ojo: en esta versión un mismo pasajero con ida y vuelta
--    tiene 2 tickets, por eso se cuentan pasajeros distintos
-- -----------------------------------------------------
SELECT book_ref,
       COUNT(DISTINCT passenger_id) AS num_pasajeros,
       COUNT(*) AS num_billetes
FROM tickets
GROUP BY book_ref
HAVING COUNT(DISTINCT passenger_id) > 1;

-- -----------------------------------------------------
-- 9. Vuelos con retraso de salida superior a una hora
-- -----------------------------------------------------
SELECT flight_id, route_no, scheduled_departure, actual_departure,
       actual_departure - scheduled_departure AS retraso
FROM flights
WHERE actual_departure - scheduled_departure > INTERVAL '1 hour';
