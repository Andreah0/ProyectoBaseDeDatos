USE db_airbnb;
GO

-- -----------------------------------------------------------
-- Actualizar Costo total en reserva
-- -----------------------------------------------------------
CREATE PROCEDURE ActualizarCostoReserva
    @reserva_id INT
AS
BEGIN
    DECLARE 
	@Cantidad_Noches DECIMAL(12,2),
	@Fecha_Inicio DATE,
	@Fecha_Fin DATE,
	@Costo_Noche DECIMAL(12,2),
	@Nuevo_Costo DECIMAL(12,2)

	SELECT
		@Fecha_Inicio = r.Fecha_Inicio,
		@Fecha_Fin = r.Fecha_Fin,
		@Costo_Noche = a.Costo_Noche
		FROM 
		Reservas r
		JOIN Alojamientos a ON r.Alojamiento_id = a.Id
		WHERE r.Id = @reserva_id

    SET @Cantidad_Noches = DATEDIFF(day, @Fecha_Inicio, @Fecha_Fin);
	SET @Nuevo_Costo = @Cantidad_Noches * @Costo_Noche

	UPDATE Reservas
	SET Costo_Total = @Nuevo_Costo 
	WHERE Id = @reserva_id

	SELECT 
        @reserva_id AS ReservaId,
        @fecha_inicio AS FechaInicio,
        @fecha_fin AS FechaFin,
        @costo_noche AS CostoPorNoche,
        @nuevo_costo AS NuevoCostoTotal
END;
GO
EXEC ActualizarCostoReserva 1;
GO

-- -----------------------------------------------------------
-- Modificar fechas de reserva
-- -----------------------------------------------------------

CREATE PROCEDURE ModificarFechas
	@Id_reserva INT,
	@Fecha_Inicio DATE,
	@Fecha_Fin DATE
AS
BEGIN 
	IF @Fecha_Fin < @Fecha_Inicio
        BEGIN
            RAISERROR('La fecha de fin no puede ser anterior a la de inicio', 16, 1);
            RETURN;
        END

	UPDATE Reservas
	SET 
		Fecha_inicio = @Fecha_Inicio,
		Fecha_Fin = @Fecha_Fin
	WHERE Id = @Id_reserva

	EXEC ActualizarCostoReserva @Id_reserva;
END;
GO
EXEC ModificarFechas 2, '2023-08-10', '2023-08-16';
GO
SELECT * FROM Reservas;

-- -----------------------------------------------------------
-- Contar la cantidad de reservas que tienen los alojamientos
-- -----------------------------------------------------------
CREATE PROCEDURE ContarReservasPorAlojamiento
AS
BEGIN
    SELECT 
        a.Id AS alojamiento_id,
        a.Titulo AS alojamiento_nombre,
        COUNT(r.Id) AS cantidad_Reservas
    FROM 
        Alojamientos a
    LEFT JOIN
        Reservas r ON r.Alojamiento_id = a.Id
    GROUP BY
        a.Id, a.Titulo
END;
GO
EXEC ContarReservasPorAlojamiento;
GO

-- -----------------------------------------------------------
-- Contar cuantas reservas confirmadas tiene un alojamiento en especifico
-- -----------------------------------------------------------
CREATE PROCEDURE ContarReserva
	@Id_Alojamiento INT,
	@Cantidad_Reservas INT OUTPUT
AS 
BEGIN
	SELECT 
		@Cantidad_Reservas = COUNT(r.Id)
	FROM 
        Alojamientos a
		LEFT JOIN Reservas r ON a.Id = r.Alojamiento_id
	WHERE 
        a.Id = @Id_Alojamiento
        AND r.Estado = 'Confirmada'  -- Solo contar reservas confirmadas
    GROUP BY 
        a.Id, a.Titulo
END;
GO
DECLARE @Cantidad INT;
EXEC ContarReserva 3, @Cantidad OUTPUT;
SELECT @Cantidad AS 'Cantidad de Reservas Confirmadas';
GO

-- -----------------------------------------------------------
-- Ver todos los metodos de pago
-- -----------------------------------------------------------
CREATE PROCEDURE Ver_Metodos
AS 
BEGIN
	SELECT * FROM MetodosDePago
END;
GO
EXEC Ver_Metodos;
GO

-- -----------------------------------------------------------
-- Insertar metodo de pago
-- -----------------------------------------------------------
CREATE PROCEDURE Insertar_Metodo 
	@nombre NVARCHAR(50),
	@descripcion NVARCHAR(255)
AS 
BEGIN
	INSERT INTO MetodosDePago VALUES
	(@nombre, @descripcion)
END;
GO
EXEC Insertar_Metodo 'Mercado Pago', 'Plataforma de pagos online';
EXEC Ver_Metodos;
GO

-- -----------------------------------------------------------
-- Eliminar metodo de pago
-- -----------------------------------------------------------

CREATE PROCEDURE EliminarMetodoPorNombre
	@Nombre NVARCHAR(50)
AS 
BEGIN
	DELETE FROM MetodosDePago
	WHERE Nombre = @Nombre
END;
GO
EXEC EliminarMetodoPorNombre 'Mercado Pago';
EXEC Ver_Metodos;
GO

-- -----------------------------------------------------------
-- Insertar Usuario
-- -----------------------------------------------------------
CREATE PROCEDURE InsertarUsuario
	@Id INT,
	@Cedula VARCHAR(50),
    @Nombre VARCHAR(100),
	@Apellido VARCHAR(100),
	@Fecha_nacimiento DATE,
	@Telefono VARCHAR(20)
AS 
BEGIN
	INSERT INTO Usuarios VALUES
	(@Id, @Cedula, @Nombre, @Apellido, @Fecha_nacimiento, @Telefono)
END;
GO
EXEC InsertarUsuario 11 , '6667031802', 'Sara', 'Hernandez', '1997-02-11', '555-0601';
EXEC InsertarUsuario 12 , '7778142913', 'Melissa', 'Sanchez', '1998-03-12', '555-0702';
GO
SELECT * FROM Usuarios;

-- -----------------------------------------------------------
-- Insertar Anfitrion
-- -----------------------------------------------------------
CREATE PROCEDURE InsertarAnfitrion
	@Id INT
AS 
BEGIN
	INSERT INTO Anfitriones VALUES
	(@Id)
END;
GO
EXEC InsertarAnfitrion 11;
GO
SELECT * FROM Anfitriones;

-- -----------------------------------------------------------
-- Insertar Huesped
-- -----------------------------------------------------------
CREATE PROCEDURE InsertarHuesped
	@Id INT
AS 
BEGIN
	INSERT INTO Huespedes VALUES
	(@Id)
END;
GO
EXEC InsertarHuesped 12;
GO
SELECT * FROM Huespedes;

-- -----------------------------------------------------------
-- Ver Todos Los Anfitriones Con Sus Aojamientos Registrados
-- -----------------------------------------------------------
CREATE PROCEDURE VerAnfitrionYAlojamiento
AS 
BEGIN
	SELECT 
		u.Nombre AS Nombre_Del_Anfitrion,
		u.Apellido AS Apellido_Del_Anfitrion,
		a.Id AS Id_Alojamiento,
		a.Titulo,
		d.Via AS Via,
		d.Numero_via AS Numero_De_Via,
		d.Numero_interseccion AS Numero_De_Interseccion,
		d.Numero_interseccion AS Numero_De_Puerta,
		d.Complemento AS Complemento_Direccion
	FROM
		Alojamientos a
	INNER JOIN
		Anfitriones an ON a.Anfitrion_id = an.Id
	INNER JOIN
		Usuarios u ON an.Id = u.Id
	INNER JOIN
		Direcciones d ON a.Direccion_id = d.Id;
END;
GO
EXEC VerAnfitrionYAlojamiento;
GO
DROP PROCEDURE IF EXISTS VerAnfitrionYAlojamiento;
GO

-- -----------------------------------------------------------
-- Ver A Que Anfitrion Pertenece Un Alojamiento En Especifico 
-- -----------------------------------------------------------
CREATE PROCEDURE ObtenerAnfitrionAlojamiento
	@Id_Alojamiento INT
AS
BEGIN 
	SELECT 
		a.Id IdAlojamiento,
		a.Titulo Titulo,
		u.Nombre AS Nombre_Del_Anfitrion,
		u.Apellido AS Apellido_Del_Anfitrion
	FROM 
		Alojamientos a
		INNER JOIN
		Anfitriones an ON a.Anfitrion_id = an.Id
		INNER JOIN
		Usuarios u ON an.Id = u.Id
		WHERE 
			a.Id = @Id_Alojamiento
END;
GO
EXEC ObtenerAnfitrionAlojamiento 2;
GO
DROP PROCEDURE IF EXISTS ObtenerAnfitrionAlojamiento;
GO
-- -----------------------------------------------------------
-- Crear reseña
-- -----------------------------------------------------------
CREATE PROCEDURE CrearResenia
	@Id INT,
	@Comentario NVARCHAR(MAX), 
	@Puntuacion DECIMAL(2,1), 
	@Reserva_id INT
AS 
BEGIN
	INSERT INTO Resenias VALUES
	(@Id, @Comentario, @Puntuacion, @Reserva_id)
END;
GO
EXEC CrearResenia 8, 'No lo recomendaria', 1.0, 3;
GO

-- -----------------------------------------------------------
-- Calcular Promedio De Calificaciones
-- -----------------------------------------------------------
CREATE PROCEDURE CalcularPuntuacionesAlojamientos
AS
BEGIN
    SELECT 
        a.Id,
        a.Titulo,
        AVG(re.Puntuacion) AS PuntuacionPromedio,
        COUNT(re.Id) AS CantidadResenias
    FROM Alojamientos a
    LEFT JOIN Reservas r ON a.Id = r.Alojamiento_id
    LEFT JOIN Resenias re ON r.Id = re.Reserva_id
    GROUP BY a.Id, a.Titulo
END;
GO
EXEC CalcularPuntuacionesAlojamientos;

-- -----------------------------------------------------------
-- Actualizar Estado De Una Reserva
-- -----------------------------------------------------------
CREATE PROCEDURE ActualizarEstadoReserva
	@Id_reserva INT,
	@Estado NVARCHAR(50)
AS
BEGIN 
	UPDATE Reservas
	SET Estado = @Estado
	WHERE Id = @Id_reserva
END;
GO
EXEC ActualizarEstadoReserva 1, 'Terminada';
GO
SELECT * FROM Reservas;