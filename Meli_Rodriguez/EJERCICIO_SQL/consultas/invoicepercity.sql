SELECT  df.numero_factura, ci.city FROM facturacion f
JOIN cliente_repre cl ON f.id_cliente_repre = cl.id_cliente_repre
JOIN representante_ventas rv ON cl.id_cliente_repre = rv.id_salesrepre
JOIN cities ci ON rv.id_city = ci.id_city
JOIN detalle_factura df ON f.id_factura = df.id_factura;