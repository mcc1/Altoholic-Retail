package libs;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DownloadCSV {
	private static final String VERSION_URL = "http://us.patch.battle.net:1119/wowt/versions";
	private static final String CSV_BASE_URL = "https://wow.tools/dbc/api/export/?name=";
	private static final String BUILD_URL = "&build=";
	private static final String LOCALE_URL = "&locale=";

	private static String makeURL(String tableName, String version, String locale) {
		return CSV_BASE_URL.concat(tableName).concat(BUILD_URL).concat(version).concat(LOCALE_URL).concat(locale);
	}

	private static String getCSV(String table, String locale) {
		String output = "";

		try {
			BufferedReader in;
			in = new BufferedReader(new InputStreamReader(new URL(VERSION_URL).openStream()));
			String inputLine;
			while ((inputLine = in.readLine()) != null) {
				output = output.concat(inputLine);
			}
			in.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new RuntimeException(e);
		}

		Pattern pattern = Pattern.compile("\\d+\\.\\d+\\.\\d+\\.\\d+");
		Matcher matcher = pattern.matcher(output);

		String version;
		if (matcher.find()) {
			version = matcher.group(0);
		} else {
			throw new RuntimeException("Pattern match failed");
		}

		output = "";

		try {
			BufferedReader in;
			URL url = new URL(makeURL(table, version, locale));
			URLConnection connection = url.openConnection();
			connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 1.2.30703)");
			in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			String inputLine;
			while ((inputLine = in.readLine()) != null) {
				output = output.concat(inputLine).concat("\n");
			}
			in.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new RuntimeException(e);
		}

		return output;
	}
	
	public static ExtractedCSV extractCSV(String table, String locale) {
		String CSV = getCSV(table, locale);
		
		String[] lines = CSV.split("\n");
		String[] headers = CSVUtils.parseLine(lines[0]).toArray(new String[0]);
		String[][] values = new String[lines.length][];
		for (int i = 1; i < lines.length; i++) {
			values[i] = CSVUtils.parseLine(lines[i]).toArray(new String[0]);
		}
		
		return new ExtractedCSV(headers, values);
	}
	
	public static void main(String[] args) {
		
	}


}
