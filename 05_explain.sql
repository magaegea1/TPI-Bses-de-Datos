-- ============================================
-- 05_explain.sql
-- EXPLAIN de consultas avanzadas del TPI
-- ============================================

USE tpi_bd;

-- ============================================
-- 1) EXPLAIN del JOIN múltiple
-- ============================================

EXPLAIN SELECT
    p.id_pedido,
    u.nombre,
    u.apellido,
    SUM(d.subtotal) AS total_pedido
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN detalle_pedido d ON p.id_pedido = d.id_pedido
GROUP BY p.id_pedido;

-- ============================================
-- 2) EXPLAIN del GROUP BY + HAVING
-- ============================================

EXPLAIN SELECT
    c.nombre AS categoria,
    COUNT(pr.id_producto) AS cantidad_productos
FROM producto pr
JOIN categoria c ON pr.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING COUNT(pr.id_producto) > 5;

-- ============================================
-- 3) EXPLAIN de la subconsulta
-- ============================================

EXPLAIN SELECT
    nombre,
    precio
FROM producto
WHERE precio > (SELECT AVG(precio) FROM producto);
