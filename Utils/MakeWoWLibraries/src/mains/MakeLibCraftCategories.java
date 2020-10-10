package mains;
import libs.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.regex.Pattern;

public class MakeLibCraftCategories {
	private static final String WORK_DIRECTORY = "D:\\Program Files\\World of Warcraft Beta\\_beta_\\Interface\\AddOns\\Altoholic\\libs\\LibCraftCategories-1.0\\Database";

	private static void saveLuaLine(FileOutputStream stream, ExtractedCSV csv, int i) {
		// output like:
		// [1]={["Name_lang"]="Disenchant",["HordeName_lang"]="",["ID"]=46,["ParentTradeSkillCategoryID"]=353,["SkillLineID"]=333,["OrderIndex"]=1020,["Flags"]=0},
		try {
			stream.write(("  [" + i + "]={").getBytes(Charset.forName("UTF-8")));
			int j = 0;
			boolean first = true;
			for (String header : csv.headers) {
				if (first) {
					first = false;
				} else {
					stream.write(",".getBytes(Charset.forName("UTF-8")));
				}
				stream.write(("[\"" + header + "\"]=").getBytes(Charset.forName("UTF-8")));

				Pattern pattern = Pattern.compile("\\d+");
				if (pattern.matcher(csv.values[i][j]).matches()) {
					stream.write(("" + csv.values[i][j]).getBytes(Charset.forName("UTF-8")));
				} else {
					stream.write(("\"" + csv.values[i][j] + "\"").getBytes(Charset.forName("UTF-8")));
				}
				j++;
			}
			stream.write(("},\n").getBytes(Charset.forName("UTF-8")));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

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
			for (int lineNum = 1; lineNum < csv.values.length; lineNum++) {
				saveLuaLine(stream, csv, lineNum);
			}
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
