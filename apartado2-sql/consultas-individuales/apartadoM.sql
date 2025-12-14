-- Apartado M
-- Codifica una funcion almacenada denominada 'calc_stay_cost' que calcule y devuelva el
-- coste total de una estancia pasada como parámetro. Para determinar dicho coste, considera 
-- que las habitaciones de tipo ICU tienen un coste de 500e/día, las Single de 300e/día, las
-- Double de 150e/día y otros tipos de habitaciones tienen un coste de 100e/día. Para determinar
-- la duración de una estancia busca información a cerca de las funciones 'DATEDIFF' y 'STR_TO_DATE'. 
-- Incluye tambien todas las sentencias SQL necesarias para probar la función almacenada.

DELIMITER $$
CREATE FUNCTION calc_stay_cost(stayid INT)
RETURNS INT
DETERMINISTIC
BEGIN
	-- Declaro las variables locales.
	DECLARE room_type VARCHAR(8);
	DECLARE start_time VARCHAR(10);
	DECLARE end_time VARCHAR(10);
	DECLARE start_date DATE;
	DECLARE end_date DATE;
	DECLARE stay_time INT;
	DECLARE actual INT;
	DECLARE total INT;

	-- Selecciono en que variables voy a guardar los datos
	SELECT stay.start_time, stay.end_time, room.roomtype
    INTO start_time, end_time, room_type
	FROM stay JOIN room ON stay.roomid = room.roomnumber
    WHERE stay.stayid = stayid;

	-- Paso de string a date las fechas y cálculo los días de estancia.
	SET start_date = STR_TO_DATE(start_time, '%d/%m/%Y');
	SET end_date = STR_TO_DATE(end_time, '%d/%m/%Y');
	SET stay_time = datediff(end_date, start_date) + 1;

	-- En función del tipo de habitación tiene un precio diferente.
	SET actual = CASE room_type
		WHEN 'ICU' THEN 500
		WHEN 'Single' THEN 300
		WHEN 'Double' THEN 150
		ELSE 100
	END;

	-- Calculo el precio total de la estancia (precio de la habitacion por la cantidad de días de la estancia).
	SET total = actual*stay_time;
	RETURN total;
END $$
DELIMITER ;

-- Caso de prueba cuyo resultado es 600 ya que tiene 2 días de estancia.
SELECT calc_stay_cost(3217) AS total_cost;