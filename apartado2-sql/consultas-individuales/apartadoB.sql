-- Apartado B
-- Obtener los nombres de los doctores, los medicamentos y la fecha de prescripcion
-- de los mismos de aquellos doctores que están afiliados al departamento de 
-- “General Medicine” y que han recetado algun medicamento en el año 2023 o 2024.

SELECT physician.name, medication.name, prescribes.date
FROM physician JOIN prescribes ON physician.employeeid = prescribes.physicianid
JOIN medication	ON prescribes.medicationid = medication.code
JOIN affiliated_with ON physician.employeeid = affiliated_with.physicianid
JOIN department ON affiliated_with.departmentid = department.departmentid
WHERE department.name = 'General Medicine' AND (prescribes.date LIKE '%2023' OR prescribes.date LIKE '%2024');
