-- ============================================================================
-- Módulo 5: Consultas con JOINs
-- AUTOR: Paula Vazquez
-- ============================================================================

USE Ventas_Tech_DB;

-- ============================================================================
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Combina la tabla de ventas con clientes, productos y categorías.
-- Muestra la fecha, cliente, producto, categoría, ciudad, cantidad, precio unitario y total.
-- Obtener en una sola fila, como mínimo: fecha, identificación del cliente, descripción del producto, cantidad, precio unitario y total de venta.
-- ====

SELECT 
    ventas.fecha_venta AS fecha,
    clientes.id_cliente,
    clientes.nombre AS nombre_cliente,
    clientes.ciudad,
    productos.nombre_producto,
    categorias.nombre_categoria AS categoria,
    ventas.cantidad,
    ventas.precio_unitario,
    (ventas.cantidad * ventas.precio_unitario) AS total_venta
FROM ventas
INNER JOIN clientes 
    ON ventas.id_cliente = clientes.id_cliente
INNER JOIN productos 
    ON ventas.id_producto = productos.id_producto
INNER JOIN categorias 
    ON productos.id_categoria = categorias.id_categoria
ORDER BY ventas.fecha_venta ASC;



-- ============================================================================
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Identifico clientes registrados que aún no han realizado ninguna compra.--> me devuelve 0 filas , porque las 5 personas registradas hicieron una compra
-- ============================================================================

SELECT 
    clientes.nombre AS nombre_cliente,
    clientes.email,
    clientes.fecha_registro
FROM clientes
LEFT JOIN ventas 
    ON clientes.id_cliente = ventas.id_cliente
WHERE ventas.id_venta IS NULL;



-- ============================================================================
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Identifico productos que no tienen ninguna venta registrada--> me devuelve 0 filas, todos los productos registran ventas
-- ============================================================================

SELECT 
    productos.nombre_producto,
    categorias.nombre_categoria AS categoria,
    productos.precio
FROM productos
INNER JOIN categorias 
    ON productos.id_categoria = categorias.id_categoria
LEFT JOIN ventas 
    ON productos.id_producto = ventas.id_producto
WHERE ventas.id_venta IS NULL;



-- ================================================
-- CONSULTA 4:  canal (UNION ALL)
-- Genero el valor 'canal' (Online-Presencial)
-- ================================================

WITH VentasPorCanal AS (
    -- Ventas hasta el 10 de Marzo 'Online'
    SELECT 
        id_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    -- Ventas posteriores al 10 de Marzo 'Presencial'
    SELECT 
        id_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
)
SELECT 
    canal,
    COUNT(id_venta) AS cantidad_operaciones,
    SUM(total) AS total_facturado
FROM VentasPorCanal
GROUP BY canal;

========
--online 5 operaciones con un total de $3620
--presencial 5 operaciones con un total de $2824
