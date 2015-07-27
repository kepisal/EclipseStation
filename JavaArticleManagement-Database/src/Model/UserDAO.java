package Model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Utilities.DatabaseConnection;

public class UserDAO {
	/**
	 * comparing userName or email of user
	 * @param userNameOrEmail: string username or email to compare
	 * @return boolean if either username or email is found 
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	public boolean compareUserNameOrEmail(String userNameOrEmail) throws ClassNotFoundException, SQLException{
		try(Connection con = DatabaseConnection.getConnection()) {			
			PreparedStatement stm = con.prepareStatement("SELECT id FROM tbuser WHERE username = ? OR email = ?");
			stm.setString(1, userNameOrEmail);
			stm.setString(2, userNameOrEmail);
			ResultSet rs = stm.executeQuery();
			rs.next();			
			if (rs.getInt(1)>0) return true;			
		}	
		return false;		
	}
	/**
	 * comparing password of user
	 * @param password: string to compare password
	 * @return boolean if password if found
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	public boolean comparePassword(String password) throws ClassNotFoundException, SQLException{
		try(Connection con = DatabaseConnection.getConnection()) {			
			PreparedStatement stm = con.prepareStatement("SELECT id FROM tbuser WHERE password = ?");
			stm.setString(1, password);
			ResultSet rs = stm.executeQuery();
			rs.next();			
			if (rs.getInt(1)>0) return true;			
		}	
		return false;			
	}
}

