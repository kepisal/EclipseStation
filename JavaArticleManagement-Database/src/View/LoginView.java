package View;
public class LoginView {
	//UtilView.getStringKeyboard("Type \"C\" to connect to New Database \nType \"D\" to connect to Default Database: ");
	/**
	 * display loginuser  
	 * @return string of username or email to compare
	 */
	public String viewLoginUser(){
		return UtilView.getStringKeyboard("Username or Email: "); 
	}
	/**
	 * display loginpassword
	 * @return sting of password to compare
	 */
	public String viewLoginPassword(){
		return UtilView.getStringKeyboard("Password: ");
	}
	public String switchDatabaseConnection(){
		return UtilView.getStringKeyboard("Choose Database for connection ----> ");
	}
}
