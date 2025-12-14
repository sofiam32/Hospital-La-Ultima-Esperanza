-- Apartado L
-- Codifica una funcion almacenada denominada 'total_cost_patient' que calcule y devuelva el
-- coste total acumulado de todos los procedimientos medicos registrados en la tabla 'undergoes'
-- que un paciente, pasado como parámetro, haya recibido. Infiere los tipos de datos tanto del 
-- coste total como del identificador del paciente a partir de los datos con los que las tablas
-- fueron creadas.

DELIMITER $$
CREATE FUNCTION total_cost_patient(patient_SSN INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE total_cost INT DEFAULT 0; -- Si no hay procedimiento, devuleve 0
   
   -- Calcula el coste total de los procedimientos del paciente
    SELECT SUM(mp.cost) INTO total_cost
    FROM undergoes u
    INNER JOIN medical_procedure mp
		ON u.procedureid = mp.code
	WHERE u.patientid = patient_ssn;
    RETURN total_cost;
END$$
DELIMITER ;

-- Tras crear la funcion almacenada 'total_cost_patient', realiza una consulta en SQL que,
-- haciendo uso de la función, liste los datos del paciente que mayor coste total acumulado en 
-- procedimientos medicos.

SELECT 
	p.*
FROM patient p
ORDER BY total_cost_patient(p.ssn) DESC
LIMIT 1;
