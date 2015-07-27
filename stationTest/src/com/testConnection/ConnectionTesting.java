package com.testConnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionTesting {
	public static void main(String[] args) {
		try {
			Class.forName("org.postgresql.Driver");
			Connection con=DriverManager.getConnection("jdbc:postgresql://localhost:5432/dbtest","postgres","0231");
			System.out.println(con.getMetaData().getDatabaseProductName());
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
		}
	}
}
