-- ============================================
-- 01_esquema.sql
-- Esquema completo del TPI - Food Store
-- ============================================

DROP DATABASE IF EXISTS tpi_bd;
CREATE DATABASE tpi_bd;
USE tpi_bd;

-- ============================================
-- TABLA: categoria
-- ============================================

DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    createdAt DATETIME NOT NULL DEFAULT NOW()
);

-- ============================================
-- TABLA: usuario
-- ============================================

DROP TABLE IF EXISTS usuario;
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

-- ============================================
-- TABLA: producto
-- ============================================

DROP TABLE IF EXISTS producto;
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

-- ============================================
-- TABLA: pedido
-- ============================================

DROP TABLE IF EXISTS pedido;
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

-- ============================================
-- TABLA: detalle_pedido
-- ============================================

DROP TABLE IF EXISTS detalle_pedido;
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
