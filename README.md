# TFI – Bases de Datos I
## Sistema: Food Store
### Autoras:
- Dominicale Doré, María Luz
- Egea Ruiz, Magaly
- Ferrario, Inés

### Fecha: 23/06/2026
### Versión: 1.0
---

## 🎥 Video Demostración

🔗 **Enlace al video:**  
*https://drive.google.com/file/d/1WHmFnJHu09On2u8UT6CeGQpG4f7Gj1p4/view?usp=sharing*

---

## 📌 Estructura de la Carpeta de Scripts

Este proyecto contiene los archivos .sql requeridos por la cátedra para el Trabajo Final Integrador de Bases de Datos I.  
Cada archivo es idempotente y puede ejecutarse múltiples veces sin generar errores.

---

### 01_esquema.sql
- Creación de la base de datos `tpi_bd`
- Definición de tablas principales:
  - categoria
  - usuario
  - producto
  - pedido
  - detalle_pedido
- Incluye:
  - PK, FK
  - UNIQUE
  - CHECK
  - Reglas de negocio reflejadas en constraints

---

### 02_catalogos.sql
- Carga inicial de categorías (8 registros)
- Datos semilla para pruebas y consistencia

---

### 03_carga_masiva.sql
- Generación masiva de datos utilizando:
  - INSERT ... SELECT
  - RAND(), CONCAT(), FLOOR()
  - JOIN para expansión
- Incluye:
  - 200 usuarios
  - 2000 productos
  - 5000+ pedidos
  - 20.000+ detalles
- Cálculo automático de subtotales y totales

---

### 04_indices.sql
- Índices para optimización de consultas:
  - idx_producto_categoria
  - idx_pedido_usuario
  - idx_detalle_producto
  - idx_detalle_pedido

---

### 05_consultas.sql
Consultas avanzadas requeridas por la Etapa 3:
- JOIN múltiple
- GROUP BY + HAVING
- Subconsulta
- Consulta sobre vista

---

### 05_explain.sql
- EXPLAIN de todas las consultas avanzadas
- Evidencia para análisis de rendimiento

---

### 06_vistas.sql
- Vistas de reportes:
  - vista_pedidos_detalle
- Vistas públicas para ocultar datos sensibles:
  - vista_usuarios_publicos
  - vista_pedidos_publicos

---

### 07_seguridad.sql
- Creación de usuario con privilegios mínimos (`app_user`)
- GRANT / REVOKE
- Pruebas de integridad (errores esperados)
- Procedimiento anti-inyección:
  - buscar_usuario_seguro

---

### 08_transacciones.sql
- Procedimiento con retry ante deadlock:
  - procesar_pedido_con_retry
- Manejo del error 1213
- Uso de START TRANSACTION, COMMIT y ROLLBACK

---

### 09_concurrencia_guiada.sql
- Simulación de deadlock (dos sesiones)
- Comparación de niveles de aislamiento:
  - READ COMMITTED
  - REPEATABLE READ

---

## 📌 Notas
- Todos los scripts fueron probados en MySQL Workbench.
- El proyecto incluye evidencias en el PDF correspondiente.
- El video explicativo se encuentra enlazado dentro del PDF.

---

## 📌 Versión
1.0 – Entrega oficial del TFI Bases de Datos I (2026)
