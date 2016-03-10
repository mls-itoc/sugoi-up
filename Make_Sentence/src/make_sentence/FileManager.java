package make_sentence;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileManager {

	public static String read(String filePath){
		File file = new File(filePath);
		try {
			FileInputStream fis = new FileInputStream(filePath);
			byte[] b = new byte[(int)file.length()];
			fis.read(b);
			fis.close();
			return new String(b);
		} catch (FileNotFoundException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		} catch (IOException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}
		return null;
	}


	public static boolean write(String filePath, String text){
		File file = new File(filePath);
		FileOutputStream fos;
		try {
			fos = new FileOutputStream(file);
			fos.write(text.getBytes());
			fos.close();
			return true;
		} catch (FileNotFoundException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		} catch (IOException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}
		return false;
	}


}
