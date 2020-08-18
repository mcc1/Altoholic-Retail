package libs;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.regex.Pattern;

public class SaveLua {
	public static void saveLua(FileOutputStream stream, ExtractedCSV csv) {
		// output like:
		// [1]={["Name_lang"]="Disenchant",["HordeName_lang"]="",["ID"]=46,["ParentTradeSkillCategoryID"]=353,["SkillLineID"]=333,["OrderIndex"]=1020,["Flags"]=0},
		try {
			for (int i = 1; i < csv.values.length; i++) {
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
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
