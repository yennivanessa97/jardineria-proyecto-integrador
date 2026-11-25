USE jardineria_staging;

-- Tabla calendario
SET SESSION cte_max_recursion_depth = 5000;
SET SESSION lc_time_names = 'es_ES';

CREATE TABLE IF NOT EXISTS calendario (
    fecha     DATE PRIMARY KEY,
    anio      INT,
    trimestre INT,
    mes       INT,
    desc_mes  VARCHAR(20),
    dia       INT,
    desc_dia  VARCHAR(20)
);

TRUNCATE TABLE calendario;

INSERT INTO calendario (fecha, anio, trimestre, mes, desc_mes, dia, desc_dia)
WITH RECURSIVE dias AS (
    SELECT DATE('2006-01-01') AS fecha
    UNION ALL
    SELECT fecha + INTERVAL 1 DAY
    FROM dias
    WHERE fecha < '2009-12-31'
)
SELECT fecha, YEAR(fecha), QUARTER(fecha), MONTH(fecha),
       MONTHNAME(fecha), DAY(fecha), DAYNAME(fecha)
FROM dias;

SELECT COUNT(*) AS dias, MIN(fecha) AS desde, MAX(fecha) AS hasta
FROM calendario;

-- Atributos de fecha
SELECT * FROM calendario
LIMIT 10;

-- Importe de venta por línea
SELECT ID_detalle_pedido, ID_pedido, ID_producto,
       cantidad, precio_unidad,
       cantidad * precio_unidad AS importe_venta
FROM stg_detalle_pedido
LIMIT 10;

-- Importe total
SELECT SUM(cantidad * precio_unidad) AS importe_total
FROM stg_detalle_pedido;
