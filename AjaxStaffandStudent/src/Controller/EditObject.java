package Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Controller.Action;
import Controller.ActionForward;
import Model.ObjectDAO;
import Model.ObjectDTO;

public class EditObject implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String id = request.getParameter("stu_id");
		ObjectDTO objDTO= new ObjectDTO();
		objDTO.setStatus(Integer.parseInt(request.getParameter("stu_status")));
		objDTO.setStuid(id);
		response.setContentType("text/plain");
		if(new ObjectDAO().update(objDTO.getStuid(),objDTO.getStatus())){
			System.out.println("Update FAIL");
			response.getWriter().write("fail");
		}else{
			System.err.println("Update Success");
			response.getWriter().write("success");
		}
		return null;
	}

}
