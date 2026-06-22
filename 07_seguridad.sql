-- ============================================
-- 07_seguridad.sql
-- Seguridad, integridad y protección de datos
-- TPI - Food Store
-- ============================================

USE tpi_bd;

-- ============================================
-- 1) CREACIÓN DE USUARIO CON PRIVILEGIOS MÍNIMOS
-- ============================================

-- Crear usuario de aplicación
DROP USER IF EXISTS 'app_user'@'localhost';
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'app123';

-- Quitar todos los privilegios por seguridad
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app_user'@'localhost';

-- Otorgar permisos mínimos
GRANT SELECT ON tpi_bd.vista_usuarios_publicos TO 'app_user'@'localhost';
GRANT SELECT ON tpi_bd.vista_pedidos_publicos TO 'app_user'@'localhost';
GRANT INSERT ON tpi_bd.pedido TO 'app_user'@'localhost';

FLUSH PRIVILEGES;

-- ============================================
-- 2) VISTAS SEGURAS (ya creadas en 06_vistas.sql)
-- Solo se documentan aquí como parte de seguridad
-- ============================================

-- vista_usuarios_publicos
-- vista_pedidos_publicos

-- ============================================
-- 3) PRUEBAS DE INTEGRIDAD
-- (Deben fallar para demostrar constraints)
-- ============================================

-- ❌ ERROR: mail duplicado (UNIQUE)
INSERT INTO usuario (nombre, apellido, mail, celular, contraseña, rol)
VALUES ('Test', 'Duplicado', 'ana@mail.com', '111', '123', 'USUARIO');

-- ❌ ERROR: usuario inexistente (FOREIGN KEY)
INSERT INTO pedido (id_usuario, fecha, forma_pago, estado)
VALUES (99999, NOW(), 'EFECTIVO', 'PENDIENTE');

-- ============================================
-- 4) PROCEDIMIENTO ANTI-INYECCIÓN
-- Sin SQL dinámico
-- ============================================

DROP PROCEDURE IF EXISTS buscar_usuario_seguro;

DELIMITER $$

CREATE PROCEDURE buscar_usuario_seguro(IN p_mail VARCHAR(100))
BEGIN
    SELECT id_usuario, nombre, apellido, mail
    FROM usuario
    WHERE mail = p_mail;
END $$

DELIMITER ;

-- ============================================
-- 5) PRUEBA DE INYECCIÓN SQL
-- Debe devolver solo el usuario real
-- ============================================

CALL buscar_usuario_seguro("ana@mail.com' OR '1'='1");
