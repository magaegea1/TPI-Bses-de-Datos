-- ============================================
-- 04_indices.sql
-- Índices para optimizar consultas del TPI
-- ============================================

USE tpi_bd;

-- ============================================
-- ÍNDICE: producto.id_categoria
-- Mejora consultas por categoría
-- ============================================

CREATE INDEX idx_producto_categoria 
ON producto(id_categoria);

-- ============================================
-- ÍNDICE: pedido.id_usuario
-- Mejora consultas por usuario
-- ============================================

CREATE INDEX idx_pedido_usuario 
ON pedido(id_usuario);

-- ============================================
-- ÍNDICE: detalle_pedido.id_producto
-- Mejora consultas por producto
-- ============================================

CREATE INDEX idx_detalle_producto 
ON detalle_pedido(id_producto);

-- ============================================
-- ÍNDICE: detalle_pedido.id_pedido
-- Mejora JOIN entre pedido y detalle
-- ============================================

CREATE INDEX idx_detalle_pedido 
ON detalle_pedido(id_pedido);
