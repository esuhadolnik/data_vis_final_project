import java.io.File;


//
// Pair class to hold data for ticker 
// and table
//
class CsvFile {
  public String ticker;
  public Table csv;
  
  public CsvFile(String ticker, Table csv) {
    this.ticker = ticker;
    this.csv = csv;
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
  
  FileManager(String directory) {
    this.directory = directory;
  }
  
  public ArrayList<CsvFile> getCsvFiles() {
    try {
      ArrayList<CsvFile> files = new ArrayList<CsvFile>();
    
      File folder = new File(directory);
      
      File[] rawFiles = folder.listFiles();
      
      for (File f : rawFiles) {
          String path = f.getAbsolutePath();
          
          String ticker = path.substring(directory.length(), path.length());
          
          int end = ticker.indexOf(".csv");
          
          ticker = ticker.substring(0, end);
          
          files.add(new CsvFile(ticker, loadTable(path)));
      }
      
      return files;
      
    } catch (Exception e) {
      return null;
    }
    
  }
}