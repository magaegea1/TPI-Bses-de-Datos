-- Crear la base de datos del TPI
CREATE DATABASE tpi_bd;

-- Seleccionar la base para trabajar
USE tpi_bd;

-- Tabla de categorías de productos
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,   -- No se pueden repetir nombres
    descripcion VARCHAR(200),
    eliminado BOOLEAN NOT NULL DEFAULT 0  -- Baja lógica
);

-- Tabla de usuarios del sistema
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    mail VARCHAR(100) NOT NULL UNIQUE,    -- Mail único
    celular VARCHAR(20),
    eliminado BOOLEAN NOT NULL DEFAULT 0
);

-- Tabla de productos
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),  -- Validación de precio
    stock INT NOT NULL CHECK (stock >= 0),               -- Validación de stock
    id_categoria INT NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- Tabla de pedidos
CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha DATETIME NOT NULL,
    forma_pago ENUM('EFECTIVO','TARJETA','TRANSFERENCIA') NOT NULL,
    estado ENUM('CREADO','PAGADO','CANCELADO') NOT NULL,
    total DECIMAL(10,2),
    eliminado BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabla de detalles del pedido (composición)
CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),  -- Validación de cantidad
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Inserciones correctas
INSERT INTO categoria (nombre, descripcion) VALUES ('Bebidas', 'Bebidas frías');
INSERT INTO usuario (nombre, apellido, mail) VALUES ('Ana', 'Gomez', 'ana@mail.com');

-- Error por UNIQUE (mail duplicado)
INSERT INTO usuario (nombre, apellido, mail) VALUES ('Juan', 'Perez', 'ana@mail.com');

-- Error por CHECK (precio negativo)
INSERT INTO producto (nombre, precio, stock, id_categoria)
VALUES ('Coca Cola', -10, 5, 1);
