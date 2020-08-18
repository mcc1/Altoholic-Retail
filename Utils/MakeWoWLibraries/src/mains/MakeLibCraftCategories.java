package mains;
import libs.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;

public class MakeLibCraftCategories {
	private static final String WORK_DIRECTORY = "F:\\World of Warcraft\\_retail_\\Interface\\AddOns\\Altoholic\\libs\\LibCraftCategories-1.0\\Database";
	
	private static void process(String locale) {
		ExtractedCSV csv = DownloadCSV.extractCSV("tradeskillcategory", locale);

		// first line in the file should be:
		// LibStub("LibCraftCategories-1.0").enUS = {
		// then, each line should look like:
		//   [1]={["Name_lang"]="Disenchant",["HordeName_lang"]="",["ID"]=46,["ParentTradeSkillCategoryID"]=353,["SkillLineID"]=333,["OrderIndex"]=1020,["Flags"]=0},
		// no changes to the CSV needed

		FileOutputStream stream = null;
		try {
			File file = new File(WORK_DIRECTORY + "\\" + locale + ".lua");
			stream = new FileOutputStream(file);

			if (!file.exists()) {
				file.createNewFile();
			}

			stream.write("LibStub(\"LibCraftCategories-1.0\").".concat(locale).concat(" = {\n").getBytes());
			SaveLua.saveLua(stream, csv);
			stream.write(("}").getBytes());
			stream.flush();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			try {
				stream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static void main(String[] args) {
		String[] locales = {"deDE", "enUS", "esES", "esMX", "frFR", "itIT", "koKR", "ptBR", "ruRU", "zhCN", "zhTW"};
		
		// On Windows, JVM needs to be run with:
		// -Dfile.encoding=UTF-8
		if (!Charset.defaultCharset().toString().equals("UTF-8")) {
			System.out.println("Default charset UTF-8 not set");
			return;
		}
		
		for (String locale : locales) {
			process(locale);
		}
	}
}
