-- Apartado M
-- Codifica una funcion almacenada denominada 'calc_stay_cost' que calcule y devuelva el
-- coste total de una estancia pasada como parámetro. Para determinar dicho coste, considera 
-- que las habitaciones de tipo ICU tienen un coste de 500e/día, las Single de 300e/día, las
-- Double de 150e/día y otros tipos de habitaciones tienen un coste de 100e/día. Para determinar
-- la duración de una estancia busca información a cerca de las funciones 'DATEDIFF' y 'STR_TO_DATE'. 
-- Incluye tambien todas las sentencias SQL necesarias para probar la función almacenada.

Delimiter $$
create function calc_stay_cost(stayid int)
returns int
Deterministic
begin
	-- Declaro las variables locales.
	declare room_type varchar(8);
	declare start_time varchar(10);
	declare end_time varchar(10);
	declare start_date date;
	declare end_date date;
	declare stay_time int;
	declare actual int;
	declare total int;

	-- Selecciono en que variables voy a guardar los datos
	select stay.start_time, stay.end_time, room.roomtype
    into start_time, end_time, room_type
	from stay join room on stay.roomid = room.roomnumber
    WHERE stay.stayid = stayid;

	-- Paso de string a date las fechas y cálculo los días de estancia.
	set start_date = STR_TO_DATE(start_time, '%d/%m/%Y');
	set end_date = STR_TO_DATE(end_time, '%d/%m/%Y');
	set stay_time = datediff(end_date, start_date) + 1;

	-- En función del tipo de habitación tiene un precio diferente.
	set actual = case room_type
		when 'ICU' then 500
		when 'Single' then 300
		when 'Double' then 150
		else 100
	end;

	-- Calculo el precio total de la estancia (precio de la habitacion por la cantidad de días de la estancia).
	set total = actual*stay_time;
	return total;
end $$
Delimiter ;

-- Caso de prueba cuyo resultado es 600 ya que tiene 2 días de estancia.
SELECT calc_stay_cost(3217) AS total_cost;
