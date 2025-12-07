-- Apartado B
-- Obtener los nombres de los doctores, los medicamentos y la fecha de prescripcion
-- de los mismos de aquellos doctores que están afiliados al departamento de 
-- “General Medicine” y que han recetado algun medicamento en el año 2023 o 2024.

select physician.name, medication.name, prescribes.date
from physician join prescribes on physician.employeeid = prescribes.physicianid
join medication	on prescribes.medicationid = medication.code
join affiliated_with on physician.employeeid = affiliated_with.physicianid
join department on affiliated_with.departmentid = department.departmentid
where department.name = 'General Medicine' and (prescribes.date like '%2023' or prescribes.date like '%2024');
