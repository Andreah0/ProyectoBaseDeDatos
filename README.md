# ProyectoBaseDeDatos

# Cursores
-Se crea una tabla con campos para registrar el ID de la reserva, el costo total pagado, el costo total esperado, la diferencia, la fecha de la auditoría y observaciones.
-Se declaran las variables necesarias para almacenar los datos de cada fila procesada y los resultados de los cálculos.
CURSOR Reserva_Cursor
-Seleccionamos el Id de la reserva, fecha_inicio, fecha_fin, costo_total de reservas, y costo_noche de los alojamientos donde su estado de reserva se confirmada. 

# Procedimientos Almacenados
- Actualizar Costo de Reserva: 
-Preparamos los "contenedores" para almacenar temporalmente los datos que necesitaremos.
-Recuperamos de la base de datos la fecha_incio, fecha_fin y el coto_noche
-Calculamos el costo_total con la cantidad de dias y el costo_noche.
-Actualizamos el costo de la reserva en la base de datos.
-Retornamos los resultados

-Actualizar Fechas De Reserva:
-Preparamos los "contenedores" para almacenar temporalmente los datos que necesitaremos.
-Verificamos primero que las fechas de reserva sean validas.
-Si no, mostramos un mensaje de error y terminamos la ejecución.
-Actualizamos las fechas en la base de datos.
-Llamos al procedimiento para Actualizar el costo de la reserva. 