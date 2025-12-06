-- Apartado N
-- Codifica un procedimiento almacenado denominado 'physician_report' que permita generar
-- un reporte de texto con los pacientes atendidos por un doctor y las medicinas que les han
-- prescrito. El procedimiento recibirá como entrada el identificador del doctor y el rango de 
-- fechas sobre las que se desea generar el informe. Se dispondra de un parámetro de salida
-- de tipo TEXT que contendra el un informe como el que se muestra a continuación:

-- INFORMEDE John Dorian

-- John Smith (24/4/2008)
-- # Procrastin-X

-- John Smith (25/4/2008)
-- # No medications prescribed

-- La primera línea indicara el nombre del doctor. En las lineas sucesivas se indicará el nombre 
-- del paciente atendido y la fecha en la que atendio así como los nombres de los medicamentos
-- prescritos en la consulta. Si no se recetó ningún medicamento se indicará "No medications
-- prescribed". Las consultas deberan ordenarse cronológicamente. Incluye también todas las
-- sentencias SQL necesarias para probar el procedimiento almacenado.
