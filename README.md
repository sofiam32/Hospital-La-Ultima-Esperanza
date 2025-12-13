# 🏥 Hospital La Última Esperanza — Práctica Base de Datos 2025-2026

## 🗂️ Descripción
Proyecto desarrollado como parte de la asignatura **Bases de Datos** (Grado en Ingeniería del Software, ETSISI-UPM) por el grupo **IWSIM22_10**.
El trabajo consiste en diseñar y construir un sistema completo de gestión hospitalaria para el centro ficticio *La Última Esperanza*, siguiendo las especificaciones dadas en la práctica.

El objetivo del proyecto es implementar un sistema capaz de:
- Diseñar el modelado conceptual del hospital mediante un diagrama Entidad–Relación en notación Chen.
- Transformar dicho modelo al modelo lógico y relacional, generando las tablas necesarias.
- Crear la base de datos hospitalaria, cargar datos iniciales y desarrollar consultas SQL avanzadas.
- Implementar triggers que controlan certificaciones de doctores y reglas de borrado de pacientes.
- Programar funciones almacenadas para el cálculo de costes de estancias y procedimientos.
- Crear procedimientos almacenados que generen informes de actividad médica.
- Diseñar una vista SQL para consultar medicamentos prescritos.
- Desarrollar en Java un sistema capaz de exportar datos de la vista en formato CSV y XML, filtrados por paciente.


## 📚 Contenido del proyecto
**1. Modelado (Entidad–Relación)**
- Diseño conceptual en notación Chen.
- Identificación de entidades, atributos, relaciones, cardinalidades y restricciones.
- Memoria sobre las decisiones de diseño.
- Documento de semántica no contemplada.
- Diseño del paso a tablas.

**2. SQL**
Incluye todo lo solicitado en el enunciado:
- Creación de la base de datos hospitalaria.
- Carga de datos mediante los ficheros proporcionados.
- Consultas avanzadas sobre doctores, pacientes, procedimientos y prescripciones.
- Actualizaciones con condiciones.
- Triggers de validación y control de borrado.
- Funciones almacenadas para cálculo de costes.
- Procedimientos almacenados para generar informes.
- Conjunto de pruebas SQL para validar cada elemento.

**3. Programación en Java**
Aplicaciones desarrolladas para:
- Diseño de una vista de de medicamentos prescritos.
- Creación de un usuario a la base de datos.
- Exportar la información filtrada por paciente a:
    - CSV
    - XML


## ▶️ Cómo ejecutar el proyecto
**1. Crear y cargar la base de datos**  
&nbsp;&nbsp;&nbsp;&nbsp;source hospital_tables.sql;  
&nbsp;&nbsp;&nbsp;&nbsp;source hospital_data.sql;

**2. Ejecutar las consultas del proyecto**  
&nbsp;&nbsp;&nbsp;&nbsp;source consultas.sql;

**3. Probar triggers, funciones y procedimientos**  
&nbsp;&nbsp;&nbsp;&nbsp;source pruebas.sql;

**4. Compilar y ejecutar los programas Java**  
Compilar:  
&nbsp;&nbsp;&nbsp;&nbsp;javac src/*.java  

Ejecutar:  
&nbsp;&nbsp;&nbsp;&nbsp;java ExportCSV <id_paciente>  
&nbsp;&nbsp;&nbsp;&nbsp;java ExportXML <id_paciente>



## 👥 Autores
|     Nombre      |   Matrícula   |
| --------------- | ------------- |
| Sofía Merino    | **bv0143**    |
| Alicia Lafuente | **bv0195**    |
| Jiling Li       | **bv0393**    |
| Marta Lozano    | **bv0078**    |
| Tomás Juárez    | **bv0374**    |


## 📦 Entregables
Modelo E-R + Semántica no contemplada + tablas + dominios  
Consultas SQL (a–i)  
Triggers, funciones y procedimientos almacenados (j–n)  
Vista + usuario con permisos  
Programas Java (CSV y XML)
