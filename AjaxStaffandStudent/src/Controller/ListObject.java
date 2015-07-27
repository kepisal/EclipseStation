package Controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import Controller.Action;
import Controller.ActionForward;
import Model.ObjectDAO;
import Model.ObjectDTO;

public class ListObject implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ObjectDAO dao = new ObjectDAO();
		ArrayList<ObjectDTO> objectlist = dao.list();
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		String obj= new Gson().toJson(objectlist);
		
		response.getWriter().write(obj);
	
		
		return null;
	}

}
