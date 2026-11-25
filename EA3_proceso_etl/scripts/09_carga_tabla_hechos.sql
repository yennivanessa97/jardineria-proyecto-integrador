USE dm_jardineria;

TRUNCATE TABLE h_ventas;

INSERT INTO h_ventas
       (id_producto, id_fecha, id_cliente, num_pedido,
        cantidad, precio_unitario, importe_venta)
SELECT dp.id_producto,
       df.id_fecha,
       dc.id_cliente,
       v.num_pedido,
       v.cantidad,
       v.precio_unitario,
       v.importe_venta
FROM jardineria_staging.v_venta_transformada v
JOIN d_producto dp ON dp.cod_producto = v.cod_producto COLLATE utf8mb4_0900_ai_ci
JOIN d_fecha    df ON df.fecha        = v.fecha
JOIN d_cliente  dc ON dc.cod_cliente  = v.cod_cliente
WHERE v.motivo_rechazo IS NULL;

SELECT COUNT(*)           AS registros,
       SUM(cantidad)      AS unidades,
       SUM(importe_venta) AS importe_total
FROM h_ventas;