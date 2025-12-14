-- Apartado E
-- Obtener un listado detallado de los doctores del hospital, mostrando
-- para cada uno su nombre, el número total de procedimientos realizados,
-- el coste total de dichos procedimientos y el coste promedio por procedimiento.
-- Los resultados deben estar ordenados de mayor a menor segun el número de procedimientos realizados.

SELECT p.name AS NAME_PHYSICIAN, ab.NUM_P, ab.T_COSTE, ab.MED_C
FROM physician p JOIN (SELECT physicianid, COUNT(*) AS NUM_P, SUM(cost) AS T_COSTE, AVG(cost) AS MED_C
            						FROM (SELECT p.code, p.cost , u.physicianid  
            								  FROM undergoes u JOIN medical_procedure p ON u.procedureid = p.code)a
            						GROUP BY physicianid  
            						) ab ON p.employeeid = ab.physicianid
									ORDER BY ab.NUM_P DESC;
