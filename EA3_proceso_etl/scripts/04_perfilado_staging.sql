USE jardineria_staging;

-- Productos: espacios sobrantes
SELECT COUNT(*) AS con_espacios
FROM stg_producto
WHERE nombre COLLATE utf8mb4_bin <> TRIM(nombre) COLLATE utf8mb4_bin;

-- Productos: caracteres mal codificados
SELECT COUNT(*) AS mal_codificados
FROM stg_producto
WHERE nombre COLLATE utf8mb4_bin LIKE '%Ã%'
   OR nombre COLLATE utf8mb4_bin LIKE '%Â%'
   OR nombre COLLATE utf8mb4_bin LIKE '%�%';

SELECT ID_producto, nombre
FROM stg_producto
WHERE nombre COLLATE utf8mb4_bin LIKE '%Ã%'
   OR nombre COLLATE utf8mb4_bin LIKE '%Â%'
   OR nombre COLLATE utf8mb4_bin LIKE '%�%';

-- Estado de los pedidos
SELECT estado COLLATE utf8mb4_bin AS estado,
       COUNT(*) AS pedidos
FROM stg_pedido
GROUP BY estado COLLATE utf8mb4_bin
ORDER BY estado;

-- País de los clientes
SELECT pais COLLATE utf8mb4_bin AS pais,
       COUNT(*) AS clientes
FROM stg_cliente
GROUP BY pais COLLATE utf8mb4_bin
ORDER BY pais;

-- Ciudad de los clientes
SELECT ciudad COLLATE utf8mb4_bin AS ciudad,
       COUNT(*) AS clientes
FROM stg_cliente
GROUP BY ciudad COLLATE utf8mb4_bin
ORDER BY ciudad;

-- Región de los clientes
SELECT region COLLATE utf8mb4_bin AS region,
       COUNT(*) AS clientes
FROM stg_cliente
GROUP BY region COLLATE utf8mb4_bin
ORDER BY region;

-- Cantidad y precio
SELECT MIN(cantidad) AS cantidad_min, MAX(cantidad) AS cantidad_max,
       MIN(precio_unidad) AS precio_min, MAX(precio_unidad) AS precio_max,
       SUM(cantidad <= 0) AS cantidades_invalidas,
       SUM(precio_unidad <= 0) AS precios_invalidos
FROM stg_detalle_pedido;

-- Fechas de los pedidos
SELECT MIN(fecha_pedido) AS fecha_min,
       MAX(fecha_pedido) AS fecha_max,
       COUNT(*) - COUNT(fecha_pedido) AS fechas_nulas,
       COUNT(DISTINCT YEAR(fecha_pedido)) AS anios
FROM stg_pedido;

