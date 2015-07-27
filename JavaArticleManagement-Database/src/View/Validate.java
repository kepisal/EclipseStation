package View;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

import javax.activation.MailcapCommandMap;

public class Validate {
			public static String inputData() throws validateUserinput{
				String[] c = {"f","p","n","l","a","r","s","u","ss","h","v","g","#","e","b","he"};
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
						end = new Scanner(System.in).nextLine();
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
}
