-- Crear la base de datos del TPI
CREATE DATABASE tpi_bd;
USE tpi_bd;

-- Tabla de categorías
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    createdAt DATETIME NOT NULL DEFAULT NOW()
);

-- Tabla de usuarios
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    mail VARCHAR(100) NOT NULL UNIQUE,
    celular VARCHAR(20),
    contraseña VARCHAR(100) NOT NULL,
    rol ENUM('ADMIN','USUARIO') NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    createdAt DATETIME NOT NULL DEFAULT NOW()
);

-- Tabla de productos
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    imagen VARCHAR(200),
    disponible BOOLEAN NOT NULL DEFAULT 1,
    id_categoria INT NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    createdAt DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- Tabla de pedidos
CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha DATETIME NOT NULL,
    forma_pago ENUM('EFECTIVO','TARJETA','TRANSFERENCIA') NOT NULL,
    estado ENUM('PENDIENTE','CONFIRMADO','TERMINADO','CANCELADO') NOT NULL,
    total DECIMAL(10,2),
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    createdAt DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabla de detalles del pedido
CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    subtotal DECIMAL(10,2) NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    createdAt DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Inserción correcta en usuario
INSERT INTO usuario (nombre, apellido, mail, celular, contraseña, rol)
VALUES ('Ana', 'Gomez', 'ana@mail.com', '123456789', 'pass123', 'USUARIO');

-- ❌ ERROR 1: Violación de UNIQUE (mail duplicado)
INSERT INTO usuario (nombre, apellido, mail, celular, contraseña, rol)
VALUES ('Juan', 'Perez', 'ana@mail.com', '987654321', 'pass456', 'USUARIO');

-- ❌ ERROR 2: Violación de CHECK (precio negativo)
INSERT INTO producto (nombre, descripcion, precio, stock, id_categoria)
VALUES ('Coca Cola', 'Gaseosa', -10, 5, 1);

-- ❌ ERROR 3: Violación de FOREIGN KEY (categoría inexistente)
INSERT INTO producto (nombre, descripcion, precio, stock, id_categoria)
VALUES ('Pepsi', 'Gaseosa', 500, 10, 999);

-- ❌ ERROR 4: Violación de NOT NULL (id_usuario no puede ser NULL)
INSERT INTO pedido (id_usuario, fecha, forma_pago, estado)
VALUES (NULL, NOW(), 'EFECTIVO', 'PENDIENTE');

-- Verificaciones de integridad
SELECT COUNT(*) AS productos_con_categoria_invalida
FROM producto p
LEFT JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE c.id_categoria IS NULL;

SELECT COUNT(*) AS pedidos_huerfanos
FROM pedido pe
LEFT JOIN usuario u ON pe.id_usuario = u.id_usuario
WHERE u.id_usuario IS NULL;

SELECT COUNT(*) AS detalles_sin_pedido
FROM detalle_pedido d
LEFT JOIN pedido p ON d.id_pedido = p.id_pedido
WHERE p.id_pedido IS NULL;

SELECT COUNT(*) AS detalles_sin_producto
FROM detalle_pedido d
LEFT JOIN producto pr ON d.id_producto = pr.id_producto
WHERE pr.id_producto IS NULL;

SELECT COUNT(*) AS precios_invalidos
FROM producto
WHERE precio < 0;

/* ============================
   TABLA SEMILLA: CATEGORIA
   ============================ */
INSERT INTO categoria (nombre, descripcion, eliminado, createdAt) VALUES
('Bebidas', 'Bebidas frías y calientes', 0, NOW()),
('Snacks', 'Snacks dulces y salados', 0, NOW()),
('Lácteos', 'Productos lácteos', 0, NOW()),
('Carnes', 'Cortes y embutidos', 0, NOW()),
('Verduras', 'Vegetales frescos', 0, NOW()),
('Frutas', 'Frutas de estación', 0, NOW()),
('Panadería', 'Pan y facturas', 0, NOW()),
('Congelados', 'Productos congelados', 0, NOW());

/* ============================
   TABLA SEMILLA: USUARIO
   ============================ */
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

/* ============================
   PRODUCTOS MASIVOS (2000+)
   ============================ */
INSERT INTO producto (nombre, descripcion, precio, stock, imagen, disponible, id_categoria, eliminado, createdAt)
SELECT 
    CONCAT('Producto ', n),
    'Descripción generada automáticamente',
    ROUND(RAND() * 2000, 2),
    FLOOR(RAND() * 200),
    NULL,
    1,
    FLOOR(1 + RAND() * 8),  -- categorías 1 a 8
    0,
    NOW()
FROM (
    SELECT ROW_NUMBER() OVER () AS n
    FROM information_schema.columns, information_schema.tables
    LIMIT 2000
) AS t;

/* ============================
   DETALLES MASIVOS (20.000+)
   ============================ */
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal, eliminado, createdAt)
SELECT 
    p.id_pedido,
    FLOOR(1 + RAND() * 2000),  -- productos existentes
    FLOOR(1 + RAND() * 5),
    0,
    0,
    NOW()
FROM pedido p
JOIN (
    SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
) r
ON RAND() < 0.8;


/* ============================
   PEDIDOS MASIVOS (5000+)
   ============================ */
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
JOIN (
    SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
) r
ON RAND() < 0.3;  -- genera entre 5 y 20 pedidos por usuario

/* ============================
   CALCULAR TOTAL DE PEDIDOS
   ============================ */
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


/* ============================================================
   ETAPA 3 – CONSULTAS AVANZADAS Y REPORTES
   Sistema: Food Store
   ============================================================ */


/* ============================================================
   1) CONSULTA CON JOIN MÚLTIPLE
   Reporte de pedidos con el total por usuario
   ============================================================ */

SELECT 
    p.id_pedido,
    u.nombre,
    u.apellido,
    SUM(d.subtotal) AS total_pedido
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN detalle_pedido d ON p.id_pedido = d.id_pedido
GROUP BY p.id_pedido;


/* ============================================================
   2) CONSULTA CON GROUP BY + HAVING
   Categorías con más de 5 productos
   ============================================================ */

SELECT 
    c.nombre AS categoria,
    COUNT(pr.id_producto) AS cantidad_productos
FROM producto pr
JOIN categoria c ON pr.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING COUNT(pr.id_producto) > 5;


/* ============================================================
   3) CONSULTA CON SUBCONSULTA
   Productos cuyo precio supera el promedio general
   ============================================================ */

SELECT 
    nombre,
    precio
FROM producto
WHERE precio > (SELECT AVG(precio) FROM producto);


/* ============================================================
   4) CREACIÓN DE UNA VISTA ÚTIL
   Vista para reportes combinados de pedidos, usuarios y productos
   ============================================================ */

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


/* ============================================================
   5) CONSULTA SOBRE LA VISTA
   (Ejemplo de uso práctico)
   ============================================================ */

SELECT *
FROM vista_pedidos_detalle
ORDER BY id_pedido;


/* ============================================================
   6) ANÁLISIS DE RENDIMIENTO CON EXPLAIN
   ============================================================ */

-- EXPLAIN de la consulta de JOIN múltiple
EXPLAIN SELECT 
    p.id_pedido,
    u.nombre,
    u.apellido,
    SUM(d.subtotal) AS total_pedido
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN detalle_pedido d ON p.id_pedido = d.id_pedido
GROUP BY p.id_pedido;

-- EXPLAIN de la consulta con GROUP BY + HAVING
EXPLAIN SELECT 
    c.nombre AS categoria,
    COUNT(pr.id_producto) AS cantidad_productos
FROM producto pr
JOIN categoria c ON pr.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING COUNT(pr.id_producto) > 5;

-- EXPLAIN de la subconsulta
EXPLAIN SELECT 
    nombre,
    precio
FROM producto
WHERE precio > (SELECT AVG(precio) FROM producto);


/* ============================================================
   7) ÍNDICES RECOMENDADOS PARA OPTIMIZAR CONSULTAS
   (Opcional pero recomendado para el TFI)
   ============================================================ */

-- Índice para acelerar búsquedas por categoría
CREATE INDEX idx_producto_categoria ON producto(id_categoria);

-- Índice para acelerar búsquedas por usuario en pedidos
CREATE INDEX idx_pedido_usuario ON pedido(id_usuario);

-- Índice para acelerar búsquedas por producto en detalle
CREATE INDEX idx_detalle_producto ON detalle_pedido(id_producto);

-- Índice para acelerar búsquedas por pedido en detalle
CREATE INDEX idx_detalle_pedido ON detalle_pedido(id_pedido);

/* ============================================================
   ETAPA 4 – SEGURIDAD E INTEGRIDAD
   1) CREACIÓN DE USUARIO CON PRIVILEGIOS MÍNIMOS
   ============================================================ */

-- Crear usuario con contraseña
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'app123';

-- Quitarle todos los privilegios por seguridad
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app_user'@'localhost';

-- Otorgar permisos mínimos:
-- Puede ver SOLO las vistas públicas (que crearemos más abajo)
-- Puede insertar pedidos (operación típica de una app)
GRANT SELECT ON tpi_bd.vista_usuarios_publicos TO 'app_user'@'localhost';
GRANT SELECT ON tpi_bd.vista_pedidos_publicos TO 'app_user'@'localhost';
GRANT INSERT ON tpi_bd.pedido TO 'app_user'@'localhost';

-- Aplicar cambios
FLUSH PRIVILEGES;


/* ============================================================
   2) VISTAS PARA OCULTAR INFORMACIÓN SENSIBLE
   ============================================================ */

-- Vista sin contraseña ni campos internos
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

-- Vista de pedidos sin datos internos ni claves sensibles
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

/* ============================================================
   3) PRUEBAS DE INTEGRIDAD
   ============================================================ */

-- ❌ ERROR 1: Violación de UNIQUE (mail duplicado)
INSERT INTO usuario (nombre, apellido, mail, celular, contraseña, rol)
VALUES ('Test', 'Duplicado', 'ana@mail.com', '111', '123', 'USUARIO');

-- ❌ ERROR 2: Violación de FOREIGN KEY (usuario inexistente)
INSERT INTO pedido (id_usuario, fecha, forma_pago, estado)
VALUES (99999, NOW(), 'EFECTIVO', 'PENDIENTE');

/* ============================================================
   4) CONSULTA SEGURA (ANTI-INYECCIÓN)
   Procedimiento almacenado SIN SQL dinámico
   ============================================================ */

DELIMITER $$

CREATE PROCEDURE buscar_usuario_seguro(IN p_mail VARCHAR(100))
BEGIN
    SELECT id_usuario, nombre, apellido, mail
    FROM usuario
    WHERE mail = p_mail;
END $$

DELIMITER ;

/* ============================================================
   5) PRUEBA DE INYECCIÓN SQL
   ============================================================ */

-- Intento malicioso típico:
CALL buscar_usuario_seguro("ana@mail.com' OR '1'='1");

/* ============================================================
   ETAPA 5 – CONCURRENCIA Y TRANSACCIONES
   Sistema: Food Store
   ============================================================ */

USE tpi_bd;

/* ============================================================
   1) SIMULACIÓN DE DEADLOCK (DOS SESIONES)
   ============================================================ */
-- SESIÓN 1
START TRANSACTION;
UPDATE pedido SET estado = 'PENDIENTE' WHERE id_pedido = 1;

-- SESIÓN 2
START TRANSACTION;
UPDATE detalle_pedido SET cantidad = cantidad + 1 WHERE id_pedido = 1;

-- SESIÓN 1 (segundo UPDATE, ahora sobre detalle_pedido)
UPDATE detalle_pedido SET cantidad = cantidad + 1 WHERE id_pedido = 1;

-- SESIÓN 2 (segundo UPDATE, ahora sobre pedido)
UPDATE pedido SET estado = 'CONFIRMADO' WHERE id_pedido = 1;

-- En uno de los dos UPDATE finales MySQL debería lanzar:
-- Error 1213: Deadlock found when trying to get lock

ROLLBACK;  -- en ambas sesiones para liberar

/* ============================================================
   2) TRANSACCIÓN CON MANEJO DE ERRORES Y RETRY (SQL PURO)
   ============================================================ */

DELIMITER $$

CREATE PROCEDURE procesar_pedido_con_retry(IN p_id_pedido INT)
BEGIN
    DECLARE v_intentos INT DEFAULT 0;
    DECLARE v_max_intentos INT DEFAULT 2;
    DECLARE v_error_code INT DEFAULT 0;

    -- El handler se declara UNA sola vez, al inicio del bloque
    DECLARE CONTINUE HANDLER FOR 1213
    BEGIN
        SET v_error_code = 1213;
    END;

    retry_loop: WHILE v_intentos <= v_max_intentos DO
        SET v_error_code = 0;

        START TRANSACTION;

        UPDATE pedido
        SET estado = 'TERMINADO'
        WHERE id_pedido = p_id_pedido;

        IF v_error_code = 0 THEN
            COMMIT;
            LEAVE retry_loop;
        ELSE
            ROLLBACK;
            SET v_intentos = v_intentos + 1;
            SELECT SLEEP(1);
        END IF;
    END WHILE;
END $$

DELIMITER ;


-- Ejemplo de uso:
CALL procesar_pedido_con_retry(1);

/* ============================================================
   3) COMPARACIÓN DE NIVELES DE AISLAMIENTO
   READ COMMITTED vs REPEATABLE READ
   ============================================================ */

-- Ver nivel actual
SELECT @@global.tx_isolation;


-- Cambiar a READ COMMITTED
SET SESSION tx_isolation = 'READ-COMMITTED';

-- SESIÓN 1
START TRANSACTION;
SELECT total FROM pedido WHERE id_pedido = 1;

-- SESIÓN 2 (mientras tanto)
UPDATE pedido SET total = total + 100 WHERE id_pedido = 1;
COMMIT;

-- SESIÓN 1 vuelve a consultar
SELECT total FROM pedido WHERE id_pedido = 1;
COMMIT;

-- Cambiar a REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- SESIÓN 1
START TRANSACTION;
SELECT total FROM pedido WHERE id_pedido = 1;

-- SESIÓN 2
UPDATE pedido SET total = total + 100 WHERE id_pedido = 1;
COMMIT;

-- SESIÓN 1 vuelve a consultar (en muchos casos verá el valor anterior)
SELECT total FROM pedido WHERE id_pedido = 1;
COMMIT;
