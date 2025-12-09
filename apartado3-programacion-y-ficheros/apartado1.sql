-- Apartado 1
-- Diseña una vista que permita consultar los medicamentos prescritos. La vista debe incluir el código,
-- nombre y marca del medicamento, el nombre del paciente al que se le realizó la prescripción,
-- la fecha de dicha prescripción y el nombre del doctor responsable.

CREATE OR REPLACE VIEW hospital_management_system.medication_prescribed AS
        
        SELECT pr.medicationid AS med_code,
               m.name AS med_name,
               m.brand AS med_brand,
               pa.name AS patient_name,
               pr.date AS prescription_date,
               ph.name AS physician_name 
        FROM prescribes pr
        JOIN medication m ON pr.medicationid = m.code
        JOIN patient pa ON pr.patientid = pa.ssn
        JOIN physician ph ON pr.physicianid = ph.employeeid;
