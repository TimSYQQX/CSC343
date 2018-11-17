import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
//import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
//import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {

    private Connection connection;

    public Assignment2() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
        try {
		    this.connection = DriverManager.getConnection(URL, username, password);
		    String setpath = "SET search_path TO parlgov, public;";
		    PreparedStatement statement = this.connection.prepareStatement(setpath);
		    statement.execute();
		    return true;
	    } catch (SQLException se) {
			// TODO Auto-generated catch block
		    System.err.println("SQL Exception." +
	            "<Message>: " + se.getMessage());
	    }
        return false;
       
    }

    @Override
    public boolean disconnectDB() {
        try {
		    this.connection.close();
		    return true;
	    } catch (SQLException se) {
		    // TODO Auto-generated catch block
		    System.out.println("2");
		    System.err.println("SQL Exception." +
                "<Message>: " + se.getMessage());
	    }
        return false;
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
        return null;
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // Implement this method!
        return null;
    }

    public static void main(String[] args) {
        Assignment2 a2;
        try {
            a2 = new Assignment2();
            String URL = "jdbc:postgresql://localhost:5432/csc343h-zhan1539";
            a2.connectDB(URL, "zhan1539", "Leonzhang1996");
              
              
            ArrayList result = a2.electionSequence("Canada");
            for(int i = 0; i < result.size(); i ++) {
                System.out.println(result.get(i));
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            System.err.println("SQL Exception." +
                  "<Message>: " + e.getMessage());
        }
    }

}

