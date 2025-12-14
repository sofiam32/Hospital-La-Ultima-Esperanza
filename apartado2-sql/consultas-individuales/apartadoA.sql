-- Apartado A
-- Usando los ficheros hospital_tables.sql y hospital_data.sql disponibles en Moodle,
-- crear la base de datos hospital management system y cargar todos los datos disponibles
-- que van a ser objeto de procesos en puntos posteriores.

DROP DATABASE IF EXISTS hospital_management_system;

SOURCE ../preset-data-creation/hospital_tables.sql;
USE hospital_management_system;
SOURCE ../preset-data-creation/hospital_data.sql;
