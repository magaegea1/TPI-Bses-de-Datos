-- ============================================
-- 08_transacciones.sql
-- Transacciones y manejo de errores
-- TPI - Food Store
-- ============================================

USE tpi_bd;

-- ============================================
-- 1) TRANSACCIÓN CON MANEJO DE ERRORES Y RETRY
-- Manejo del error 1213 (deadlock)
-- ============================================

DROP PROCEDURE IF EXISTS procesar_pedido_con_retry;

DELIMITER $$

CREATE PROCEDURE procesar_pedido_con_retry(IN p_id_pedido INT)
BEGIN
    DECLARE v_intentos INT DEFAULT 0;
    DECLARE v_max_intentos INT DEFAULT 2;
    DECLARE v_error_code INT DEFAULT 0;

    -- Handler para deadlock
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
