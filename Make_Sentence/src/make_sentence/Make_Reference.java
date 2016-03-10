package make_sentence;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Random;




public class Make_Reference {

	FileManager f;
	Check check;
	Dice dice[];
	ArrayList<String> word;
	ArrayList<String> P_o_S;

	/*0:N 1:Vb 2:Adj 3:Pro 4:Adv 5:Prep 6:Conj 7:Int 8:Part*/
	double Reference[][];

	Make_Reference(String args) throws FileNotFoundException, ClassNotFoundException, SQLException{

		FileReader fr = new FileReader("recipe.sqlite");
		BufferedReader br = new BufferedReader(fr);

		Class.forName("org.sqlite.JDBC");
		Connection con = DriverManager.getConnection("jdbc:sqlite:recipe.sqlite");
		Statement stmt = con.createStatement();
		Statement stmt_words = con.createStatement();
		String sql = "SELECT * FROM words where menu_id = 1";
		ResultSet rs = stmt.executeQuery(sql);

		System.out.println("接続成功");

		int a = 1;


		 word = new ArrayList<String>();
		 P_o_S = new ArrayList<String>();


		while ( rs.next() ){

			word.add(rs.getString(3));
			P_o_S.add(rs.getString(4));

		}


		double count = 0.0;

		Reference = new double[9][9];
		check = new Check();

		for(int i = 0 ; i < P_o_S.size() - 1  ; i++){
			int row = check.Get_Index(P_o_S.get(i));
			int line = check.Get_Index(P_o_S.get(i + 1));

			Reference[row][line]++;
		}


		for(int row = 0 ; row < Reference.length ; row++){
			count = 0;
			for(int line = 0 ; line < Reference[row].length ; line++){
				count += Reference[row][line];
			}
			for(int line = 0 ; line < Reference[row].length ; line++){
				if(count != 0){
					Reference[row][line] = Reference[row][line] / count;
				}
			}

		}

		dice = new Dice[9];

		for(int i = 0 ; i < dice.length ; i++){
			dice[i] = new Dice();
		}

		for(int row = 0 ; row < Reference.length ; row++){
			for(int line = 0 ; line < Reference[row].length ; line++){
				dice[row].Make_Dice(Reference[row][line],line);
			}
		}

		int d[];

		Random random = new Random();
		 int rand = random.nextInt(15) + 5;

		d = new int[rand];

		d[0] = 0;

		for(int i = 1 ; i < d.length ; i++){
			d[i] = dice[d[i]].Dice_Roll(d[i-1]);
		}


		for(int i = 0 ; i < d.length ; i++){
			String Part = check.Get_Part(d[i]);

			String sql1 = "SELECT * FROM words where menu_id = " + a +" AND part_of_speech = " + "'" + Part + "'";
			 ResultSet rs2 = stmt_words.executeQuery(sql1);
			 int c = 0 ;
			 while( rs2.next()){
				 c++;
			 }

			 Random rnd = new Random();
			 int ran = rnd.nextInt(c);


			 sql1 = "SELECT * FROM words where menu_id = " + a +" AND part_of_speech = " + "'" + Part + "'";
			 rs2 = stmt_words.executeQuery(sql1);

			 ArrayList<String> Word;
			 Word = new ArrayList<String>();

			 while(rs2.next()){
				 Word.add(rs2.getString(3));
			 }

			 System.out.println(Word.get(ran));

		}

	}

	public double Get_Reference(int row , int line){
		return Reference[row][line];
	}




}
