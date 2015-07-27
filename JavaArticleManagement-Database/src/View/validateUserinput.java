package View;

import java.util.InputMismatchException;

@SuppressWarnings("serial")
public class validateUserinput extends InputMismatchException {
			private String message;
			public  validateUserinput(String s){
				super("Input wrong");
				this.message=s;
			}
			public String getMessage(){
				return this.message;
			}
}
