// Apartado 4
// Codifica un programa en Java que permita exportar los resultados de la vista anterior, filtrados
// para un identificador de paciente pasado como parámetro, en un fichero XML.

import java.sql.*;
import java.io.FileWriter;
import java.io.IOException;

public class Apartado4 {

    // Datos de conexión
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/hospital_management_system";
    private static final String USER = "USER_PLACEHOLDER";
    private static final String PASSWORD = "PASSWORD_PLACEHOLDER";

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Uso: java ExportXML <SSN_Paciente>");
        } else {
            Apartado4.run(args[0]);
        }
    }

    private static void run(String patientSSN) {

        // Consulta
        final String QUERY =
                "SELECT med_code, med_name, med_brand, patient_ssn, patient_name, " +
                        "prescription_date, physician_name " +
                        "FROM medication_prescribed WHERE patient_ssn = ?";

        try (
                Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                PreparedStatement stmt = conn.prepareStatement(QUERY)
        ) {

            stmt.setString(1, patientSSN);
            ResultSet rs = stmt.executeQuery();

            // Comprobamos si hay resultados
            if (!rs.isBeforeFirst()) {
                System.out.println("No se encontraron prescripciones para el paciente " + patientSSN);
                return;
            }

            // Creamos el fichero XML solo si hay datos
            try (FileWriter writer = new FileWriter("prescripciones_" + patientSSN + ".xml")) {

                // Cabecera XML
                writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
                writer.write("<prescripciones>\n");

                while (rs.next()) {
                    writer.write("    <prescripcion>\n");
                    writer.write("        <codigo>" + rs.getString("med_code") + "</codigo>\n");
                    writer.write("        <nombre>" + rs.getString("med_name") + "</nombre>\n");
                    writer.write("        <marca>" + rs.getString("med_brand") + "</marca>\n");
                    writer.write("        <ssn>" + rs.getString("patient_ssn") + "</ssn>\n");
                    writer.write("        <paciente>" + rs.getString("patient_name") + "</paciente>\n");
                    writer.write("        <fecha>" + rs.getString("prescription_date") + "</fecha>\n");
                    writer.write("        <medico>" + rs.getString("physician_name") + "</medico>\n");
                    writer.write("    </prescripcion>\n");
                }

                writer.write("</prescripciones>\n");

                System.out.println("XML generado correctamente: prescripciones_" + patientSSN + ".xml");
            }

        } catch (SQLException | IOException e) {
            e.printStackTrace();
        }
    }
}