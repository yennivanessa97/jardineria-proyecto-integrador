USE jardineria_staging;

-- Catálogo de región
CREATE TABLE IF NOT EXISTS cat_region (
    region_origen   VARCHAR(50) COLLATE utf8mb4_bin NOT NULL,
    region_estandar VARCHAR(50) NOT NULL,
    PRIMARY KEY (region_origen)
);

TRUNCATE TABLE cat_region;

INSERT INTO cat_region (region_origen, region_estandar)
SELECT DISTINCT TRIM(region), TRIM(region)
FROM stg_cliente
WHERE region IS NOT NULL;

UPDATE cat_region
SET region_estandar = 'Canarias'
WHERE region_origen = 'Islas Canarias';

SELECT * FROM cat_region
ORDER BY region_estandar;

-- Nombres de producto: diagnóstico
SELECT ID_producto,
       RIGHT(nombre, 4) AS final_nombre,
       HEX(RIGHT(nombre, 4)) AS final_hex
FROM stg_producto
WHERE ID_producto IN (32, 168);

-- Nombres de producto: corrección
SELECT ID_producto,
       nombre AS nombre_original,
       REPLACE(
         REPLACE(nombre,
                 CONVERT(UNHEX('C382C2AA') USING utf8mb4),
                 CONVERT(UNHEX('C2AA') USING utf8mb4)),
         CONVERT(UNHEX('C383E2809C') USING utf8mb4),
         CONVERT(UNHEX('C393') USING utf8mb4)
       ) AS nombre_corregido
FROM stg_producto
WHERE nombre COLLATE utf8mb4_bin <>
      REPLACE(
        REPLACE(nombre,
                CONVERT(UNHEX('C382C2AA') USING utf8mb4),
                CONVERT(UNHEX('C2AA') USING utf8mb4)),
        CONVERT(UNHEX('C383E2809C') USING utf8mb4),
        CONVERT(UNHEX('C393') USING utf8mb4)
      ) COLLATE utf8mb4_bin;

-- Región: valores nulos
SELECT ID_cliente, nombre_cliente,
       region AS region_original,
       COALESCE(region, 'Sin región') AS region_corregida
FROM stg_cliente
WHERE region IS NULL;

-- Región: catálogo aplicado
SELECT c.ID_cliente, c.nombre_cliente,
       c.region AS region_original,
       COALESCE(r.region_estandar, 'Sin región') AS region_final
FROM stg_cliente c
LEFT JOIN cat_region r
       ON r.region_origen = TRIM(c.region)
WHERE c.region IS NULL
   OR c.region COLLATE utf8mb4_bin <> r.region_estandar COLLATE utf8mb4_bin;