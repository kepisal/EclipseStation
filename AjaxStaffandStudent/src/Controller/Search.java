package Controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.ObjectDAO;
import Model.ObjectDTO;

import com.google.gson.Gson;

public class Search implements Action {
	@Override
	public ActionForward execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ArrayList<ObjectDTO> listdto= new ArrayList<ObjectDTO>();
		String name= request.getParameter("stu_name");
		String classes= request.getParameter("stu_class");
		String university= request.getParameter("stu_university");
		String status= request.getParameter("stu_status");
		listdto = new ObjectDAO().search(name,classes,university,status);
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		String gsondto= new Gson().toJson(listdto);
		
		response.getWriter().write(gsondto);
		System.out.println(listdto.size());
		return null;
	}
}
