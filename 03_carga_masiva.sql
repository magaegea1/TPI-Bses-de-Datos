-- ============================================
-- 03_carga_masiva.sql
-- Carga masiva de datos para el TPI - Food Store
-- ============================================

USE tpi_bd;

-- ============================================
-- USUARIOS MASIVOS (200 registros)
-- ============================================

INSERT INTO usuario (nombre, apellido, mail, celular, contraseña, rol, eliminado, createdAt)
SELECT
    CONCAT('Usuario', n),
    CONCAT('Apellido', n),
    CONCAT('user', n, '@mail.com'),
    CONCAT('11', LPAD(n, 8, '0')),
    'pass123',
    'USUARIO',
    0,
    NOW()
FROM (
    SELECT ROW_NUMBER() OVER () AS n
    FROM information_schema.columns LIMIT 200
) AS t;

-- ============================================
-- PRODUCTOS MASIVOS (2000+ registros)
-- ============================================

INSERT INTO producto (nombre, descripcion, precio, stock, imagen, disponible, id_categoria, eliminado, createdAt)
SELECT
    CONCAT('Producto ', n),
    'Descripción generada automáticamente',
    ROUND(RAND() * 2000, 2),
    FLOOR(RAND() * 200),
    NULL,
    1,
    FLOOR(1 + RAND() * 8), -- categorías 1 a 8
    0,
    NOW()
FROM (
    SELECT ROW_NUMBER() OVER () AS n
    FROM information_schema.columns, information_schema.tables
    LIMIT 2000
) AS t;

-- ============================================
-- PEDIDOS MASIVOS (5000+ registros)
-- ============================================

INSERT INTO pedido (id_usuario, fecha, forma_pago, estado, total, eliminado, createdAt)
SELECT
    u.id_usuario,
    NOW() - INTERVAL FLOOR(RAND() * 30) DAY,
    ELT(FLOOR(1 + RAND()*3), 'EFECTIVO','TARJETA','TRANSFERENCIA'),
    ELT(FLOOR(1 + RAND()*4), 'PENDIENTE','CONFIRMADO','TERMINADO','CANCELADO'),
    0,
    0,
    NOW()
FROM usuario u
JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) r
ON RAND() < 0.3;

-- ============================================
-- DETALLES MASIVOS (20.000+ registros)
-- ============================================

INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal, eliminado, createdAt)
SELECT
    p.id_pedido,
    FLOOR(1 + RAND() * 2000), -- productos existentes
    FLOOR(1 + RAND() * 5),
    0,
    0,
    NOW()
FROM pedido p
JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) r
ON RAND() < 0.8;

-- ============================================
-- CALCULAR SUBTOTALES Y TOTALES
-- ============================================

UPDATE detalle_pedido d
JOIN producto pr ON d.id_producto = pr.id_producto
SET d.subtotal = d.cantidad * pr.precio;

UPDATE pedido p
JOIN (
    SELECT id_pedido, SUM(subtotal) AS total
    FROM detalle_pedido
    GROUP BY id_pedido
) x ON p.id_pedido = x.id_pedido
SET p.total = x.total;
