CREATE DATABASE IF NOT EXISTS inventario;

USE inventario;

CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    telefono VARCHAR(20)
);

INSERT INTO clientes (nombre, correo, telefono) VALUES
('Juan Pérez', 'juan@example.com', '123456789'),
('María Gómez', 'maria@example.com', '987654321'),
('Carlos Ruiz', 'carlos@example.com', '555666777');
