SELECT dimension, prueba, obtenido, esperado,
       IF(obtenido = esperado, 'APROBADA', 'FALLÓ') AS resultado
FROM (
  SELECT 'Completitud' AS dimension, 'Productos con proveedor nulo o vacío' AS prueba,
         (SELECT COUNT(*) FROM dm_jardineria.d_producto
          WHERE proveedor IS NULL OR proveedor = '') AS obtenido, 0 AS esperado
  UNION ALL
  SELECT 'Completitud', 'Clientes con país nulo o vacío',
         (SELECT COUNT(*) FROM dm_jardineria.d_cliente
          WHERE pais IS NULL OR pais = ''), 0
  UNION ALL
  SELECT 'Unicidad', 'Códigos de cliente repetidos',
         (SELECT COUNT(*) FROM (SELECT cod_cliente FROM dm_jardineria.d_cliente
                                GROUP BY cod_cliente HAVING COUNT(*) > 1) a), 0
  UNION ALL
  SELECT 'Unicidad', 'Códigos de producto repetidos',
         (SELECT COUNT(*) FROM (SELECT cod_producto FROM dm_jardineria.d_producto
                                GROUP BY cod_producto HAVING COUNT(*) > 1) b), 0
  UNION ALL
  SELECT 'Integridad referencial', 'Hechos sin cliente',
         (SELECT COUNT(*) FROM dm_jardineria.h_ventas h
          LEFT JOIN dm_jardineria.d_cliente c ON c.id_cliente = h.id_cliente
          WHERE c.id_cliente IS NULL), 0
  UNION ALL
  SELECT 'Integridad referencial', 'Hechos sin producto',
         (SELECT COUNT(*) FROM dm_jardineria.h_ventas h
          LEFT JOIN dm_jardineria.d_producto p ON p.id_producto = h.id_producto
          WHERE p.id_producto IS NULL), 0
  UNION ALL
  SELECT 'Integridad referencial', 'Hechos sin fecha',
         (SELECT COUNT(*) FROM dm_jardineria.h_ventas h
          LEFT JOIN dm_jardineria.d_fecha f ON f.id_fecha = h.id_fecha
          WHERE f.id_fecha IS NULL), 0
  UNION ALL
  SELECT 'Validez', 'Ventas con cantidad o precio menor o igual a cero',
         (SELECT COUNT(*) FROM dm_jardineria.h_ventas
          WHERE cantidad <= 0 OR precio_unitario <= 0), 0
  UNION ALL
  SELECT 'Validez', 'Fechas del calendario (días esperados 2006-2009)',
         (SELECT COUNT(*) FROM dm_jardineria.d_fecha),
         DATEDIFF('2009-12-31', '2006-01-01') + 1
  UNION ALL
  SELECT 'Consistencia', 'Importe distinto de cantidad por precio',
         (SELECT COUNT(*) FROM dm_jardineria.h_ventas
          WHERE importe_venta <> cantidad * precio_unitario), 0
  UNION ALL
  SELECT 'Consistencia', 'Líneas cargadas + rechazadas = líneas del origen',
         (SELECT COUNT(*) FROM dm_jardineria.h_ventas)
         + (SELECT COUNT(*) FROM jardineria_staging.v_venta_transformada
            WHERE motivo_rechazo IS NOT NULL),
         (SELECT COUNT(*) FROM jardineria.detalle_pedido)
  UNION ALL
  SELECT 'Consistencia', 'Importe cargado + rechazado = importe del origen',
         (SELECT SUM(importe_venta) FROM dm_jardineria.h_ventas)
         + (SELECT SUM(importe_venta) FROM jardineria_staging.v_venta_transformada
            WHERE motivo_rechazo IS NOT NULL),
         (SELECT SUM(cantidad * precio_unidad) FROM jardineria.detalle_pedido)
  UNION ALL
  SELECT 'Consistencia', 'Productos del Data Mart = productos de Staging',
         (SELECT COUNT(*) FROM dm_jardineria.d_producto),
         (SELECT COUNT(*) FROM jardineria_staging.stg_producto)
) t;