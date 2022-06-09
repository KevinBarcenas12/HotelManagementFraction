package backend;

import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.SQLException;

public class Database {
    
    private final String filename;
    private Connection conn;
    public Statement query;
    
    public Database(String filename) {
        this.filename = filename + ".accdb";
    }
    
    public boolean connect() {
        try {
            Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
            String driver = "jdbc:ucanaccess://";
            conn = DriverManager.getConnection(driver + filename, "", "");
            query = conn.createStatement();
        }
        catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
    
    public boolean disconnect() {
        try {
            query.close();
            conn.close();
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
    
    public boolean commit() {
        try {
            conn.commit();
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
    
}
