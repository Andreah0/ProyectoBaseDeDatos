-- Script de Creación de Tablas para Sistema de Alquiler a Corto Plazo (SQL Server)

CREATE DATABASE db_airbnb;
GO

USE db_airbnb;
GO

-- -----------------------------------------------------
-- Tabla `Usuarios`
-- -----------------------------------------------------
CREATE TABLE Usuarios (
  Id INT PRIMARY KEY,
  Cedula VARCHAR(50) NOT NULL UNIQUE,
  Nombre VARCHAR(100) NOT NULL,
  Apellido VARCHAR(100) NOT NULL,
  Fecha_nacimiento DATE,
  Telefono VARCHAR(20)
);

INSERT INTO Usuarios(Id, Cedula, Nombre, Apellido,Fecha_nacimiento, Telefono) VALUES
(1, '1234567890', 'Juan', 'Pérez', '1990-05-15', '555-1234'),
(2, '0987654321', 'María', 'Gómez', '1985-10-22', '555-5678'),
(3, '1122334455', 'Carlos', 'Ramírez', '1992-03-08', '555-8765'),
(4, '5566778899', 'Ana', 'Martínez', '1988-07-30', '555-4321'),
(5, '6677889900', 'Luis', 'Fernández', '1995-12-12', '555-6789'),
(6, '9473153167', 'Ana', 'Pérez', '1970-09-13', '555-5980'),
(7, '1617712032', 'María', 'López', '1999-12-16', '555-2575'),
(8, '8160465944', 'María', 'Rojas', '1971-09-20', '555-1226'),
(9, '2481265291', 'Ana', 'Gómez', '1973-05-14', '555-3036'),
(10, '5556920791', 'Carlos', 'Torres', '1990-03-11', '555-1183');

-- -----------------------------------------------------
-- Tabla `Huespedes`
-- -----------------------------------------------------
CREATE TABLE Huespedes (
  Id INT PRIMARY KEY,
  CONSTRAINT FK_Huesped_Usuario FOREIGN KEY (Id) REFERENCES Usuarios(Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Huespedes(Id) VALUES
(6),(7),(8),(9),(10);

-- -----------------------------------------------------
-- Tabla `Anfitriones`
-- -----------------------------------------------------
CREATE TABLE Anfitriones (
  Id INT PRIMARY KEY,
  CONSTRAINT FK_Anfitrion_Usuario FOREIGN KEY (Id) REFERENCES Usuarios(Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Anfitriones(Id) VALUES
(1),(2),(3),(4),(5);

-- -----------------------------------------------------
-- Tabla `Ciudades`
-- -----------------------------------------------------
CREATE TABLE Ciudades (
  Id INT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL
);

INSERT INTO Ciudades (Id, Nombre) VALUES
(1, 'Bogotá'),
(2, 'Medellín'),
(3, 'Cali'),
(4, 'Barranquilla'),
(5, 'Cartagena'),
(6, 'Cúcuta'),
(7, 'Bucaramanga');

-- -----------------------------------------------------
-- Tabla `Direcciones`
-- -----------------------------------------------------
CREATE TABLE Direcciones (
  Id INT PRIMARY KEY,
  Via VARCHAR(255),
  Numero_via VARCHAR(50),
  Numero_interseccion VARCHAR(50),
  Numero_puerta VARCHAR(50),
  Complemento VARCHAR(255),
  Ciudad_id INT NOT NULL,
  CONSTRAINT FK_Direccion_Ciudad FOREIGN KEY (Ciudad_id) REFERENCES Ciudades(Id) ON DELETE NO ACTION ON UPDATE CASCADE -- Changed from RESTRICT for SQL Server
);

INSERT INTO Direcciones (Id, Via, Numero_via, Numero_interseccion, Numero_puerta, Complemento, Ciudad_id) VALUES
(1, 'Calle 1', '10', '20', '101', 'Apartamento 1', 1), -- BOGOTA
(2, 'Avenida 2', '15', '25', '202', 'Edificio B', 2), -- MEDDELLIN
(3, 'Carrera 3', '20', '30', '303', 'Casa C', 3), -- CALI
(4, 'Calle 4', '25', '35', '404', 'Apartamento D', 4), -- BARRANQUILLA
(5, 'Avenida 5', '30', '40', '505', 'Edificio E', 5), -- CARTAGENA
(6, 'Carrera 6', '35', '45', '606', 'Casa F', 6), -- CUCUTA
(7, 'Calle 7', '40', '50', '707', 'Apartamento G', 7); -- BUCARAMANGA

-- -----------------------------------------------------
-- Tabla `TiposDeAlojamiento`
-- -----------------------------------------------------
CREATE TABLE TiposDeAlojamiento (
  Id INT PRIMARY KEY,
  Nombre VARCHAR(100) NOT NULL,
  Descripcion TEXT -- As per MR [cite: 2]
);

INSERT INTO TiposDeAlojamiento (Id, Nombre, Descripcion) VALUES
(1, 'Apartamento', 'Apartamento espacioso con zonas verdes a sus alrededores.'),
(2, 'Hostal', 'Alojamiento económico que ofrece habitaciones privadas o compartidas, generalmente con servicios básicos.'),
(3, 'Apartamento', 'Unidad habitacional independiente equipada con cocina, baño y áreas comunes.'),
(4, 'Cabaña', 'Vivienda rústica, usualmente ubicada en zonas rurales o naturales, ideal para escapadas tranquilas.'),
(5, 'Casa rural', 'Alojamiento en una vivienda tradicional ubicada en el campo, que permite una experiencia más auténtica y cercana a la naturaleza.'),
(6, 'Glamping', 'Alojamiento que combina la experiencia de acampar al aire libre con las comodidades del lujo.'),
(7, 'Bungalow', 'Pequeña casa independiente, generalmente de un solo piso, ideal para vacaciones en la playa o zonas rurales.');

-- -----------------------------------------------------
-- Tabla `Alojamientos`
-- -----------------------------------------------------
CREATE TABLE Alojamientos (
  Id INT PRIMARY KEY,
  Titulo VARCHAR(255) NOT NULL,
  Descripcion TEXT, -- As per MR [cite: 2]
  Cantidad_banios INT,
  Cantidad_habitaciones INT,
  Costo_noche INT NOT NULL, -- As per MR (Int) [cite: 2]
  Anfitrion_id INT NOT NULL,
  Direccion_id INT NOT NULL UNIQUE,
  CONSTRAINT FK_Alojamiento_Anfitrion FOREIGN KEY (Anfitrion_id) REFERENCES Anfitriones(Id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT FK_Alojamiento_Direccion FOREIGN KEY (Direccion_id) REFERENCES Direcciones(Id) ON DELETE NO ACTION ON UPDATE CASCADE, -- Changed from RESTRICT
  CONSTRAINT CK_Alojamiento_CantidadBanios CHECK (Cantidad_banios >= 0),
  CONSTRAINT CK_Alojamiento_CantidadHabitaciones CHECK (Cantidad_habitaciones >= 0),
  CONSTRAINT CK_Alojamiento_CostoNoche CHECK (Costo_noche >= 0)
);

INSERT INTO Alojamientos (Id, Titulo, Descripcion, Cantidad_banios, Cantidad_habitaciones, Costo_noche, Anfitrion_id, Direccion_id) VALUES
(1, 'Apartamento', 'Apartamento ubicado en el norte de la ciudad, ideal para turistas.', 2, 10, 250000, 1, 1), -- ANFITRION: JUAN PEREZ
(2, 'Hostal La Paz', 'Hostal económico con habitaciones compartidas y servicios básicos.', 1, 5, 50000, 2, 2),
(3, 'Apartamento Moderno', 'Apartamento equipado con cocina y áreas comunes, ideal para estancias prolongadas.', 2, 3, 120000, 3, 3),
(4, 'Cabaña Tranquila', 'Cabaña rústica en zona natural, perfecta para escapadas tranquilas.', 1, 2, 80000, 4, 4),
(5, 'Casa Rural', 'Casa tradicional en el campo, experiencia auténtica y cercana a la naturaleza.', 3, 4, 100000, 5, 5),
(6, 'Glamping Experience', 'Alojamiento que combina la experiencia de acampar al aire libre con las comodidades del lujo.', 2, 1, 200000, 1, 6),
(7, 'Beach Bungalow', 'Pequeña casa independiente, generalmente de un solo piso, ideal para vacaciones en la playa o zonas rurales.', 1, 2, 180000, 2, 7);

-- -----------------------------------------------------
-- Tabla `AlojamientosTipoAlojamiento`
-- -----------------------------------------------------
CREATE TABLE AlojamientosTipoAlojamiento (
  Alojamiento_id INT NOT NULL,
  Tipo_id INT NOT NULL,
  CONSTRAINT PK_AlojamientosTipoAlojamiento PRIMARY KEY (Alojamiento_id, Tipo_id),
  CONSTRAINT FK_AlojamientosTipoAlojamiento_Alojamiento FOREIGN KEY (Alojamiento_id) REFERENCES Alojamientos(Id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT FK_AlojamientosTipoAlojamiento_Tipo FOREIGN KEY (Tipo_id) REFERENCES TiposDeAlojamiento(Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO AlojamientosTipoAlojamiento (Alojamiento_id, Tipo_id) VALUES
(1, 1), 
(2, 2),
(3, 3), 
(4, 4), 
(5, 5),
(6, 6),
(7, 7); 

-- -----------------------------------------------------
-- Tabla `Reservas`
-- -----------------------------------------------------
CREATE TABLE Reservas (
  Id INT PRIMARY KEY,
  Huesped_id INT NOT NULL,
  Alojamiento_id INT NOT NULL,
  Estado NVARCHAR(50), -- As per MR (nvarchar) [cite: 2]
  Fecha_inicio DATE NOT NULL,
  Fecha_fin DATE NOT NULL,
  Cantidad_personas INT NOT NULL,
  Costo_Total DECIMAL(12,2), -- Atributo añadido
  CONSTRAINT FK_Reserva_Huesped FOREIGN KEY (Huesped_id) REFERENCES Huespedes(Id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT FK_Reserva_Alojamiento FOREIGN KEY (Alojamiento_id) REFERENCES Alojamientos(Id) ON DELETE NO ACTION ON UPDATE NO ACTION, -- Avoiding cycles/multiple cascade paths if Alojamiento is deleted
  CONSTRAINT CK_Reserva_Fechas CHECK (Fecha_fin >= Fecha_inicio),
  CONSTRAINT CK_Reserva_CantidadPersonas CHECK (Cantidad_personas > 0),
  CONSTRAINT CK_Reserva_CostoTotal CHECK (Costo_Total IS NULL OR Costo_Total >= 0)
);

INSERT INTO Reservas (Id, Huesped_id, Alojamiento_id, Estado, Fecha_inicio, Fecha_fin, Cantidad_personas, Costo_Total) VALUES
(1, 6, 1, 'Confirmada', '2023-08-01', '2023-08-04', 2, 450000.00),
(2, 7, 2, 'Pendiente', '2023-08-08', '2023-08-13', 1, 250000.00),
(3, 8, 3, 'Cancelada', '2023-08-15', '2023-08-17', 3, 240000.00),
(4, 9, 4, 'Confirmada', '2023-08-22', '2023-08-26', 4, 320000.00),
(5, 10, 5, 'Pendiente', '2023-08-29', '2023-09-04', 2, 600000.00),
(6, 6, 6, 'Confirmada', '2023-09-01', '2023-09-04', 2, 600000.00),
(7, 7, 7, 'Pendiente', '2023-09-10', '2023-09-14', 3, 720000.00);

-- -----------------------------------------------------
-- Tabla `Resenias`
-- -----------------------------------------------------
CREATE TABLE Resenias (
  Id INT PRIMARY KEY,
  Comentario NVARCHAR(MAX), -- Using NVARCHAR(MAX) for flexibility as MR type was blank [cite: 2]
  Puntuacion DECIMAL(2,1), -- As per MR (decimal) [cite: 2]
  Reserva_id INT NOT NULL,
  CONSTRAINT FK_Resenia_Alojamiento FOREIGN KEY (Reserva_id) REFERENCES Reservas(Id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT CK_Resenia_Puntuacion CHECK (Puntuacion >= 0.0 AND Puntuacion <= 5.0)
);

INSERT INTO Resenias (Id, Comentario, Puntuacion, Reserva_id) VALUES
(1, 'Excelente servicio y ubicación.', 4.5, 1),
(2, 'Buena relación calidad-precio.', 4.0, 2),
(3, 'Cancelé la reserva, pero el proceso fue fácil.', 3.0, 3),
(4, 'Lugar tranquilo y acogedor.', 5.0, 4),
(5, 'Pendiente de confirmar, pero parece prometedor.', 4.2, 5),
(6, 'Experiencia única y muy cómoda.', 4.8, 6),
(7, 'Lugar perfecto para relajarse en la playa.', 4.7, 7);

-- -----------------------------------------------------
-- Tabla `MetodosDePago`
-- -----------------------------------------------------
CREATE TABLE MetodosDePago (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255) NULL
);

INSERT INTO MetodosDePago (Nombre, Descripcion) VALUES
('Tarjeta de crédito', 'Pago mediante tarjeta de crédito Visa, MasterCard, etc.'),
('Tarjeta débito', 'Pago directo desde cuenta bancaria con tarjeta débito.'),
('Transferencia bancaria', 'Transferencia directa entre cuentas bancarias.'),
('Efectivo', 'Pago en dinero físico al momento del servicio.'),
('PayPal', 'Pago en línea a través de la plataforma PayPal.'),	
('Nequi', 'Pago a través de la aplicación móvil Nequi, vinculada a una cuenta bancaria.'),
('Daviplata', 'Pago mediante la plataforma Daviplata, popular en Colombia para transferencias rápidas.');

-- -----------------------------------------------------
-- Tabla `Pagos`
-- -----------------------------------------------------
CREATE TABLE Pagos (
  Id INT IDENTITY(1,1) PRIMARY KEY, -- IDENTITY para autoincremento en SQL Server
  Reserva_Id INT NOT NULL,
  Fecha_Pago DATETIME NOT NULL DEFAULT GETDATE(), -- Fecha y hora del pago, por defecto la actual
  Monto_Pagado DECIMAL(12,2) NOT NULL, -- Mismo tipo que RESERVA.Costo_Total
  Metodo_Pago_Id INT NOT NULL,
  Referencia_Transaccion VARCHAR(100) NULL,
  CONSTRAINT FK_Pago_Reserva FOREIGN KEY (Reserva_Id) REFERENCES Reservas(Id) ON DELETE CASCADE, -- Si se borra la reserva, se borran sus pagos. Considerar NO ACTION según reglas de negocio.
  CONSTRAINT FK_Metodo_Pago FOREIGN KEY (Metodo_Pago_Id) REFERENCES MetodosDePago(Id) ON DELETE NO ACTION,
  CONSTRAINT CK_Pago_MontoPagado CHECK (Monto_Pagado > 0)
);

INSERT INTO Pagos (Reserva_Id, Fecha_Pago, Monto_Pagado, Metodo_Pago_Id, Referencia_Transaccion) VALUES
(1, '2023-08-01 10:00:00', 450000.00, 1, 'TXN123456'),
(2, '2023-08-08 14:30:00', 250000.00, 2, 'TXN123457'),
(3, '2023-08-15 09:15:00', 240000.00, 3, 'TXN123458'),
(4, '2023-08-22 16:45:00', 320000.00, 4, 'TXN123459'),
(5, '2023-08-29 11:00:00', 600000.00, 5, 'TXN123460'),
(6, '2023-09-01 12:00:00', 600000.00, 6, 'TXN123461'),
(7, '2023-09-10 15:30:00', 720000.00, 7, 'TXN123462');

SELECT * FROM Usuarios;
SELECT * FROM Huespedes;
SELECT * FROM Anfitriones;
SELECT * FROM Ciudades;
SELECT * FROM Direcciones;
SELECT * FROM TiposDeAlojamiento;
SELECT * FROM Alojamientos;
select * from AlojamientosTipoAlojamiento;
SELECT * FROM Reservas; 
SELECT * FROM Resenias;
SELECT * FROM MetodosDePago;
SELECT * FROM Pagos;
