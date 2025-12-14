-- Apartado G
-- Obtener el personal de enfermería que siempre han estado asignadas a
-- turnos en el mismo sitio (bloque y piso) y que, además, si han participado en 
-- procedimientos médicos, siempre haya sido con el mismo doctor.

SELECT n.employeeid,
       n.name,
       oc.blockfloorid,
       oc.blockcodeid,
       u.only_physicianid AS physicianid
FROM nurse n
JOIN (
    SELECT nurseid,
           MIN(blockfloorid) AS blockfloorid,
           MIN(blockcodeid)  AS blockcodeid
    FROM on_call
    GROUP BY nurseid
    HAVING COUNT(DISTINCT CONCAT(blockfloorid,'-',blockcodeid)) = 1
) oc
  ON oc.nurseid = n.employeeid
LEFT JOIN (
    SELECT assistingnurseid,
           COUNT(*) AS num_procs,
           COUNT(DISTINCT physicianid) AS num_docs,
           MIN(physicianid) AS only_physicianid
    FROM undergoes
    GROUP BY assistingnurseid
) u
  ON u.assistingnurseid = n.employeeid
WHERE
   u.assistingnurseid IS NULL      -- no participó en procedimientos
   OR u.num_docs = 1               -- participó con el mismo doctor
ORDER BY n.employeeid;
