package mains;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import libs.DownloadCSV;
import libs.ExtractedCSV;

public class MakeLibCraftLevels {
	private static final String WORK_DIRECTORY = "F:\\World of Warcraft\\_retail_\\Interface\\AddOns\\Altoholic\\libs\\LibCraftLevels-1.0\\Database";
	
	public static void main(String[] args) {
		ExtractedCSV csv = DownloadCSV.extractCSV("skilllineability", "enUS");

		FileOutputStream stream = null;
		try {
			File file = new File(WORK_DIRECTORY + "\\craftLevels.lua");
			stream = new FileOutputStream(file);

			if (!file.exists()) {
				file.createNewFile();
			}

			stream.write("-- This file is generated automatically, do not make manual updates.\n\nLibStub(\"LibCraftLevels-1.0\").dataSource = {\n".getBytes());
			
			for (int i = 1; i < csv.values.length; i++) {
				String[] values = csv.values[i];
				if (values[8].equals("0") && values[9].equals("0")) {
					
				} else {
					String spellID = values[3];
					String trivialSkillLineRankHigh = values[8];
					String trivialSkillLineRankLow = values[9];
					
					/*Grey = TrivialSkillLineRankHigh 
					Green = (TrivialSkillLineRankHigh + TrivialSkillLineRankLow) / 2
					Yellow = TrivialSkillLineRankLow 
					Orange = MinSkillLineRank*/
					int green = ((Integer.parseInt(trivialSkillLineRankLow) + Integer.parseInt(trivialSkillLineRankHigh)) / 2);
					String minSkillLineRank = values[4];
					
					stream.write("  [".getBytes());
					stream.write(spellID.getBytes());
					stream.write("] = {[\"grey\"] = ".getBytes());
					stream.write(trivialSkillLineRankHigh.getBytes());
					stream.write(", [\"green\"] = ".getBytes());
					stream.write((green + ", [\"yellow\"] = ").getBytes());
					stream.write(trivialSkillLineRankLow.getBytes());
					stream.write(", [\"orange\"] = ".getBytes());
					stream.write(minSkillLineRank.getBytes());
					stream.write("},\n".getBytes());
				}
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

}
