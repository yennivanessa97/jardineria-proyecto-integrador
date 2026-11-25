USE dm_jardineria;

SELECT 'hecho sin cliente' AS verificacion, COUNT(*) AS huerfanos
FROM h_ventas h
LEFT JOIN d_cliente c ON c.id_cliente = h.id_cliente
WHERE c.id_cliente IS NULL
UNION ALL
SELECT 'hecho sin producto', COUNT(*)
FROM h_ventas h
LEFT JOIN d_producto p ON p.id_producto = h.id_producto
WHERE p.id_producto IS NULL
UNION ALL
SELECT 'hecho sin fecha', COUNT(*)
FROM h_ventas h
LEFT JOIN d_fecha f ON f.id_fecha = h.id_fecha
WHERE f.id_fecha IS NULL;

SELECT 'cargadas' AS concepto,
       COUNT(*) AS lineas,
       SUM(importe_venta) AS importe
FROM h_ventas
UNION ALL
SELECT 'rechazadas',
       COUNT(*),
       SUM(importe_venta)
FROM jardineria_staging.v_venta_transformada
WHERE motivo_rechazo IS NOT NULL
UNION ALL
SELECT 'total en Staging',
       COUNT(*),
       SUM(cantidad * precio_unidad)
FROM jardineria_staging.stg_detalle_pedido;