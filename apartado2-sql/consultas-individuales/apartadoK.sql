-- Apartado K
-- Con el diseno actual de la base de datos, la política de gestion de borrados de pacientes no 
-- permite llevar a cabo el borrado de aquellos pacientes que tengan asociado cualquier tipo de
-- información médica sobre ellos. Sin embargo, se desea cambiar esta política de manera que
-- se permita eliminar pacientes bajo condiciones controladas: no tener citas o procedimientos
-- médicos futuros programados y no tener registrado en la base de datos ningún tipo de información
-- de actividad médica (consultas, procedimientos, prescriciones o estancias) durante los últimos 3 años.

-- Para poder realizar esta gestión, primeramente generar las sentencias SQL necesarias para 
-- permitir el borrado de pacientes de la base de datos aunque tengan asociados datos 
-- (se borrarán los datos del resto de tablas que tengan asociados).

-- 1) Quitar las constraints de las FKs actuales: 
-- Este bloque debe ejecutarse una sola vez.

ALTER TABLE appointments DROP FOREIGN KEY appointments_ibfk_1; -- cambiar el nombre si el gestor las llama distintas
ALTER TABLE prescribes   DROP FOREIGN KEY prescribes_ibfk_2; -- cambiar el nombre si el gestor las llama distintas
ALTER TABLE stay         DROP FOREIGN KEY stay_ibfk_1; -- cambiar el nombre si el gestor las llama distintas
ALTER TABLE undergoes    DROP FOREIGN KEY undergoes_ibfk_1; -- cambiar el nombre si el gestor las llama distintas

-- 2) Cambiar la política de borrado en las tablas: ON DELETE CASCADE: 
-- Este bloque debe ejecutarse una sola vez.

ALTER TABLE appointments
  ADD CONSTRAINT fk_appointments_patient
  FOREIGN KEY (patientid) REFERENCES patient(ssn)
  ON DELETE CASCADE;

ALTER TABLE prescribes
  ADD CONSTRAINT fk_prescribes_patient
  FOREIGN KEY (patientid) REFERENCES patient(ssn)
  ON DELETE CASCADE;

ALTER TABLE stay
  ADD CONSTRAINT fk_stay_patient
  FOREIGN KEY (patientid) REFERENCES patient(ssn)
  ON DELETE CASCADE;

ALTER TABLE undergoes
  ADD CONSTRAINT fk_undergoes_patient
  FOREIGN KEY (patientid) REFERENCES patient(ssn)
  ON DELETE CASCADE;
  

-- Posteriormente, codificar un trigger que impida la eliminacion de pacientes que no cumplan 
-- con las condiciones controladas indicadas anteriormente. Dicho trigger debera proporcionar
-- mensajes de error diferenciados para cada una de las situaciones de error que puedan ocurrir. 

DROP TRIGGER IF EXISTS trg_patient_before_delete;

DELIMITER //

CREATE TRIGGER trg_patient_before_delete
BEFORE DELETE ON patient
FOR EACH ROW
BEGIN
  DECLARE v_cnt INT DEFAULT 0; -- numero de citas, procedimientos, estancias y preescripciones
  DECLARE v_limit DATE; -- fecha limite
  -- calcula la fecha limite dentro del rango de 3 años
  SET v_limit = DATE_SUB(CURDATE(), INTERVAL 3 YEAR); 
  
  
  -- 1) Citas futuras 
  SELECT COUNT(*) INTO v_cnt
  FROM appointments a
  WHERE a.patientid = OLD.ssn
    AND STR_TO_DATE(a.start_dt_time, '%e/%c/%Y') > CURDATE(); -- where ( a.start_dt_time > CurrentDate )

  IF v_cnt > 0 THEN
    SIGNAL SQLSTATE '02000'
      SET MESSAGE_TEXT = 'ERROR 1: No se puede borrar el paciente: tiene citas futuras programadas.';
  END IF;

  -- 2) Procedimientos futuros 
  SELECT COUNT(*) INTO v_cnt
  FROM undergoes u
  WHERE u.patientid = OLD.ssn
    AND STR_TO_DATE(u.`date`, '%e/%c/%Y') > CURDATE();

  IF v_cnt > 0 THEN
    SIGNAL SQLSTATE '02000'
      SET MESSAGE_TEXT = 'ERROR 2: No se puede borrar el paciente: tiene procedimientos futuros programados.';
  END IF;

  -- 3) Estancias futuras (inicio o fin en el futuro) 
  SELECT COUNT(*) INTO v_cnt
  FROM stay s
  WHERE s.patientid = OLD.ssn
    AND (
      STR_TO_DATE(s.start_time, '%e/%c/%Y') > CURDATE()
      OR STR_TO_DATE(s.end_time,   '%e/%c/%Y') > CURDATE()
    );

  IF v_cnt > 0 THEN
    SIGNAL SQLSTATE '02000'
      SET MESSAGE_TEXT = 'ERROR 3: No se puede borrar el paciente: tiene estancias futuras programadas.';
  END IF;

  -- 4) Actividad en últimos 3 años: consultas (citas) 
  SELECT COUNT(*) INTO v_cnt
  FROM appointments a
  WHERE a.patientid = OLD.ssn
    AND STR_TO_DATE(a.start_dt_time, '%e/%c/%Y') >= v_limit;

  IF v_cnt > 0 THEN
    SIGNAL SQLSTATE '02000'
      SET MESSAGE_TEXT = 'ERROR 4: No se puede borrar el paciente: tiene actividad de consultas (citas) en los últimos 3 años.';
  END IF;
  
  -- 5) Actividad en últimos 3 años: procedimientos 
  SELECT COUNT(*) INTO v_cnt
  FROM undergoes u
  WHERE u.patientid = OLD.ssn
    AND STR_TO_DATE(u.`date`, '%e/%c/%Y') >= v_limit;

  IF v_cnt > 0 THEN
    SIGNAL SQLSTATE '02000'
      SET MESSAGE_TEXT = 'ERROR 5: No se puede borrar el paciente: tiene actividad de procedimientos en los últimos 3 años.';
  END IF;

  -- 6) Actividad en últimos 3 años: prescripciones 
  SELECT COUNT(*) INTO v_cnt
  FROM prescribes p
  WHERE p.patientid = OLD.ssn
    AND STR_TO_DATE(p.`date`, '%e/%c/%Y') >= v_limit;

  IF v_cnt > 0 THEN
    SIGNAL SQLSTATE '02000'
      SET MESSAGE_TEXT = 'ERROR 6: No se puede borrar el paciente: tiene actividad de prescripciones en los últimos 3 años.';
  END IF;

  -- 7) Actividad en últimos 3 años: estancias (inicio o fin en ventana) 
  SELECT COUNT(*) INTO v_cnt
  FROM stay s
  WHERE s.patientid = OLD.ssn
    AND (
      STR_TO_DATE(s.start_time, '%e/%c/%Y') >= v_limit
      OR STR_TO_DATE(s.end_time,   '%e/%c/%Y') >= v_limit
    );

  IF v_cnt > 0 THEN
    SIGNAL SQLSTATE '02000'
      SET MESSAGE_TEXT = 'ERROR 7: No se puede borrar el paciente: tiene actividad de estancias en los últimos 3 años.';
  END IF;

END//

DELIMITER ;


-- Incluir tambien todas las sentencias SQL necesarias para probar el trigger en todos
-- los casos (i.e. que se se pueda realizar el borrado correctamente así como los diferentes errores).


-- TEST 1: OK -> Paciente sin actividad ni futuro (DEBE BORRAR)
INSERT INTO patient (ssn, name, address, phonenum, insuranceid, pcpid)
VALUES (400000001, 'TEST_1', 'Calle 1', '600-000-001', 94000001, 1);

DELETE FROM patient WHERE ssn = 400000001;
-- Esperado: OK

-- TEST 2: ERROR -> Tiene CITA FUTURA (appointments)
DELETE FROM patient WHERE ssn = 400000002;
INSERT INTO patient (ssn, name, address, phonenum, insuranceid, pcpid)
VALUES (400000002, 'TEST_2', 'Calle 2', '600-000-002', 94000002, 1);

INSERT INTO appointments (appointmentid, patientid, prepnurseid, physicianid, start_dt_time, end_dt_time, examinationroom)
VALUES (
  94000002, 400000002, 101, 1,
  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 10 DAY), '%e/%c/%Y'),
  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 10 DAY), '%e/%c/%Y'),
  'A'
);

DELETE FROM patient WHERE ssn = 400000002;
-- Esperado: ERROR ... tiene citas futuras ...


-- TEST 3: ERROR -> Tiene PROCEDIMIENTO FUTURO (undergoes)
DELETE FROM patient WHERE ssn = 400000003;
INSERT INTO patient (ssn, name, address, phonenum, insuranceid, pcpid)
VALUES (400000003, 'TEST_3', 'Calle 3', '600-000-003', 94000003, 1);

INSERT INTO stay (stayid, patientid, roomid, start_time, end_time)
VALUES (
  94000003, 400000003, 101,
  DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '%e/%c/%Y'),
  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '%e/%c/%Y')
);

INSERT INTO undergoes (patientid, procedureid, stayid, `date`, physicianid, assistingnurseid)
VALUES (
  400000003, 1, 94000003,
  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 30 DAY), '%e/%c/%Y'),
  1, 101
);

DELETE FROM patient WHERE ssn = 400000003;
-- Esperado: ERROR ... tiene procedimientos futuros ...


-- TEST 4: ERROR -> Tiene ESTANCIA FUTURA (stay)
DELETE FROM patient WHERE ssn = 400000004;
INSERT INTO patient (ssn, name, address, phonenum, insuranceid, pcpid)
VALUES (400000004, 'TEST_4', 'Calle 4', '600-000-004', 94000004, 1);

INSERT INTO stay (stayid, patientid, roomid, start_time, end_time)
VALUES (
  94000004, 400000004, 101,
  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 10 DAY), '%e/%c/%Y'),
  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 12 DAY), '%e/%c/%Y')
);

DELETE FROM patient WHERE ssn = 400000004;
-- Esperado: ERROR ... tiene estancias futuras ...


-- TEST 5: ERROR -> Actividad en últimos 3 años (CITA RECIENTE)
DELETE FROM patient WHERE ssn = 400000005;
INSERT INTO patient (ssn, name, address, phonenum, insuranceid, pcpid)
VALUES (400000005, 'TEST_5', 'Calle 5', '600-000-005', 94000005, 1);

INSERT INTO appointments (appointmentid, patientid, prepnurseid, physicianid, start_dt_time, end_dt_time, examinationroom)
VALUES (
  94000005, 400000005, 101, 1,
  DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 100 DAY), '%e/%c/%Y'),
  DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 100 DAY), '%e/%c/%Y'),
  'B'
);

DELETE FROM patient WHERE ssn = 400000005;
-- Esperado: ERROR ... actividad de consultas (citas) en los últimos 3 años ...


-- TEST 6: ERROR -> Actividad en últimos 3 años (PRESCRIPCIÓN RECIENTE)
DELETE FROM patient WHERE ssn = 400000006;
INSERT INTO patient (ssn, name, address, phonenum, insuranceid, pcpid)
VALUES (400000006, 'TEST_6', 'Calle 6', '600-000-006', 94000006, 1);

-- necesitas una cita porque prescribes tiene FK a appointments
INSERT INTO appointments (appointmentid, patientid, prepnurseid, physicianid, start_dt_time, end_dt_time, examinationroom)
VALUES (
  94000006, 400000006, 101, 1,
  DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 200 DAY), '%e/%c/%Y'),
  DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 200 DAY), '%e/%c/%Y'),
  'C'
);

INSERT INTO prescribes (physicianid, patientid, medicationid, `date`, appointmentid, dose)
VALUES (
  1, 400000006, 1,
  DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 50 DAY), '%e/%c/%Y'),
  94000006, 1
);

DELETE FROM patient WHERE ssn = 400000006;
-- Esperado: ERROR ... actividad de prescripciones en los últimos 3 años ...



-- TEST 7: OK -> Actividad antigua (>3 años) y sin futuro (DEBE BORRAR)
DELETE FROM patient WHERE ssn = 400000007;
INSERT INTO patient (ssn, name, address, phonenum, insuranceid, pcpid)
VALUES (400000007, 'TEST_7', 'Calle 7', '600-000-007', 94000007, 1);

INSERT INTO appointments (appointmentid, patientid, prepnurseid, physicianid, start_dt_time, end_dt_time, examinationroom)
VALUES (94000007, 400000007, 101, 1,
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 5 YEAR), '%e/%c/%Y'),
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 5 YEAR), '%e/%c/%Y'),
        'A');

INSERT INTO prescribes (physicianid, patientid, medicationid, `date`, appointmentid, dose)
VALUES (1, 400000007, 1,
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 5 YEAR), '%e/%c/%Y'),
        94000007, 1);

INSERT INTO stay (stayid, patientid, roomid, start_time, end_time)
VALUES (94000007, 400000007, 101,
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 5 YEAR), '%e/%c/%Y'),
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 5 YEAR), '%e/%c/%Y'));

INSERT INTO undergoes (patientid, procedureid, stayid, `date`, physicianid, assistingnurseid)
VALUES (400000007, 1, 94000007,
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 5 YEAR), '%e/%c/%Y'),
        1, 101);

DELETE FROM patient WHERE ssn = 400000007;
