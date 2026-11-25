USE dm_jardineria;

SELECT p.nombre_producto,
       SUM(h.cantidad) AS unidades_vendidas
FROM h_ventas h
JOIN d_producto p ON p.id_producto = h.id_producto
GROUP BY p.id_producto, p.nombre_producto
ORDER BY unidades_vendidas DESC
LIMIT 5;

SELECT f.anio,
       SUM(h.importe_venta) AS ventas
FROM h_ventas h
JOIN d_fecha f ON f.id_fecha = h.id_fecha
GROUP BY f.anio
ORDER BY ventas DESC;

SELECT desc_categoria,
       COUNT(*) AS productos
FROM d_producto
GROUP BY desc_categoria
ORDER BY productos DESC;