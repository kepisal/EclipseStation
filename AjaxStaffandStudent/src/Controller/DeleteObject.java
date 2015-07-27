package Controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.ObjectDAO;
import Model.ObjectDTO;

import com.google.gson.Gson;

public class DeleteObject implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String id = request.getParameter("stu_id");
		ObjectDTO objDTO= new ObjectDTO();
		objDTO.setStuid(id);
		response.setContentType("text/plain");
		if(new ObjectDAO().DeleteObject(objDTO.getStuid())){
			System.out.println("Update FAIL");
			response.getWriter().write("fail");
		}else{
			System.err.println("Update Success");
			response.getWriter().write("success");
		}
		return null;
	}

}
