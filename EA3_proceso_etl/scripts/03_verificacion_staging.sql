USE jardineria_staging;

-- 1. Estructura de Staging
SELECT table_name, column_name, column_type
FROM information_schema.columns
WHERE table_schema = 'jardineria_staging'
ORDER BY table_name, ordinal_position;

-- 2. Conteo de registros por tabla
SELECT 'stg_pedido' AS tabla, COUNT(*) AS registros FROM stg_pedido
UNION ALL SELECT 'stg_detalle_pedido', COUNT(*) FROM stg_detalle_pedido
UNION ALL SELECT 'stg_producto', COUNT(*) FROM stg_producto
UNION ALL SELECT 'stg_categoria_producto', COUNT(*) FROM stg_categoria_producto
UNION ALL SELECT 'stg_cliente', COUNT(*) FROM stg_cliente;

-- 3. Registros huérfanos
SELECT 'detalle sin pedido' AS verificacion, COUNT(*) AS huerfanos
FROM stg_detalle_pedido d
LEFT JOIN stg_pedido p ON p.ID_pedido = d.ID_pedido
WHERE p.ID_pedido IS NULL
UNION ALL
SELECT 'detalle sin producto', COUNT(*)
FROM stg_detalle_pedido d
LEFT JOIN stg_producto p ON p.ID_producto = d.ID_producto
WHERE p.ID_producto IS NULL
UNION ALL
SELECT 'pedido sin cliente', COUNT(*)
FROM stg_pedido p
LEFT JOIN stg_cliente c ON c.ID_cliente = p.ID_cliente
WHERE c.ID_cliente IS NULL
UNION ALL
SELECT 'producto sin categoria', COUNT(*)
FROM stg_producto p
LEFT JOIN stg_categoria_producto c ON c.Id_Categoria = p.Categoria
WHERE c.Id_Categoria IS NULL;

-- 4. Nulos y vacíos
SELECT 'stg_cliente.region' AS columna,
       COUNT(*) - COUNT(region) AS nulos, SUM(region = '') AS vacios
FROM stg_cliente
UNION ALL
SELECT 'stg_cliente.pais', COUNT(*) - COUNT(pais), SUM(pais = '')
FROM stg_cliente
UNION ALL
SELECT 'stg_producto.proveedor', COUNT(*) - COUNT(proveedor), SUM(proveedor = '')
FROM stg_producto;

-- 5. Duplicados
SELECT nombre_cliente, COUNT(*) AS veces
FROM stg_cliente
GROUP BY nombre_cliente
HAVING COUNT(*) > 1;

SELECT * FROM stg_cliente WHERE nombre_cliente = 'Lasas S.A.';

SELECT ID_cliente, COUNT(*) AS pedidos
FROM stg_pedido
WHERE ID_cliente IN (5, 11)
GROUP BY ID_cliente;

-- 6. Control de totales
SELECT 'origen' AS base,
       SUM(cantidad * precio_unidad) AS total_ventas,
       SUM(cantidad) AS total_unidades
FROM jardineria.detalle_pedido
UNION ALL
SELECT 'staging', SUM(cantidad * precio_unidad), SUM(cantidad)
FROM jardineria_staging.stg_detalle_pedido;