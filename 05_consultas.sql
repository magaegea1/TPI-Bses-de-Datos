-- ============================================
-- 05_consultas.sql
-- Consultas avanzadas del TPI - Food Store
-- ============================================

USE tpi_bd;

-- ============================================
-- 1) CONSULTA CON JOIN MÚLTIPLE
-- Reporte de pedidos con total por usuario
-- ============================================

SELECT
    p.id_pedido,
    u.nombre,
    u.apellido,
    SUM(d.subtotal) AS total_pedido
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN detalle_pedido d ON p.id_pedido = d.id_pedido
GROUP BY p.id_pedido;

-- ============================================
-- 2) CONSULTA CON GROUP BY + HAVING
-- Categorías con más de 5 productos
-- ============================================

SELECT
    c.nombre AS categoria,
    COUNT(pr.id_producto) AS cantidad_productos
FROM producto pr
JOIN categoria c ON pr.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING COUNT(pr.id_producto) > 5;

-- ============================================
-- 3) CONSULTA CON SUBCONSULTA
-- Productos cuyo precio supera el promedio general
-- ============================================

SELECT
    nombre,
    precio
FROM producto
WHERE precio > (SELECT AVG(precio) FROM producto);

-- ============================================
-- 4) CONSULTA SOBRE VISTA (se crea en 06_vistas.sql)
-- ============================================

SELECT *
FROM vista_pedidos_detalle
ORDER BY id_pedido;
