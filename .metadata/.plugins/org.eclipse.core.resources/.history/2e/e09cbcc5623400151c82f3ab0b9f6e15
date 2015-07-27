package Utilities;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

import Controller.Logger;

/*
 * Utilities
 * -- Database Connection
 * */
public class DatabaseConnection {
	private static Logger logger = Logger.getLogger();
	private static String DRIVER_NAME = "org.postgresql.Driver";
	private static String URL = "jdbc:postgresql://localhost:";
	private static String PORT_NUMBER = "5432";
	private static String DB_NAME = "autodbarticle";
	private static String USER_NAME = "postgres";
	private static String PASSWORD = "123";

	/**
	 * Deny object initialization
	 */
	private DatabaseConnection() {}
	
	/**
	 * connect to database
	 * 
	 * @return object connection to a database
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	public static Connection getConnection() throws SQLException,
			ClassNotFoundException {
		Class.forName(DRIVER_NAME);
		Connection con = DriverManager.getConnection(URL + PORT_NUMBER + "/"
				+ DB_NAME, USER_NAME, PASSWORD);
		return con;
	}
	
	/**
	 * reset database by dropping table and their sequences
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	private static void resetDatabase() throws ClassNotFoundException, SQLException{
		Connection con = getConnection();
		PreparedStatement stm = con.prepareStatement("DROP SEQUENCE IF EXISTS \"art_id_seq\" CASCADE; " 
		+"DROP SEQUENCE IF EXISTS \"delete_id_seq\" CASCADE;" 
		+"DROP SEQUENCE IF EXISTS \"insert_id_seq\" CASCADE;"
		+"DROP SEQUENCE IF EXISTS \"update_id_seq\" CASCADE;"
		+"DROP SEQUENCE IF EXISTS \"user_id_seq\" CASCADE;"
		+"DROP TABLE IF EXISTS \"tbarticle\" CASCADE;"
		+"DROP TABLE IF EXISTS \"tbarticle_audit_on_delete\" CASCADE;"
		+"DROP TABLE IF EXISTS \"tbarticle_audit_on_insert\" CASCADE;"
		+"DROP TABLE IF EXISTS \"tbarticle_audit_on_update\" CASCADE;" 
		+"DROP TABLE IF EXISTS \"tbuser\" CASCADE;");
		stm.execute();	
		con.close();
		stm.close();
	}
		
	/**
	 * check whether if database is exist
	 * 
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 * @throws IOException
	 */
	private static boolean checkDatabase() throws ClassNotFoundException,
			SQLException, IOException {
		// DO NOT USE getConnection() in this function
		// there will be error when there is no database
		Connection con = DriverManager.getConnection(URL + PORT_NUMBER + "/",
				USER_NAME, PASSWORD);
		PreparedStatement stm = con
				.prepareStatement("SELECT datname FROM pg_database WHERE datname='"
						+ DB_NAME + "';");
		ResultSet rs = stm.executeQuery();
		boolean hasDB =  rs.next();
		rs.close();
		stm.close();
		con.close();
		// false => there is no database => create new database, functions, views
		// rs.next is true => database is already exist
		return hasDB;
	}
	
	/**
	 * create Database then restore it from backup/default.sql if database does not exist
	 * @param fileName
	 * @return
	 * @throws SQLException
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	public static boolean createDatabase(String fileName) throws SQLException, IOException, ClassNotFoundException{
		try {
			if(!checkDatabase()){
				// DO NOT USE getConnection() in this function
				// there will be error when there is no database
				Connection con = DriverManager.getConnection(URL + PORT_NUMBER + "/",
					USER_NAME, PASSWORD);
				String sqlScript = "CREATE DATABASE "
					+ DB_NAME
					+ "   WITH OWNER "
					+ USER_NAME
					+ "    TEMPLATE template0   "
					+ "ENCODING 'SQL_ASCII'   TABLESPACE  pg_default   LC_COLLATE  'C'   "
					+ "LC_CTYPE  'C'   CONNECTION LIMIT  -1;";
				PreparedStatement stm = con.prepareStatement(sqlScript);
				stm.executeUpdate();
				stm.close();
				con.close();
				//executeSqlStatementFromFile("dbarticlebtb.sql");
				logger.writeLogCreateNewDatabase(DB_NAME);
				return restoreDatabase(fileName);			 
			}
		} catch (Exception e) {
			logger.writeLogException(e,"createDatabase", "DatabaseConnection");
			return false;
		}
		return false;
	}
	/*************************************************************//*
	public static void executeSqlStatementFromFile(String fileName)
			throws ClassNotFoundException, SQLException, IOException {
		// Read Sql Statement from sql file
		BufferedReader br = new BufferedReader(new FileReader(fileName));
		StringBuilder sqlScript = new StringBuilder();
		String str1 = "";
		while ((str1 = br.readLine()) != null) {
			sqlScript.append(str1);
			sqlScript.append("\n");
		}
		br.close();

		// then execute it
		// if error occur it throws exception so there's no need to return
		// anything
		Connection con = getConnection();
		PreparedStatement stm = con.prepareStatement(sqlScript.toString());
		stm.execute();
		stm.close();
		con.close();
	}
	*//*************************************************************/
	public static String backUpDatabase(){
		try {
			String fileName =  new SimpleDateFormat("ddMMYYYYHHmmss").format(new Date());
			File pathToExecutable = new File("postgres/pg_dump.exe");
			File pathToBackUp = new File("backup/" + fileName + ".sql");
			ProcessBuilder builder = new ProcessBuilder (
					pathToExecutable.getAbsolutePath(),
				    "-f",  pathToBackUp.getAbsolutePath(),
				    "-U", USER_NAME,	  
				    DB_NAME
				);	
			// this is where you set the root folder for the executable to run with
			builder = builder.directory( new File("postgres").getAbsoluteFile() ); 
			builder.redirectErrorStream(true);
			Process proc = builder.start();
			logger.writeLogBackUpDatabase(fileName + ".sql");
			return fileName + ".sql";
		} catch (Exception e) {
			logger.writeLogException(e,"backUpDatabase", "DatabaseConnection");
			return "";
		}				
	}
	
	public static boolean restoreDatabase(String fileName) {
		File pathToRestore = new File("backup/" + fileName);
		if(pathToRestore.exists()){
			try {
				resetDatabase();				
				File pathToExecutable = new File("postgres/psql.exe");
				ProcessBuilder builder = new ProcessBuilder (
						pathToExecutable.getAbsolutePath(),
					    "-f",  pathToRestore.getAbsolutePath(),
					    "-U", USER_NAME,	  
					    DB_NAME
					);
				// this is where you set the root folder for the executable to run with
				builder = builder.directory( new File("postgres").getAbsoluteFile() ); 
				Process proc = builder.start();
				logger.writeLogRestoreDatabase(fileName);
				return true;
			} catch (Exception e) {
				logger.writeLogException(e,"restoreDatabase", "DatabaseConnection");
				return false;
			}						
		}
		return false;
	}
	
//	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
////		  System.out.println(backUpDatabase());
//		 System.out.println(createDatabase("default.sql"));		
//		 //System.out.println(restoreDatabaseDefinition("05072015205932.sql"));
//		//System.out.println(restoreDatabase("default.sql"));
//		//System.out.println(createDatabase("default.sql"));
//		//System.out.println(resetDatabase());
//	}	
	
	//###########################################setter&getter#######################################
	public static String getDRIVER_NAME() {
		return DRIVER_NAME;
	}

	public static void setDRIVER_NAME(String dRIVER_NAME) {
		DRIVER_NAME = dRIVER_NAME;
	}

	public static String getURL() {
		return URL;
	}
	
	public static void setURL(String uRL) {
		URL = uRL;
	}
	
	public static String getPORT_NUMBER() {
		return PORT_NUMBER;
	}
	
	public static void setPORT_NUMBER(String pORT_NUMBER) {
		PORT_NUMBER = pORT_NUMBER;
	}
	
	public static String getDB_NAME() {
		return DB_NAME;
	}
	
	public static void setDB_NAME(String dB_NAME) {
		DB_NAME = dB_NAME;
	}
	
	public static String getUSER_NAME() {
		return USER_NAME;
	}
	
	public static void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
	}
	
	public static String getPASSWORD() {
		return PASSWORD;
	}
	
	public static void setPASSWORD(String pASSWORD) {
		PASSWORD = pASSWORD;
	}
 
}