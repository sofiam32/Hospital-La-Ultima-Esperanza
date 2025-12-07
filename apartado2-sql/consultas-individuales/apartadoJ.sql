-- Apartado J
-- Codifica un trigger que garantice que unicamente los doctores con la formación adecuada y 
-- actualizada puedan programar nuevas intervenciones medicas para las que se han certificado.
-- Es decir, que el certificado sea válido para la fecha del procedimiento que va a realizar.
-- Diferenciar mediante mensajes de error específicos entre ambos casos: los que el doctor no
-- posee la certificacion requerida y aquellos en los que la certificación existe pero se encuentra
-- caducada. Incluir las sentencias SQL para probar el trigger con todos los casos (i.e. que se
-- se pueda dar de alta correctamente y ambos errores).

DELIMITER //
CREATE TRIGGER verificar_certificacion_intervencion 
BEFORE INSERT ON undergoes
FOR EACH ROW
BEGIN

    -- Convertimos la fecha de la intervención a DATE para comparaciones correctas.
    SET @fecha_intervencion = STR_TO_DATE(NEW.date, '%d/%m/%Y');

    -- Verificar la existencia del certificado para el procedimiento.
    IF NOT EXISTS (
        SELECT 1
        FROM trained_in t
        WHERE t.physicianid = NEW.physicianid 
          AND t.treatmentid = NEW.procedureid
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El doctor no posee la certificación requerida para este procedimiento.';
    ELSE 
        -- Si existe, verificar que la fecha de la intervención no se pasa de la fecha de caducidad.
        -- Se usa MAX() para manejar el caso donde el doctor tiene varias certificaciones (una nueva y una vieja).
        SELECT MAX(STR_TO_DATE(t.certificationexpires, '%d/%m/%Y')) INTO @max_expiration_date
        FROM trained_in t
        WHERE t.physicianid = NEW.physicianid 
          AND t.treatmentid = NEW.procedureid;
        IF @fecha_intervencion > @max_expiration_date THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: La certificación del doctor está caducada para este procedimiento.';
        END IF;
    END IF;
END//
DELIMITER ;


-- Sentencias SQL para probar el trigger

-- Caso 1: Doctor con certificación válida
INSERT INTO undergoes (patientid, procedureid, stayid, `date`, physicianid, assistingnurseid) 
VALUES (100000001, 1, 3215, '31/12/2008', 3, 101);
            -- Resultado esperado: La intervención se programa correctamente.

-- Caso 2: Doctor sin certificación requerida
INSERT INTO undergoes (patientid, procedureid, stayid, `date`, physicianid, assistingnurseid) 
VALUES (100000001, 1, 3215, '01/01/2008', 1, 101);
            -- Resultado esperado: Error: El doctor no posee la certificación requerida para este procedimiento.

-- Caso 3: Doctor con certificación caducada
INSERT INTO undergoes (patientid, procedureid, stayid, `date`, physicianid, assistingnurseid) 
VALUES (100000001, 1, 3215, '01/01/2009', 3, 101);
            -- Resultado esperado: Error: La certificación del doctor está caducada para este procedimiento.

-- Elimino la cita de prueba para mantener la integridad de los datos
DELETE FROM undergoes
WHERE 
    patientid = 100000001
    AND procedureid = 1
    AND stayid = 3215
    AND `date` = '31/12/2008';