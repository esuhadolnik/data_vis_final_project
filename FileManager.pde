import java.io.File;

//
// Pair class to hold data for ticker 
// and table
//
class CsvFile {
  public String ticker;
  public Table csv;
  //Determines which color goes with whic CSV
  private int color_Of_Ticker; 
  
  public boolean selected;
  
  public CsvFile(String ticker, Table csv, int color_Of_Ticker) {
    this.ticker = ticker;
    this.csv = csv;
    this.color_Of_Ticker = color_Of_Ticker; 
    this.selected = false;
  }
  
  int getColorOfTicker() {
    if (selected) {
      return color_Of_Ticker;
    } else {
      return color(#BFBFBF);
    }
  }
  

}

//
// Class responsible for loading the tables 
// and tickers.
// We do it this way rather than hard coding 
// so we can easily change the files that we
// use.
class FileManager {
  private String directory;
  public int  csvColor[] = {#FC0808, #FC9308, #215F02,#0832FC, 
                                #30BFAA, #9949F0, #F049DF, 
                                #BF4D6F, #155E9D, #67F720}; 
  
  FileManager(String directory) {
    this.directory = directory;
  }
  
  public ArrayList<CsvFile> getCsvFiles() {
    String currentFile = "";
    
    try {
      ArrayList<CsvFile> files = new ArrayList<CsvFile>();
    
      File folder = new File(directory);
      
      File[] rawFiles = folder.listFiles();
      
      int i = 0; 
      for (File f : rawFiles) {
          String path = f.getAbsolutePath();
          
          currentFile = path;
          
          String ticker = path.substring(directory.length(), path.length());
          
          int end = ticker.indexOf(".csv");
          
          ticker = ticker.substring(0, end);
          
          int color_of_ticker = csvColor[i];
          i++; 
          
          files.add(new CsvFile(ticker, loadTable(path, "header"), color_of_ticker));
      }
      
      return files;
      
    } catch (Exception e) {
      println(currentFile);
      return null;
    }
    
  }
}