-- ============================================
-- 09_concurrencia_guiada.sql
-- Concurrencia y niveles de aislamiento
-- TPI - Food Store
-- ============================================

USE tpi_bd;

-- ============================================
-- 1) SIMULACIÓN DE DEADLOCK (DOS SESIONES)
-- ============================================

-- SESIÓN 1
-- (Ejecutar en una ventana separada)
START TRANSACTION;
UPDATE pedido 
SET estado = 'PENDIENTE' 
WHERE id_pedido = 1;

-- SESIÓN 2
-- (Ejecutar en otra ventana)
START TRANSACTION;
UPDATE detalle_pedido 
SET cantidad = cantidad + 1 
WHERE id_pedido = 1;

-- SESIÓN 1 (segundo UPDATE)
UPDATE detalle_pedido 
SET cantidad = cantidad + 1 
WHERE id_pedido = 1;

-- SESIÓN 2 (segundo UPDATE)
UPDATE pedido 
SET estado = 'CONFIRMADO' 
WHERE id_pedido = 1;

-- En uno de los dos UPDATE finales MySQL debería lanzar:
-- Error 1213: Deadlock found when trying to get lock

ROLLBACK; -- en ambas sesiones para liberar los locks

-- ============================================
-- 2) COMPARACIÓN DE NIVELES DE AISLAMIENTO
-- READ COMMITTED vs REPEATABLE READ
-- ============================================

-- Ver nivel actual
SELECT @@global.tx_isolation;

-- Cambiar a READ COMMITTED
SET SESSION tx_isolation = 'READ-COMMITTED';

-- SESIÓN 1
START TRANSACTION;
SELECT total FROM pedido WHERE id_pedido = 1;

-- SESIÓN 2 (mientras tanto)
UPDATE pedido 
SET total = total + 100 
WHERE id_pedido = 1;
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
UPDATE pedido 
SET total = total + 100 
WHERE id_pedido = 1;
COMMIT;

-- SESIÓN 1 vuelve a consultar
SELECT total FROM pedido WHERE id_pedido = 1;
COMMIT;
