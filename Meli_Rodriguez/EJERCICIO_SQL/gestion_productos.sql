
CREATE TABLE cities(
                       id_city SERIAL PRIMARY KEY,
                       city VARCHAR (30)
);

INSERT INTO cities (city)
VALUES ('Bogota'),
       ('Medellin'),
       ('Barranquilla'),
       ('Cali'),
       ('Bucaramanga'),
       ('Cartagena');

CREATE TABLE clientes(
                         id_costumer SERIAL PRIMARY KEY,
                         costumer VARCHAR(50),
                         id_city INT, --Crear el id
                         FOREIGN KEY (id_city)
                             REFERENCES cities(id_city)
);

INSERT INTO clientes(costumer, id_city)
VALUES ('Constructora Andina SAS', 1),
       ('Ferretería El Tornillo', 2),
       ('Inversiones Caribe SAS', 3),
       ('Metalúrgica del Norte', 4),
       ('Obras y Vías SAS',5),
       ('Constructora Pacífico', 4),
       ('Ferretería Central', 5);

CREATE TABLE categorias(
                           id_categoria SERIAL PRIMARY KEY,
                           categoria VARCHAR(20)
);

INSERT INTO categorias(categoria)
VALUES ('Construcción'),
       ('Agregados'),
       ('Herramientas'),
       ('Pinturas');


CREATE TABLE representante_ventas(
                                     id_salesrepre SERIAL PRIMARY KEY,
                                     salesrepre VARCHAR(30),
                                     sucursal VARCHAR(20),
                                     id_city INT,
                                     FOREIGN KEY (id_city)
                                         REFERENCES cities(id_city)
);

INSERT INTO representante_ventas(salesrepre, sucursal, id_city)
VALUES ('Carlos Pérez','Centro', 1 ),
       ('Laura Gómez', 'Norte', 2 ),
       ('Andrés Ruiz', 'Costa',3 ),
       ('Diana Torres', 'Occidente', 4),
       ('Miguel Castro', 'Oriente', 6);

CREATE TABLE productos(
                          id_producto SERIAL PRIMARY KEY,
                          product_name VARCHAR(50),
                          precio_unitario INT,
                          id_categoria INT,
                          FOREIGN KEY (id_categoria)
                              REFERENCES categorias(id_categoria)
);

INSERT INTO productos(product_name, id_categoria, precio_unitario)
VALUES ('Cemento Gris 50kg', 1, 32000),
       ('Varilla 3/8', 1, 28000),
       ('Taladro Industrial', 3, 450000),
       ('Pintura Blanca 5GL', 4, 95000),
       ('Rodillo Profesional', 4, 18000),
       ('Disco de Corte', 3, 12000),
       ('Broca SDS', 3, 15000),
       ('Arena Lavada', 2, 25000),
       ('Grava Triturada', 2, 27000);

CREATE TABLE metodos_pago(
                             id_metodo_pago SERIAL PRIMARY KEY,
                             metodo_pago VARCHAR(30)
);
INSERT INTO metodos_pago(metodo_pago)
VALUES ('Transferencia'),
       ('Tarjeta'),
       ('Crédito'),
       ('Efectivo');

CREATE TABLE detalle_factura(
                                id_factura SERIAL PRIMARY KEY,
                                numero_factura VARCHAR(30),
                                fecha_factura DATE,
                                id_metodo_pago INT
);

INSERT INTO detalle_factura(numero_factura, fecha_factura, id_metodo_pago)
VALUES ('FAC-2001', '2026-05-01', 1),
       ('FAC-2002', '2026-05-02', 2),
       ('FAC-2003', '2026-05-03', 3),
       ('FAC-2004', '2026-05-04', 4),
       ('FAC-2005', '2026-05-05', 1),
       ('FAC-2006', '2026-05-06', 2),
       ('FAC-2007', '2026-05-07', 3),
       ('FAC-2008', '2026-05-08', 1),
       ('FAC-2009', '2026-05-09', 2);

CREATE TABLE cliente_repre(
                              id_cliente_repre SERIAL PRIMARY KEY,
                              id_costumer INT,
                              id_salesrepre INT,
                              FOREIGN KEY (id_costumer)
                                  REFERENCES clientes (id_costumer),
                              FOREIGN KEY (id_salesrepre)
                                  REFERENCES representante_ventas(id_salesrepre)
);

INSERT INTO cliente_repre(id_costumer, id_salesrepre)
VALUES ( 1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 1),
       (6, 2),
       (7, 5);

CREATE TABLE facturacion (
                             id_facturacion SERIAL PRIMARY KEY,
                             id_producto INT REFERENCES  productos (id_producto) NOT NULL ,
                             cantidad INT,
                             id_cliente_repre INT REFERENCES cliente_repre (id_cliente_repre) NOT NULL, --Otra manera de colocar una foreing key,
                             id_factura INT REFERENCES detalle_factura(id_factura) NOT NULL

);

INSERT INTO facturacion(id_producto, cantidad, id_cliente_repre, id_factura)
VALUES (1,	100	,1,1),
       (2,	50,	1	,1),
       (3,	3,	2,	2),
       (4,	20,	3,	3),
       (5,	10,	3,	3),
       (6,	40, 4,	4),
       (1,	120,	1,	5),
       (7,	25,	3	,6),
       (8,	60,	5	,7),
       (9,	80,	5	,7),
       (4,	15,	6	,8),
       (3,	2,	7	,9);

--Listar todos los clientes
SELECT costumer FROM clientes;

--Mostrar todos los productos con su categoría.
SELECT p.product_name,c.categoria FROM productos p JOIN categorias c ON p.id_categoria  = c.id_categoria;
-- Tener en cuenta los tipos de dato!!!!!

--Consultar las facturas emitidas por ciudad.
SELECT  df.numero_factura, ci.city FROM facturacion f
                                            JOIN cliente_repre cl ON f.id_cliente_repre = cl.id_cliente_repre
                                            JOIN representante_ventas rv ON cl.id_cliente_repre = rv.id_salesrepre
                                            JOIN cities ci ON rv.id_city = ci.id_city
                                            JOIN detalle_factura df ON f.id_factura = df.id_factura;

--Obtener el total vendido por cliente. -- TERMINAR!!
SELECT cl.costumer, SUM(p.precio_unitario * f.cantidad) AS total_vendido
FROM facturacion f
         JOIN productos p ON f.id_producto = p.id_producto
         JOIN cliente_repre cr ON f.id_cliente_repre = cr.id_cliente_repre
         JOIN clientes cl ON cr.id_costumer = cl.id_costumer
GROUP BY cl.costumer
ORDER BY total_vendido DESC;
-- Obtener el total vendido por categoría.
SELECT cat.categoria, SUM(p.precio_unitario * f.cantidad) AS total_vendido
FROM facturacion f
         JOIN productos p ON f.id_producto = p.id_producto
         JOIN categorias cat ON p.id_categoria = cat.id_categoria
GROUP BY cat.categoria
ORDER BY total_vendido DESC;


-- Facturas atendidas por asesor comercial
SELECT DISTINCT rv.salesrepre, df.numero_factura
FROM facturacion f
         JOIN cliente_repre cr ON f.id_cliente_repre = cr.id_cliente_repre
         JOIN representante_ventas rv ON cr.id_salesrepre = rv.id_salesrepre
         JOIN detalle_factura df ON f.id_factura = df.id_factura
ORDER BY rv.salesrepre;

-- PRODUCTOS MAS VENDIDOS POR UNIDAD
SELECT p.product_name, SUM(f.cantidad) AS total_unidades
FROM facturacion f
         JOIN productos p ON f.id_producto = p.id_producto
GROUP BY p.product_name
ORDER BY total_unidades DESC;

--sucursales y cantidad de facturas gestionadas
SELECT rv.sucursal, COUNT(DISTINCT df.id_factura) AS cantidad_facturas
FROM facturacion f
         JOIN cliente_repre cr ON f.id_cliente_repre = cr.id_cliente_repre
         JOIN representante_ventas rv ON cr.id_salesrepre = rv.id_salesrepre
         JOIN detalle_factura df ON f.id_factura = df.id_factura
GROUP BY rv.sucursal
ORDER BY cantidad_facturas DESC;

-- Ventas realizadas mediante un método de pago específico (ejemplo: 'Transferencia')
SELECT df.numero_factura, mp.metodo_pago, cl.costumer,
       SUM(p.precio_unitario * f.cantidad) AS total
FROM facturacion f
         JOIN detalle_factura df ON f.id_factura = df.id_factura
         JOIN metodos_pago mp ON df.id_metodo_pago = mp.id_metodo_pago
         JOIN productos p ON f.id_producto = p.id_producto
         JOIN cliente_repre cr ON f.id_cliente_repre = cr.id_cliente_repre
         JOIN clientes cl ON cr.id_costumer = cl.id_costumer
WHERE mp.metodo_pago = 'Transferencia'
GROUP BY df.numero_factura, mp.metodo_pago, cl.costumer;

-- 10. Valor total de cada factura
SELECT df.numero_factura, SUM(p.precio_unitario * f.cantidad) AS valor_total
FROM facturacion f
         JOIN productos p ON f.id_producto = p.id_producto
         JOIN detalle_factura df ON f.id_factura = df.id_factura
GROUP BY df.numero_factura
ORDER BY df.numero_factura;