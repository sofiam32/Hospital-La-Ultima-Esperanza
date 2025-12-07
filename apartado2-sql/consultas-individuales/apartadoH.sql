-- Apartado H
-- Obtener para cada medicamento (código y nombre) el número total de veces
-- que ha sido prescrito, el nombre del doctor que mas lo ha recetado (si existen
-- empates mostrar todos los doctores empatados), y la dosis promedio recetada. Ordenar los
-- resultados de mayor a menor segun el número total de prescripciones. Tener en cuenta que
-- si existen empates entre los doctores se tienen que mostrar todos los doctores, cada uno en
-- una fila distinta.

SELECT 
    m.code AS codigo_medicamento,
    m.name AS nombre_medicamento,
    t1.total_prescripciones,
    p.name AS doctor_mas_recetador,
    t1.dosis_promedio_recetada
FROM
    medication m
JOIN
(
    -- Calcula los agregados totales y encuentra la máxima frecuencia por medicamento.
    SELECT  p1.medicationid, 
            COUNT(*) AS total_prescripciones, 
            AVG(p1.dose) AS dosis_promedio_recetada,
            (
                SELECT MAX(conteo)
                FROM (
                    SELECT p2.physicianid, COUNT(*) AS conteo
                    FROM prescribes p2
                    WHERE p2.medicationid = p1.medicationid
                    GROUP BY p2.physicianid
                ) AS frecuencia_por_doctor
            ) AS max_frecuencia_doctor
    FROM prescribes p1
    GROUP BY p1.medicationid
) AS t1 ON t1.medicationid = m.code
JOIN physician p ON p.employeeid IN (
    -- Encuentra los doctores que tienen la máxima frecuencia por medicamento.
    SELECT p3.physicianid
    FROM prescribes p3
    WHERE p3.medicationid = t1.medicationid
    GROUP BY p3.physicianid
    HAVING COUNT(*) = t1.max_frecuencia_doctor
)
ORDER BY t1.total_prescripciones DESC;