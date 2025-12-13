import java.sql.*;
import java.io.FileWriter;
import java.io.IOException;

public class Apartado3 {

    // Datos de conexión
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/hospital_management_system";
    private static final String USER = "USER_PLACEHOLDER";
    private static final String PASSWORD = "PASSWORD_PLACEHOLDER";

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Uso: java ExportCSV <SSN_Paciente>");
        } else {
            Apartado3.run(args);
        }
    }

    private static void run(String[] args) {

        final String PATIENTID = args[0];

        // Consulta: solo prescripciones del paciente indicado
        final String QUERY =
                "SELECT med_code, med_name, med_brand, patient_ssn, patient_name, " +
                        "prescription_date, physician_name " +
                        "FROM medication_prescribed WHERE patient_ssn = ?";

        try (
                Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                PreparedStatement stmt = conn.prepareStatement(QUERY)
        ) {

            // Sustituimos el ? por el parámetro recibido
            stmt.setString(1, PATIENTID);

            // Ejecutamos la consulta
            ResultSet rs = stmt.executeQuery();

            // Comprobamos si hay resultados
            if (!rs.isBeforeFirst()) {
                System.out.println("No se encontraron prescripciones para el paciente " + PATIENTID);
                return;
            }

            // Solo creamos el CSV si hay datos
            try (FileWriter writer = new FileWriter("prescripciones_" + PATIENTID + ".csv")) {

                final String SEPARADOR = ",";
                writer.write(
                        "Código" + SEPARADOR +
                                "Nombre" + SEPARADOR +
                                "Marca" + SEPARADOR +
                                "SSN" + SEPARADOR +
                                "Paciente" + SEPARADOR +
                                "Fecha" + SEPARADOR +
                                "Doctor\n"
                );

                // Recorremos los resultados
                while (rs.next()) {
                    writer.write(
                            rs.getString("med_code") + SEPARADOR +
                                    rs.getString("med_name") + SEPARADOR +
                                    rs.getString("med_brand") + SEPARADOR +
                                    rs.getString("patient_ssn") + SEPARADOR +
                                    rs.getString("patient_name") + SEPARADOR +
                                    rs.getString("prescription_date") + SEPARADOR +
                                    rs.getString("physician_name") + "\n"
                    );
                }

                System.out.println("CSV generado correctamente: prescripciones_" + PATIENTID + ".csv");
            }

        } catch (SQLException | IOException e) {
            e.printStackTrace();
        }
    }
}