-- ============================================
-- 02_catalogos.sql
-- Datos semilla para tablas catálogo
-- ============================================

USE tpi_bd;

-- ============================================
-- CATEGORÍAS (8 registros)
-- ============================================

INSERT INTO categoria (nombre, descripcion, eliminado, createdAt) VALUES
('Bebidas', 'Bebidas frías y calientes', 0, NOW()),
('Snacks', 'Snacks dulces y salados', 0, NOW()),
('Lácteos', 'Productos lácteos', 0, NOW()),
('Carnes', 'Cortes y embutidos', 0, NOW()),
('Verduras', 'Vegetales frescos', 0, NOW()),
('Frutas', 'Frutas de estación', 0, NOW()),
('Panadería', 'Pan y facturas', 0, NOW()),
('Congelados', 'Productos congelados', 0, NOW());
