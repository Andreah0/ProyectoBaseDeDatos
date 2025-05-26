USE db_airbnb;
GO

CREATE TABLE Auditoria_Reservas (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Id_Reserva INT NOT NULL,
        Fecha_Auditoria DATETIME DEFAULT GETDATE(),
        Costo_Total DECIMAL(12,2),
        Costo_Calculado DECIMAL(12,2),
        Diferencia DECIMAL(12,2),
		Observacion NVARCHAR(200)
);

INSERT INTO Reservas(Id, Huesped_id, Alojamiento_id, Estado, Fecha_inicio, Fecha_fin, Cantidad_personas, Costo_Total) VALUES
(8, 8, 3, 'Confirmada', '2023-09-10', '2023-09-14', 3, 500000.00);
-- -----------------------------------------------------
-- Cursores
-- -----------------------------------------------------
 DECLARE 
	@Id_Reserva INT,
    @Fecha_Inicio DATE,
    @Fecha_Fin DATE,
    @Costo_Noche DECIMAL(12,2), 
    @Cantidad_Noches INT,
    @Costo_Total DECIMAL(12,2),    
    @Costo_Calculado DECIMAL(12,2),
    @Diferencia DECIMAL(12,2),
    @Observaciones NVARCHAR(200)

DECLARE 
	Reserva_Cursor CURSOR FOR 
	SELECT r.Id, r.Fecha_Inicio, r.Fecha_Fin, a.Costo_Noche, r.Costo_Total
	FROM Reservas AS r
	INNER JOIN Alojamientos AS a ON r.Alojamiento_id = a.Id
	WHERE r.Estado = 'Confirmada';

OPEN Reserva_Cursor;

FETCH NEXT FROM Reserva_Cursor INTO 
	@Id_Reserva,
    @Fecha_Inicio,
    @Fecha_Fin,
    @Costo_Noche,
    @Costo_Total;

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Cantidad_Noches = DATEDIFF(day, @Fecha_Inicio, @Fecha_Fin); -- Calcula la cantidad de noches
	SET @Costo_Calculado = @Costo_Noche * @Cantidad_Noches; 
	SET @Diferencia = @Costo_Calculado - @Costo_Total;
	SET @Observaciones = NULL; 

	IF ABS(@Diferencia) > 0.01
    BEGIN
        SET @Observaciones = 'Diferencia en cálculo de costos: ' + 
                            CAST(@Costo_Noche AS VARCHAR) + ' x ' + 
                            CAST(@Cantidad_Noches AS VARCHAR) + ' noches = ' + 
                            CAST(@Costo_Calculado AS VARCHAR) + ' ≠ ' + 
                            CAST(@Costo_Total AS VARCHAR) + ' registrado';
    END

    IF @Diferencia <> 0
    BEGIN
        INSERT INTO Auditoria_Reservas (
            Id_Reserva,
            Costo_Total,
            Costo_Calculado,
            Diferencia,
            Observacion)
        VALUES (
            @Id_Reserva,
            @Costo_Total,
			@Costo_Calculado,
            @Diferencia,
            @Observaciones)
    END
	-- Siguiente reserva
	FETCH NEXT FROM Reserva_Cursor INTO 
			@Id_Reserva,
			@Fecha_Inicio,
			@Fecha_Fin,
			@Costo_Noche,
			@Costo_Total;
END
CLOSE Reserva_Cursor;
DEALLOCATE Reserva_Cursor;
GO 
SELECT * FROM Auditoria_Reservas
ORDER BY Fecha_Auditoria DESC;
