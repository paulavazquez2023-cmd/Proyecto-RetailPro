=====================================
--Pre-entrega: Consultas SQL de negocio

--Título: Extrayendo métricas clave con SQL

-- Autor: Paula Vazquez

--Fecha: 4 de Octubre de 2026
========================================


USE Ventas_Tech_DB;

-- CONSULTA 1: Resumen ejecutivo mensual
==============
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- CONSULTA 2: Ranking de productos (Top 5)
=============
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

-- CONSULTA 3: Clientes recurrentes
============
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- CONSULTA 4: Meses por encima / por debajo del promedio
=============
WITH VentasMensuales AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM VentasMensuales) 
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS relacion_promedio
FROM VentasMensuales
ORDER BY mes;


--calculo el total facturado global
SELECT SUM(cantidad * precio_unitario) AS total_facturado_global
FROM ventas;
===========================
--Hallazgos
--1.El producto id_producto = 1 (Laptop Pro 15) 
   lidera el ranking de facturación, generando $3600 de los $6444  
   totales del mes. Eso representa  55,87% de la facturación global vendiendo 3 unidades de las Laptop. 
   --Clientes recurrentes:  
   los 5 clientes registrados realizaron 2 pedidos cada uno con un total de ventas de 10.
   --Concentracion de ventas: 
   el mes 3 concentra todas las ventas registradas.
