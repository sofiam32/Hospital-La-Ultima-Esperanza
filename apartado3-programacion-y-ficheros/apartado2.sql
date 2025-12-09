-- Apartado 2
-- Añade un usuario a la base de datos y dale permiso de lectura sobre la vista anteriormente creada. 

CREATE USER 'usuario_lector' IDENTIFIED BY 'contraseña123';

GRANT SELECT ON hospital_management_system.medication_prescribed TO 'usuario_lector';

-- Consulto sus permisos para verificar que se han aplicado correctamente

SHOW GRANTS FOR 'usuario_lector';

-- Elimino el usuario de prueba para mantener la integridad de los datos

DROP USER 'usuario_lector';