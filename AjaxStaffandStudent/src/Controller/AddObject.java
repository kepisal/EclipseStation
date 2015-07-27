package Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.ObjectDAO;
import Model.ObjectDTO;

public class AddObject implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("stu_id");
		String name = request.getParameter("stu_name");
		String gender = request.getParameter("stu_gender");
		String university = request.getParameter("stu_university");
		String classes = request.getParameter("stu_class");
		String status = request.getParameter("stu_status");
		response.setContentType("text/plain");
		if (new ObjectDAO().add(new ObjectDTO(id,name,Integer.parseInt(gender),university,classes,Integer.parseInt(status)))) {
			System.out.println("ADD FAIL");
			response.getWriter().write("fail");
		} else {
			System.err.println("ADD Success");
			response.getWriter().write("success");
		}
		return null;
	}
}
