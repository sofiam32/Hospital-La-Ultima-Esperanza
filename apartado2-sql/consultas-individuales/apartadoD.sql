-- Apartado D
-- Actualizar la descripción de los medicamentos agregando la nota de
-- “Possible discontinuation” (posible descatalogación) a aquellos que
-- no han sido recetados durante los últimos dos años por doctores
-- pertenecientes al departamento de “General Medicine”, evitando
-- además incluir aquellos que ya contengan dicha advertencia en su descripción actual.

UPDATE medication m
SET m.description = CONCAT(
    IFNULL(m.description, ''),
    CASE
      WHEN m.description IS NULL OR m.description = '' THEN 'Possible discontinuation'
      ELSE ' - Possible discontinuation'
    END
)
WHERE m.code NOT IN (
    SELECT DISTINCT pr.medicationid
    FROM prescribes pr
    JOIN physician ph ON pr.physicianid = ph.employeeid
    JOIN affiliated_with aw ON ph.employeeid = aw.physicianid
    JOIN department d ON aw.departmentid = d.departmentid
    WHERE d.name = 'General Medicine'
      AND DATEDIFF(CURDATE(), STR_TO_DATE(pr.date, '%d/%m/%Y')) <= 730
)
AND (m.description IS NULL OR m.description NOT LIKE '%Possible discontinuation%');

-- Prueba
SELECT * FROM medication;
