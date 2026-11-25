USE jardineria_staging;

-- Vista de clientes
CREATE OR REPLACE VIEW v_cliente_transformado AS
SELECT c.ID_cliente                              AS cod_cliente,
       TRIM(c.nombre_cliente)                    AS nombre_cliente,
       TRIM(c.ciudad)                            AS ciudad,
       COALESCE(r.region_estandar, 'Sin región') AS region,
       TRIM(c.pais)                              AS pais
FROM stg_cliente c
LEFT JOIN cat_region r
       ON r.region_origen = TRIM(c.region)
WHERE c.ID_cliente = (SELECT MIN(c2.ID_cliente)
                      FROM stg_cliente c2
                      WHERE c2.nombre_cliente = c.nombre_cliente);

SELECT COUNT(*)                   AS clientes,
       SUM(region = 'Sin región') AS sin_region,
       SUM(region = 'Canarias')   AS canarias
FROM v_cliente_transformado;

-- vista de productos

CREATE OR REPLACE VIEW v_producto_transformado AS
SELECT p.ID_producto     AS id_origen,
       p.CodigoProducto  AS cod_producto,
       TRIM(
         REPLACE(
           REPLACE(p.nombre,
                   CONVERT(UNHEX('C382C2AA') USING utf8mb4),
                   CONVERT(UNHEX('C2AA') USING utf8mb4)),
           CONVERT(UNHEX('C383E2809C') USING utf8mb4),
           CONVERT(UNHEX('C393') USING utf8mb4))
       ) AS nombre_producto,
       TRIM(p.proveedor)       AS proveedor,
       cat.Desc_Categoria      AS desc_categoria
FROM stg_producto p
LEFT JOIN stg_categoria_producto cat
       ON cat.Id_Categoria = p.Categoria;

-- vista de ventas
CREATE OR REPLACE VIEW v_venta_transformada AS
SELECT d.ID_pedido                      AS num_pedido,
       p.fecha_pedido                   AS fecha,
       p.ID_cliente                     AS cod_cliente,
       vp.cod_producto                  AS cod_producto,
       d.cantidad                       AS cantidad,
       d.precio_unidad                  AS precio_unitario,
       d.cantidad * d.precio_unidad     AS importe_venta,
       CASE
           WHEN p.ID_pedido IS NULL
                THEN 'Pedido no existe'
           WHEN p.estado COLLATE utf8mb4_bin = 'Rechazado'
                THEN 'Pedido rechazado'
           WHEN cal.fecha IS NULL
                THEN 'Fecha inexistente o fuera del calendario'
           WHEN vc.cod_cliente IS NULL
                THEN 'Cliente no existe'
           WHEN vp.id_origen IS NULL
                THEN 'Producto no existe'
           WHEN d.cantidad <= 0
                THEN 'Cantidad cero o negativa'
       END AS motivo_rechazo
FROM stg_detalle_pedido d
LEFT JOIN stg_pedido p               ON p.ID_pedido = d.ID_pedido
LEFT JOIN calendario cal             ON cal.fecha = p.fecha_pedido
LEFT JOIN v_cliente_transformado vc  ON vc.cod_cliente = p.ID_cliente
LEFT JOIN v_producto_transformado vp ON vp.id_origen = d.ID_producto;

SELECT COALESCE(motivo_rechazo, 'Válida') AS resultado,
       COUNT(*) AS lineas,
       SUM(importe_venta) AS importe
FROM v_venta_transformada
GROUP BY motivo_rechazo;