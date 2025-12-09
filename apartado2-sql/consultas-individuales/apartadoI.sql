-- Apartado I
-- Obtener el nombre de los medicamentos que han sido prescritos por
-- todos los doctores pertenecientes a mas de un departamento diferente. 

SELECT m.name
FROM medication m
WHERE m.code IN (
    -- S1: Identifica los IDs de los medicamentos
    -- prescritos por cada doctor en el conjunto de doctores del S2
    SELECT p.medicationid
    FROM prescribes p
    WHERE p.physicianid IN (
        -- S2: Obtiene los IDs de los doctores
        -- que pertenecen a más de un departamento.
        SELECT a.physicianid
        FROM affiliated_with a
        GROUP BY a.physicianid
        HAVING COUNT(*) > 1 -- Cuenta los departamentos por doctor y filtra los que tienen más de 1.
    )
    GROUP BY p.medicationid
    HAVING COUNT(DISTINCT p.physicianid) = (
        SELECT COUNT(T.physicianid)
        FROM (
            -- S2: La misma consulta para contar el número total de doctores elegibles.
            SELECT a.physicianid
            FROM affiliated_with a
            GROUP BY a.physicianid
            HAVING COUNT(*) > 1
        ) AS T
    )
);
