package libs;

public class ExtractedCSV {
	public ExtractedCSV(String[] headers, String[][] values) {
		this.headers = headers; 
		this.values = values;
	}
	public String[] headers;
	public String[][] values;
}
