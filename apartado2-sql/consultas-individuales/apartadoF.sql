-- Apartado F
-- Obtener los doctores (nombre y posicion) que han realizado todos los
-- procedimientos médicos con coste superior a 5000 y que haya realizado
-- más de 3 procedimientos médicos de cualquiera de los tipos en total.

SELECT p.name, p.position FROM physician p
WHERE 
    -- El doctor ha realizado todos los procedimientos medicos con coste superior a 5000
    NOT EXISTS (
            SELECT mp.code FROM medical_procedure mp
            WHERE mp.cost > 5000
            AND mp.code NOT IN (
                    SELECT u.procedureid FROM undergoes u
                    WHERE u.physicianid = p.employeeid
                )
        )
    -- El médico ha realizado más de 3 procedimientos médicos en total
    AND p.employeeid IN (
        SELECT u2.physicianid FROM undergoes u2
        GROUP BY u2.physicianid
        HAVING COUNT(*) > 3
    );
