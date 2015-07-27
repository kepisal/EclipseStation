package Controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.ObjectDAO;
import Model.ObjectDTO;

import com.google.gson.Gson;

public class ViewObject implements Action {
	@Override
	public ActionForward execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ObjectDTO dto;
		String id= request.getParameter("stu_id");
		dto = new ObjectDAO().viewObject(id);
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		String gsondto= new Gson().toJson(dto);
		
		response.getWriter().write(gsondto);
		System.out.println(gsondto);
		return null;
	}
}
