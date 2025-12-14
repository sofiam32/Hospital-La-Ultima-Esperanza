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


## 👥 Autores
|     Nombre      |   Matrícula   |
| --------------- | ------------- |
| Sofía Merino    | **bv0143**    |
| Alicia Lafuente | **bv0195**    |
| Jiling Li       | **bv0393**    |
| Marta Lozano    | **bv0078**    |
| Tomás Juárez    | **bv0374**    |

## 📁 Entregables

### I. Apartado 1: Modelado y Diseño (Formato PDF)

El primer apartado, centrado en el **Modelado Conceptual y el Paso al Modelo Relacional** de la base de datos hospitalaria, se entrega en formato pdf, ajuntando también un fichero de texto que contiene el enlace al documento de LucidChart que hemos utilizado para realizarlo.

En esta parte además hemos añadido memorias justificativas, también en formato pdf.

---

### II. Apartado 2: Consultas Avanzadas (SQL)

Este apartado comprende la creación de vistas, *triggers*, funciones y consultas complejas para automatizar la gestión de datos.

* **Documentación Detallada:** El corazón de la entrega del Apartado 2 es el fichero **`resultados-consultas.md`**, donde se encuentra:
    * El enunciado completo de cada subapartado.
    * El **código SQL**.
    * Una **captura del resultado de la ejecución** para cada consulta.

* **Script Unificado:** Se incluye un script con todas las sentencias SQL organizadas para su ejecución secuencial en el gestor de bases de datos.
    * **Fichero:** `todas-consultas.sql`
  
* **Scripts Modularizados:** Se incluye un script por apartado. Aquí se encuentra el código más comentado y explicado.
    * **Paquete:** `consultas-individuales/`

* **Scripts de Base de Datos:** Se incluyen los ficheros `.sql` necesarios para la creación de la base de datos y la carga de datos (`preset-data-creation/hospital_tables.sql` y `preset-data-creation/hospital_data.sql`).

---

### III. Apartado 3: Programación (JDBC)

El último apartado incluye la programación de utilidades de gestión en Java que interactúan con la base de datos utilizando la tecnología JDBC.

La estructura de este apartado está diseñada para facilitar la compilación y prueba de las soluciones:

* **Apartados 3.1 y 3.2:** En ficheros `.sql` separados.

* **Carpetas de Soluciones para los apartados 3.3 y 3.4:** Se han creado dos carpetas, una por cada requisito de programación:

| Carpeta | Contenido |
| :--- | :--- |
| **`Apartado 3.3`** | **Fichero .java:** Código fuente para generar un csv. <br>**Fichero .jar:** Versión compilada y ejecutable. <br>**Ejemplo de Salida:** Muestra un resultado real de la ejecución del `.jar`. |
| **`Apartado 3.4`** | **Fichero .java:** Código fuente para generar un xml. <br>**Fichero .jar:** Versión compilada y ejecutable. <br>**Ejemplo de Salida:** Muestra un resultado real de la ejecución del `.jar`. |

**Nota sobre credenciales:** El código `.java` utiliza *placeholders* genéricos para las credenciales de la base de datos (`USER_PLACEHOLDER`, `PASS_PLACEHOLDER`) para mantener la seguridad del repositorio.
