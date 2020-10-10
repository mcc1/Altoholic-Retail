package mains;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import libs.DownloadCSV;
import libs.ExtractedCSV;

public class MakeLibCraftLevels {
	private static final String WORK_DIRECTORY = "D:\\Program Files\\World of Warcraft Beta\\_beta_\\Interface\\AddOns\\Altoholic\\libs\\LibCraftLevels-1.0\\Database";
	
	private static Comparator<String[]> comparator = new Comparator<String[]>() {
		public int compare(String[] a, String[] b) {
		      return Integer.parseInt(a[3]) - Integer.parseInt(b[3]);           
		}
	};
	
	public static void main(String[] args) {
		ExtractedCSV csv = DownloadCSV.extractCSV("skilllineability", "enUS");

		FileOutputStream stream = null;
		try {
			File file = new File(WORK_DIRECTORY + "\\craftLevels.lua");
			stream = new FileOutputStream(file);

			if (!file.exists()) {
				file.createNewFile();
			}

			stream.write("LibStub(\"LibCraftLevels-1.0\").dataSource = {\n".getBytes());

			List<String[]> list = new ArrayList<String[]>();
			for (int i = 1; i < csv.values.length; i++) {
				String[] values = csv.values[i];
				if (values[8].equals("0") && values[9].equals("0")) {
					
				} else {
					list.add(values);
				}
			}
			
			list.sort(comparator);

			csv.values = list.toArray(new String[0][0]);

			for (int i = 1; i < csv.values.length; i++) {
				String[] values = csv.values[i];

				String spellID = values[3];
				String trivialSkillLineRankHigh = values[8];
				String trivialSkillLineRankLow = values[9];

				/*
				 * Grey = TrivialSkillLineRankHigh 
				 * Green = (TrivialSkillLineRankHigh + TrivialSkillLineRankLow) / 2
				 * Yellow = TrivialSkillLineRankLow 
				 * Orange = MinSkillLineRank
				 */
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
