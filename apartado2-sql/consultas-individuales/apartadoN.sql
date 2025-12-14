-- Apartado N
-- Codifica un procedimiento almacenado denominado 'physician_report' que permita generar
-- un reporte de texto con los pacientes atendidos por un doctor y las medicinas que les han
-- prescrito. El procedimiento recibirá como entrada el identificador del doctor y el rango de 
-- fechas sobre las que se desea generar el informe. Se dispondra de un parámetro de salida
-- de tipo TEXT que contendra el un informe como el que se muestra a continuación:

-- INFORME DE John Dorian

-- John Smith (24/4/2008)
-- # Procrastin-X

-- John Smith (25/4/2008)
-- # No medications prescribed

-- La primera línea indicara el nombre del doctor. En las lineas sucesivas se indicará el nombre 
-- del paciente atendido y la fecha en la que atendio así como los nombres de los medicamentos
-- prescritos en la consulta. Si no se recetó ningún medicamento se indicará "No medications
-- prescribed". Las consultas deberan ordenarse cronológicamente. Incluye también todas las
-- sentencias SQL necesarias para probar el procedimiento almacenado.

DELIMITER $$
CREATE PROCEDURE physician_report (IN doctorid INT, IN startdate VARCHAR(10), IN enddate VARCHAR(10), OUT result TEXT)
BEGIN
  	DECLARE l_done INT DEFAULT FALSE;
    DECLARE l_patient_name VARCHAR(20);
    DECLARE l_doctor_name VARCHAR(20);
    DECLARE l_start_date VARCHAR(10);
    DECLARE l_appointment_id INT;
    DECLARE l_num_med INT;
  	DECLARE l_medication_name VARCHAR(20);
    
  	DECLARE l_cur CURSOR FOR 
		SELECT p.name, start_dt_time, a.appointmentid
		FROM patient p JOIN appointments a ON p.ssn = a.patientid JOIN physician ph ON a.physicianid = ph.employeeid 
		WHERE ph.employeeid = doctorid AND str_to_date(start_dt_time,'%e/%c/%Y') BETWEEN str_to_date(startdate,'%e/%c/%Y') AND str_to_date(enddate,'%e/%c/%Y')
		ORDER BY str_to_date(start_dt_time,'%e/%c/%Y');
  	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done = TRUE;
    
    -- Obtener nombre del médico
    SELECT name INTO l_doctor_name
  	FROM physician 
  	WHERE employeeid = doctorid;
    
    -- Comprobar que existe 
    IF l_doctor_name IS NULL THEN
		SET result = 'Error: Physician not found';	
    ELSE
		SET result = CONCAT('INFORME DE ', l_doctor_name, '\n\n');
		
        OPEN l_cur;
        
		read_loop: LOOP
			FETCH l_cur INTO l_patient_name, l_start_date, l_appointment_id;
		
			IF l_done THEN
				LEAVE read_loop;
			END IF;
            
			-- Agregar línea del paciente
			SET result = CONCAT (result, l_patient_name,' (',l_start_date,')\n');
		
			-- Obtener número de medicamentos prescritos
      SELECT COUNT(*) INTO l_num_med
			FROM prescribes 
			WHERE appointmentid = l_appointment_id AND physicianid = doctorid;
				
			IF l_num_med = 0 THEN
				SET result = CONCAT(result,'# No medications prescribed\n\n');
			ELSE
				-- Obtener nombre del medicamento
				SELECT m.name INTO l_medication_name
				FROM prescribes pr JOIN medication m ON pr.medicationid = m.code
				WHERE pr.appointmentid = l_appointment_id AND pr.physicianid = doctorid;

				SET result = CONCAT(result,'# ', l_medication_name, '\n\n');
					
        SET l_done = FALSE;
			END IF;
		END LOOP;
		CLOSE l_cur;
   END IF;
END$$
DELIMITER ;

-- ============================================================================
-- PRUEBAS DEL PROCEDIMIENTO
-- ============================================================================

-- Prueba 1: Dr. John Dorian (ID=1)  5 consultas 
CALL physician_report(1, '25/4/2008', '13/7/2023', @result);
SELECT @result AS INFORME;

-- Prueba 2: Dr. Elliot Reid (ID=2) 3 consultas
CALL physician_report(2, '24/4/2008', '27/4/2008', @result);
SELECT @result AS INFORME;

-- Prueba 3: Dr. Christopher Turk (ID=3) 3 consultas
CALL physician_report(3, '20/3/2008', '30/4/2023', @result);
SELECT @result AS INFORME;

-- Prueba 4: Dr. Molly Clock (ID=9) 1 consulta
CALL physician_report(9, '27/4/2008', '30/4/2008', @result);
SELECT @result AS INFORME;

-- Prueba 5: Doctor no existente
CALL physician_report(-1, '27/4/2008', '30/4/2008', @result);
SELECT @result AS INFORME;
