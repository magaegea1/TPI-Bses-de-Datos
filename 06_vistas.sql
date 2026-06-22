-- ============================================
-- 06_vistas.sql
-- Vistas del TPI - Food Store
-- ============================================

USE tpi_bd;

-- ============================================
-- VISTA 1: vista_pedidos_detalle
-- Reporte combinado de pedidos, usuarios y productos
-- ============================================

CREATE OR REPLACE VIEW vista_pedidos_detalle AS
SELECT
    p.id_pedido,
    u.mail,
    pr.nombre AS producto,
    d.cantidad,
    d.subtotal
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN detalle_pedido d ON p.id_pedido = d.id_pedido
JOIN producto pr ON d.id_producto = pr.id_producto;

-- ============================================
-- VISTA 2: vista_usuarios_publicos
-- Oculta contraseña y campos internos
-- ============================================

CREATE OR REPLACE VIEW vista_usuarios_publicos AS
SELECT
    id_usuario,
    nombre,
    apellido,
    mail,
    celular,
    rol
FROM usuario
WHERE eliminado = 0;

-- ============================================
-- VISTA 3: vista_pedidos_publicos
-- Vista segura sin datos sensibles
-- ============================================

CREATE OR REPLACE VIEW vista_pedidos_publicos AS
SELECT
    p.id_pedido,
    u.mail AS usuario,
    p.fecha,
    p.forma_pago,
    p.estado,
    p.total
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
WHERE p.eliminado = 0;
