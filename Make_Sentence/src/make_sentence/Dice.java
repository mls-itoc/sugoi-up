package make_sentence;

import java.util.Random;

public class Dice {

int Nine_Dice[];

	Dice(){
		Nine_Dice = new int[9];
	}

	public void Make_Dice(double a,int i){
		Nine_Dice[i] = (int) (a * 100);
	}

	public int Dice_Roll(int d){
		
		while (true) {
			Random rnd = new Random();
			int ran = rnd.nextInt(100);

			if (ran < Nine_Dice[0]) {
				if(d != 0){
					return 0;
				}
			} else if (ran < Nine_Dice[0] + Nine_Dice[1]) {
				if(d != 1){
					return 1;
				}
			} else if (ran < Nine_Dice[0] + Nine_Dice[1] + Nine_Dice[2]) {
				if(d != 2){
					return 2;
				}
			} else if (ran < Nine_Dice[0] + Nine_Dice[1] + Nine_Dice[2] + Nine_Dice[3]) {
				if(d == 3){
					continue;
				}
				return 3;
			} else if (ran < Nine_Dice[0] + Nine_Dice[1] + Nine_Dice[2] + Nine_Dice[3] + Nine_Dice[4]) {
				if(d != 4){
					return 4;
				}
			} else if (ran < Nine_Dice[0] + Nine_Dice[1] + Nine_Dice[2] + Nine_Dice[3] + Nine_Dice[4] + Nine_Dice[5]) {
				if(d != 5){
					return 5;
				}
			} else if (ran < Nine_Dice[0] + Nine_Dice[1] + Nine_Dice[2] + Nine_Dice[3] + Nine_Dice[4] + Nine_Dice[5]
					+ Nine_Dice[6]) {
				if(d != 6){
					return 6;
				}
			} else if (ran < Nine_Dice[0] + Nine_Dice[1] + Nine_Dice[2] + Nine_Dice[3] + Nine_Dice[4] + Nine_Dice[5]
					+ Nine_Dice[6] + Nine_Dice[7]) {
				if(d != 7){
					return 7;
				}
			} else if (ran < Nine_Dice[0] + Nine_Dice[1] + Nine_Dice[2] + Nine_Dice[3] + Nine_Dice[4] + Nine_Dice[5]
					+ Nine_Dice[6] + Nine_Dice[7] + Nine_Dice[8]) {
				if(d != 8){
					return 8;
				}
			}

		}

	}
}


