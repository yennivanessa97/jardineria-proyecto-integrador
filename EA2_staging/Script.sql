CREATE DATABASE jardineria_staging
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jardineria_staging;

-- creación tabla staging cliente 
CREATE TABLE stg_cliente (
  ID_cliente      INT         NOT NULL,
  nombre_cliente  VARCHAR(50) NOT NULL,
  ciudad          VARCHAR(50) NOT NULL,
  region          VARCHAR(50) NULL,
  pais            VARCHAR(50) NULL,
  fecha_carga     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- carga de datos desde la bd Jardinería 
INSERT INTO stg_cliente (ID_cliente, nombre_cliente, ciudad, region, pais)
SELECT ID_cliente, nombre_cliente, ciudad, region, pais
FROM jardineria.cliente;

SELECT COUNT(*) FROM stg_cliente;
SELECT * FROM stg_cliente LIMIT 5;

USE jardineria_staging;

CREATE TABLE stg_pedido (
  ID_pedido     INT          NOT NULL,
  fecha_pedido  DATE         NOT NULL,
  estado        VARCHAR(15)  NOT NULL,
  ID_cliente    INT          NOT NULL,
  fecha_carga   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO stg_pedido (ID_pedido, fecha_pedido, estado, ID_cliente)
SELECT ID_pedido, fecha_pedido, estado, ID_cliente
FROM jardineria.pedido;

CREATE TABLE stg_detalle_pedido (
  ID_detalle_pedido INT           NOT NULL,
  ID_pedido         INT           NOT NULL,
  ID_producto       INT           NOT NULL,
  cantidad          INT           NOT NULL,
  precio_unidad     DECIMAL(15,2) NOT NULL,
  fecha_carga       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO stg_detalle_pedido
  (ID_detalle_pedido, ID_pedido, ID_producto, cantidad, precio_unidad)
SELECT ID_detalle_pedido, ID_pedido, ID_producto, cantidad, precio_unidad
FROM jardineria.detalle_pedido;

CREATE TABLE stg_producto (
  ID_producto     INT         NOT NULL,
  CodigoProducto  VARCHAR(15) NOT NULL,
  nombre          VARCHAR(70) NOT NULL,
  Categoria       INT         NOT NULL,
  proveedor       VARCHAR(50) NULL,
  fecha_carga     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO stg_producto (ID_producto, CodigoProducto, nombre, Categoria, proveedor)
SELECT ID_producto, CodigoProducto, nombre, Categoria, proveedor
FROM jardineria.producto;

CREATE TABLE stg_categoria_producto (
  Id_Categoria    INT         NOT NULL,
  Desc_Categoria  VARCHAR(50) NOT NULL,
  fecha_carga     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO stg_categoria_producto (Id_Categoria, Desc_Categoria)
SELECT Id_Categoria, Desc_Categoria
FROM jardineria.Categoria_producto;

-- conteo de las tablas 
SELECT 'stg_pedido' AS tabla, COUNT(*) AS registros FROM stg_pedido
UNION ALL SELECT 'stg_detalle_pedido', COUNT(*) FROM stg_detalle_pedido
UNION ALL SELECT 'stg_producto', COUNT(*) FROM stg_producto
UNION ALL SELECT 'stg_categoria_producto', COUNT(*) FROM stg_categoria_producto;SELECT COUNT(*)                 AS total_clientes,
       COUNT(region)            AS con_region,
       COUNT(linea_direccion2)  AS con_direccion2
FROM cliente;
SELECT nombre_cliente, telefono, COUNT(*) AS veces
FROM cliente
GROUP BY nombre_cliente, telefono
HAVING COUNT(*) > 1;
