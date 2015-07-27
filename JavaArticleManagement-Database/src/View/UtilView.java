package View;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

/**
 * contains all helper/util function for view
 * @author lit
 *
 */
public class UtilView {	
	public static String inputData() throws validateUserinput{
		String[] c = {"f","p","n","l","a","r","s","u","ss","h","v","g","#","e","b","he","ab"};
		Set<String> name =new HashSet<String>();
		for(int i=0;i<c.length;i++){
			name.add(c[i]);
		}
		boolean cond = true;
		String end="";
		while(cond) {
			cond=false;
			try{
				System.out.print("----> Input Option : ");
				end = new Scanner(System.in).nextLine().trim();
				end=end.toLowerCase();
				if(!name.contains(end)){
					throw new validateUserinput("Error");
				}
			}catch(validateUserinput e){
				 System.err.println("Wrong option, Input again!!!");  
				 cond=true;
			}
		} 
		return end ;
	}
	/**
	 * get String from input keyboard
	 * @param message : message to show on console screen
	 * @return : string from keyboard
	 */
	public static String getStringKeyboard(String message) {
		@SuppressWarnings("resource")
		Scanner put = new Scanner(System.in);
		String str = "";
		while (str.equals("")) {
			System.out.print(message);
			str = put.nextLine();
		}
		return str;
	}// End of getStringKeyboard();
	
	/**
	 * input multiple line of String
	 * @return content as multiple line of String from Keyboard when user input 3 period  
	 */
	@SuppressWarnings("resource")
	public static String inputContent() {
		StringBuilder contents = new StringBuilder();
		try {
			Scanner put = new Scanner(System.in);
			while (put.hasNext()) {
				contents.append(put.next());
				if (contents.toString().endsWith("...")) {
					contents.setLength(contents.length() - 3);
					break;
				}
				contents.append(" ");
			}
		} catch (Exception e) {
			// logfile.writeLogException(e, "inputContent", "Management");
		}
		return contents.toString();
	}
	
	/**
	 * get number from input keyboard 
	 * if error/mismatch input again
	 * @param message : message to show on console screen
	 * @return : number from keyboard
	 */
	public static int getNumberKeyboard(String message) {
		@SuppressWarnings({ "resource" })
		Scanner put = new Scanner(System.in);
		while (true) {
			System.out.print(message);
			try {
				return put.nextInt();
			} catch (java.util.InputMismatchException e) {
				System.out
						.println("Input Mismatch. Please Input Number Again.");
				// logfile.writeLogException(e, "getNumberKeyboard",
				// "Management");
				put.nextLine();
			}
		}
	}
	
	/**
	 * currentDate return current date and time
	 * @return string of current date and time
	 */
	public static String currentDate() {
		return new SimpleDateFormat("dd/MM/YYYY HH:mm:ss").format(new Date());
	}
}
