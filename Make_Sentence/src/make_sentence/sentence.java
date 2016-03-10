package make_sentence;

import java.io.FileNotFoundException;
import java.sql.SQLException;

public class sentence {

public static void main(String[] args) throws ClassNotFoundException, SQLException {

		Make_Reference MR = null;
		try {
			MR = new Make_Reference(args[0]);
		} catch (FileNotFoundException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}

	}

}
