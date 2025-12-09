-- Apartado C
-- Obtener el nombre del paciente con el ingreso más largo y el paciente con
-- el ingreso más corto en el hospital, mostrando para cada uno su nombre, el
-- número de habitación donde estuvo ingresado, así como el piso y bloque de la misma, la
-- duración de la estancia en días y el tipo de estancia (mas largo o más corto).

(
	-- Consulta para el paciente con el ingreso más largo
	SELECT 
		p.name AS Pacient_Name, 
		r.roomnumber AS Room_Number, 
		r.blockfloorid AS Floor_Number, 
		r.blockcodeid AS Block_Code,
		DATEDIFF(STR_TO_DATE(s.end_time, '%d/%m/%Y'), STR_TO_DATE(s.start_time, '%d/%m/%Y')) AS Duration_Days,
		'The Longest' AS Stay_Type
	FROM 
		patient p
	INNER JOIN
		stay s ON p.ssn = s.patientid
	INNER JOIN 
		room r ON s.roomid = r.roomnumber
	WHERE
        DATEDIFF(STR_TO_DATE(s.end_time, '%d/%m/%Y'), STR_TO_DATE(s.start_time, '%d/%m/%Y')) = (
            SELECT
                MAX(DATEDIFF(STR_TO_DATE(end_time, '%d/%m/%Y'), STR_TO_DATE(start_time, '%d/%m/%Y')))
            FROM
                stay
        )
    LIMIT 1
)
UNION ALL
(
 -- Consulta para el paciente con el ingreso más corto
 SELECT 
		p.name AS Pacient_Name, 
		r.roomnumber AS Room_Number, 
		r.blockfloorid AS Floor_Number, 
		r.blockcodeid AS Block_Code,
		DATEDIFF(STR_TO_DATE(s.end_time, '%d/%m/%Y'), STR_TO_DATE(s.start_time, '%d/%m/%Y')) AS Duration_Days,
		'The Shortest' AS Stay_Type
	FROM 
		patient p
	INNER JOIN
		stay s ON p.ssn = s.patientid
	INNER JOIN 
		room r ON s.roomid = r.roomnumber
	WHERE
        DATEDIFF(STR_TO_DATE(s.end_time, '%d/%m/%Y'), STR_TO_DATE(s.start_time, '%d/%m/%Y')) = (
            SELECT
                MIN(DATEDIFF(STR_TO_DATE(end_time, '%d/%m/%Y'), STR_TO_DATE(start_time, '%d/%m/%Y')))
            FROM
                stay
        )
    LIMIT 1
);
 
