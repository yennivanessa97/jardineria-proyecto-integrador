USE dm_jardineria;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE h_ventas;
TRUNCATE TABLE d_cliente;
TRUNCATE TABLE d_producto;
TRUNCATE TABLE d_fecha;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO d_cliente (cod_cliente, nombre_cliente, ciudad, region, pais)
SELECT cod_cliente, nombre_cliente, ciudad, region, pais
FROM jardineria_staging.v_cliente_transformado;

INSERT INTO d_producto (cod_producto, nombre_producto, proveedor, desc_categoria)
SELECT cod_producto, nombre_producto, proveedor, desc_categoria
FROM jardineria_staging.v_producto_transformado;

INSERT INTO d_fecha (id_fecha, fecha, anio, trimestre, mes, desc_mes, dia, desc_dia)
SELECT CAST(DATE_FORMAT(fecha, '%Y%m%d') AS UNSIGNED),
       fecha, anio, trimestre, mes, desc_mes, dia, desc_dia
FROM jardineria_staging.calendario;

SELECT 'd_cliente' AS tabla, COUNT(*) AS registros FROM d_cliente
UNION ALL SELECT 'd_producto', COUNT(*) FROM d_producto
UNION ALL SELECT 'd_fecha', COUNT(*) FROM d_fecha;