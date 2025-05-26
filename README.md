# ProyectoBaseDeDatos

# Cursores
Recorre todas las reservas en la base de datos, compara el CostoTotal registrado en la tabla Reservas con el calculo que obtiene de multiplicar la cantidad_noches con el precio_noche. Si existe una diferencia significativa, registra esta discrepancia en una tabla AuditoriaReservas.

Crea la tabla de auditorias para reservas 
Se declaran variables para almacenar el ID de la reserva, el costo total esperado, el costo total pagado, el costo de la noche, las fechas, la diferencia y las observaciones.
Se crea el cursor.
El script itera a través de cada reserva.
Se Calcula la diferencia entre el Costo_calculado y el Costo_Total.
Se registra la auditoria si hay una diferencia, ya sea mayor o menor.
Una vez que se procesan todas las reservas, el cursor se cierra.
