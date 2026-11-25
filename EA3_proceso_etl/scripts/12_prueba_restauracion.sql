SELECT 'jardineria.detalle_pedido' AS tabla,
       (SELECT COUNT(*) FROM jardineria.detalle_pedido)            AS original,
       (SELECT COUNT(*) FROM jardineria_test.detalle_pedido)       AS restaurado
UNION ALL
SELECT 'stg_detalle_pedido',
       (SELECT COUNT(*) FROM jardineria_staging.stg_detalle_pedido),
       (SELECT COUNT(*) FROM jardineria_staging_test.stg_detalle_pedido)
UNION ALL
SELECT 'v_venta_transformada',
       (SELECT COUNT(*) FROM jardineria_staging.v_venta_transformada),
       (SELECT COUNT(*) FROM jardineria_staging_test.v_venta_transformada)
UNION ALL
SELECT 'd_cliente',
       (SELECT COUNT(*) FROM dm_jardineria.d_cliente),
       (SELECT COUNT(*) FROM dm_jardineria_test.d_cliente)
UNION ALL
SELECT 'd_producto',
       (SELECT COUNT(*) FROM dm_jardineria.d_producto),
       (SELECT COUNT(*) FROM dm_jardineria_test.d_producto)
UNION ALL
SELECT 'd_fecha',
       (SELECT COUNT(*) FROM dm_jardineria.d_fecha),
       (SELECT COUNT(*) FROM dm_jardineria_test.d_fecha)
UNION ALL
SELECT 'h_ventas',
       (SELECT COUNT(*) FROM dm_jardineria.h_ventas),
       (SELECT COUNT(*) FROM dm_jardineria_test.h_ventas);