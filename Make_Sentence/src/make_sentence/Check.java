package make_sentence;

import java.util.ArrayList;

public class Check {
	FileManager f2;

	private ArrayList<String> Part;

	Check() {

		f2 = new FileManager();

		Part = new ArrayList<String>();


		Part.add("N");
		Part.add("Vb");
		Part.add("Adj");
		Part.add("Pro");
		Part.add("Adv");
		Part.add("Prep");
		Part.add("Conj");
		Part.add("Int");
		Part.add("Part");

	}

	private int Check_Index(String a) {
		for (int i = 0; i < Part.size(); i++) {
			if (a.equals(Part.get(i))) {
				return i;
			}
		}

		return 0;

	}

	public int Get_Index(String sentences) {
		return Check_Index(sentences);
	}

	public String Get_Part(int index){

		return Part.get(index);
	}

}
