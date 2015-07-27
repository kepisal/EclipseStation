package Controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.ObjectDAO;
import Model.ObjectDTO;

import com.google.gson.Gson;

public class universityList implements Action {
	public ActionForward execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ObjectDAO dao = new ObjectDAO();
		ArrayList<ObjectDTO> objectlist = dao.universityList();
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		String obj= new Gson().toJson(objectlist);
		
		response.getWriter().write(obj);
		return null;
	}
}
