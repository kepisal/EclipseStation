package Model;

import java.beans.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.*;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ObjectDAO {
	static Connection cn;

	/*
	 * list all of elements in database return Arraylist objects
	 */
	public ArrayList<ObjectDTO> list() throws SQLException,
			ClassNotFoundException {

		String sql = "select * from hrd_students";
		java.sql.Statement stm = cn.createStatement();
		ResultSet rs = stm.executeQuery(sql);
		ArrayList<ObjectDTO> objectdto = new ArrayList<ObjectDTO>();
		try {
			while (rs.next()) {
				objectdto.add(new ObjectDTO(rs.getString("stu_id"), rs
						.getString("stu_name"), rs.getInt("stu_gender"), rs
						.getString("stu_university"),
						rs.getString("stu_class"), rs.getInt("stu_status")));
			}
		} catch (Exception e) {
			e.printStackTrace();
			
		}finally{
			rs.close();
			stm.close();
			cn.close();
		}
		return objectdto;
	}

	/*
	 * @param : id and status function update status 0 to 1 and 1 to 0 follow id
	 * return true/false for success or faild
	 */
	public boolean update(String id, int status) throws SQLException {
		try (PreparedStatement pstm = cn
				.prepareStatement("update hrd_students set stu_status=? where stu_id=?");) {

			pstm.setString(1, String.valueOf(status));
			pstm.setString(2, id);
			return pstm.execute();
			
		} catch (Exception e) {
			e.printStackTrace();
			cn.close();
		}
		return false;
	}

	/*
	 * distinct the class value return Arraylist objects (0,1)
	 */
	public ArrayList<ObjectDTO> classList() throws SQLException {
		String sql = "SELECT distinct stu_class FROM hrd_students";
		java.sql.Statement stm = cn.createStatement();
		ResultSet rs = stm.executeQuery(sql);
		ArrayList<ObjectDTO> objectdto = new ArrayList<ObjectDTO>();
		try {
			while (rs.next()) {
				objectdto.add(new ObjectDTO("", "", 0, "", rs
						.getString("stu_class"), 0));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			rs.close();
			stm.close();
			cn.close();
		}
		return objectdto;
	}

	/*
	 * distinct the university value return Arraylist objects (0,1)
	 */
	public ArrayList<ObjectDTO> universityList() throws SQLException {
		String sql = "select distinct stu_university from hrd_students";
		java.sql.Statement stm = cn.createStatement();
		ResultSet rs = stm.executeQuery(sql);
		ArrayList<ObjectDTO> objectdto = new ArrayList<ObjectDTO>();
		try {
			while (rs.next()) {
				objectdto.add(new ObjectDTO("", "", 0, rs
						.getString("stu_university"), "", 0));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		
		}finally{
			rs.close();
			stm.close();
			cn.close();
		}
		return objectdto;
	}

	/*
	 * Search all of content by name, class, university and status return as
	 * ArrayList objects
	 */
	public ArrayList<ObjectDTO> search(String name, String classes,
			String university, String status) throws SQLException {
		PreparedStatement ps = cn
				.prepareStatement("select * from hrd_students where stu_university LIKE ? and stu_class LIKE ? and stu_status LIKE ? and stu_name like ?");
		ps.setString(1, university + "%");
		ps.setString(2, classes + "%");
		ps.setString(3, status + "%");
		ps.setString(4, "%" + name + "%");
		ResultSet rs = ps.executeQuery();
		ArrayList<ObjectDTO> alist = new ArrayList<ObjectDTO>();
		while (rs.next()) {
			alist.add(new ObjectDTO(rs.getString("stu_id"), rs
					.getString("stu_name"), rs.getInt("stu_gender"), rs
					.getString("stu_university"), rs.getString("stu_class"), rs
					.getInt("stu_status")));
		}
		rs.close();
		ps.close();
		cn.close();
		return alist;
	}
	/*
	 * @param : id searching
	 * return only one ObjectDTO
	 * View Object Details
	 * */
	public ObjectDTO viewObject(String id) throws SQLException {
		String sql = "select * from hrd_students where stu_id=?";
		PreparedStatement pstm = cn.prepareStatement(sql);
		pstm.setString(1, id);
		ResultSet rs = pstm.executeQuery();
		ObjectDTO objectdto = new ObjectDTO();
		try {
			if (rs.next()) {
				objectdto = new ObjectDTO(rs.getString("stu_id"),
						rs.getString("stu_name"), rs.getInt("stu_gender"),
						rs.getString("stu_university"),
						rs.getString("stu_class"), rs.getInt("stu_status"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			rs.close();
			pstm.close();
			cn.close();
		}
		return objectdto;
	}

	/*
	 * @param : id searching
	 * return boolean
	 * true : success deleted
	 * false : fail deleted
	 * */
	public boolean DeleteObject(String id) throws SQLException {
		String sql = "delete from hrd_students where stu_id=?";
		PreparedStatement pstm = cn.prepareStatement(sql);
		pstm.setString(1, id);
		return pstm.execute();
	}
	/*
	 * @param : Object
	 * return boolean
	 * 2 purpose : Add new and Edited
	 * if Id existed : Update Record
	 * if Id not existed : Add new Record
	 * */
	public boolean add(ObjectDTO objectDTO) throws SQLException {
		boolean idexist = false;
		String sqlid = "select stu_id from hrd_students";
		java.sql.Statement stm = cn.createStatement();
		PreparedStatement pstm = null;
		ResultSet rs = stm.executeQuery(sqlid);
		while (rs.next()) {
			if (rs.getString(1).equals(objectDTO.getStuid())) {
				pstm = cn
						.prepareStatement("update hrd_students set stu_name=?, stu_gender=?, stu_university=?,stu_class=?,stu_status=? where stu_id=?");

				pstm.setString(1, objectDTO.getStuname());
				pstm.setInt(2, objectDTO.getGender());
				pstm.setString(3, objectDTO.getUnversity());
				pstm.setString(4, objectDTO.getClasses());
				pstm.setInt(5, objectDTO.getStatus());
				pstm.setString(6, objectDTO.getStuid());
				idexist = true;
			}
		}
		if (idexist == false) {
			String sql = "insert into hrd_students values(?,?,?,?,?,?)";
			pstm = cn.prepareStatement(sql);
			pstm.setString(1, objectDTO.getStuid());
			pstm.setString(2, objectDTO.getStuname());
			pstm.setInt(3, objectDTO.getGender());
			pstm.setString(4, objectDTO.getUnversity());
			pstm.setString(5, objectDTO.getClasses());
			pstm.setInt(6, objectDTO.getStatus());
		}
		return pstm.execute();

	}

	/********************** Here is Connection Database *********************************/
	static {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			cn = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/dbhrdstudents", "root", "");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**********************
	 * Here is Connection Database
	 * 
	 * @throws SQLException
	 *********************************/

}
