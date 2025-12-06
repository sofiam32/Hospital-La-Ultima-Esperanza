-- Apartado K
-- Con el diseno actual de la base de datos, la política de gestion de borrados de pacientes no 
-- permite llevar a cabo el borrado de aquellos pacientes que tengan asociado cualquier tipo de
-- información médica sobre ellos. Sin embargo, se desea cambiar esta política de manera que
-- se permita eliminar pacientes bajo condiciones controladas: no tener citas o procedimientos
-- médicos futuros programados y no tener registrado en la base de datos ningún tipo de información
-- de actividad médica (consultas, procedimientos, prescriciones o estancias) durante los últimos 3 años.

-- Para poder realizar esta gestión, primeramente generar las sentencias SQL necesarias para 
-- permitir el borrado de pacientes de la bases de datos aunque tengan asociados datos (se
-- borrarán los datos del resto de tablas que tengan asociados).

-- Posteriormente, codificar un trigger que impida la eliminacion de pacientes que no cumplan 
-- con las condiciones controladas indicadas anteriormente. Dicho trigger debera proporcionar
-- mensajes de error diferenciados para cada una de las situaciones de error que puedan
-- ocurrir. Incluir tambien todas las sentencias SQL necesarias para probar el trigger en todos
-- los casos (i.e. que se se pueda realizar el borrado correctamente así como los diferentes errores).
