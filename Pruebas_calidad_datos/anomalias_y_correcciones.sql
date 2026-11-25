SELECT 'Nombres de producto mal codificados' AS anomalia,
       (SELECT COUNT(*) FROM jardineria_staging.stg_producto
        WHERE nombre COLLATE utf8mb4_bin LIKE '%Ã%'
           OR nombre COLLATE utf8mb4_bin LIKE '%Â%')      AS en_staging,
       (SELECT COUNT(*) FROM dm_jardineria.d_producto
        WHERE nombre_producto COLLATE utf8mb4_bin LIKE '%Ã%'
           OR nombre_producto COLLATE utf8mb4_bin LIKE '%Â%') AS en_data_mart
UNION ALL
SELECT 'Clientes duplicados (mismo nombre)',
       (SELECT COUNT(*) FROM (SELECT nombre_cliente
                              FROM jardineria_staging.stg_cliente
                              GROUP BY nombre_cliente
                              HAVING COUNT(*) > 1) x),
       (SELECT COUNT(*) FROM (SELECT nombre_cliente
                              FROM dm_jardineria.d_cliente
                              GROUP BY nombre_cliente
                              HAVING COUNT(*) > 1) y)
UNION ALL
SELECT 'Regiones nulas',
       (SELECT COUNT(*) FROM jardineria_staging.stg_cliente
        WHERE region IS NULL),
       (SELECT COUNT(*) FROM dm_jardineria.d_cliente
        WHERE region IS NULL OR region = '')
UNION ALL
SELECT 'Región "Islas Canarias" sin estandarizar',
       (SELECT COUNT(*) FROM jardineria_staging.stg_cliente
        WHERE region COLLATE utf8mb4_bin = 'Islas Canarias'),
       (SELECT COUNT(*) FROM dm_jardineria.d_cliente
        WHERE region COLLATE utf8mb4_bin = 'Islas Canarias')
UNION ALL
SELECT 'Pedidos rechazados dentro de las ventas',
       (SELECT COUNT(*) FROM jardineria_staging.stg_pedido
        WHERE estado COLLATE utf8mb4_bin = 'Rechazado'),
       (SELECT COUNT(DISTINCT h.num_pedido)
        FROM dm_jardineria.h_ventas h
        JOIN jardineria_staging.stg_pedido p ON p.ID_pedido = h.num_pedido
        WHERE p.estado COLLATE utf8mb4_bin = 'Rechazado');
        
        
