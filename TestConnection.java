import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
 
public class TestConnection {
 
  public static void main(String[] argv) throws ClassNotFoundException {
        Connection conn = null;
     
        String driver = "com.mysql.cj.jdbc.Driver";
        String host   = System.getenv("MYSQL_HOST");
        String db     = System.getenv("MYSQL_DATABASE");
        String url    = "jdbc:mysql://" + host + "/" + db;
        String user   = System.getenv("MYSQL_USER");
        String pass   = System.getenv("MYSQL_PASSWORD");
  
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("Connected to database : " + db);
            System.exit(0);
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage());
            System.out.println("SQLState: " + e.getSQLState());
            System.out.println("VendorError: " + e.getErrorCode());
            System.exit(1);
        }
     
    }

}