// @authors: Bert Heinzelman, Emily Suhadolnik, Jimmy Boyle
// @date: april 20, 2016
// @description: Stock market visualization
//               Final Homework
//

import static javax.swing.JOptionPane.*;

ArrayList<CsvFile> files;
int  csvColor[] = {#FC0808, #FC9308, #FCF508, #30B716, #0832FC, #49F0CF, 
                    #9949F0, #F049DF, #F049DF, #155E9D}; 

void setup() {
  surface.setResizable(true); 
  size(800, 600);
  
  FileManager fm = new FileManager(sketchPath("") + "csv//");
  
  files = fm.getCsvFiles();
  
  if (files == null) {
    showMessageDialog(null, "invalid files");
    exit(); 
  }
  
  
  colorMode(HSB); 
}

void draw() {
 //Top Left Rectangle
 fill(#ffffff);
 rect(2, 2, width/2, height/2);
  
 //Top Right Rectangle
 rect(width/2 + 5, 2, width/2 - 10, height/2); 
  
 //Middle - Long Rectangle 
 rect(2, height/2 + 5, width - 5, height/3);
  
 //Bottom - Button Rectangle
 rect(2, height/2 + 10 + height/3, width - 5, height/7); 
 
 drawTickers();
}

void drawTickers() {
  textSize(20);
  textAlign(CENTER);
  stroke(#000000); 
  float x0 = 2;
  final int yR = height/2 + 10 + height/3;
  final int hR = height/7;
  final float wR = (float)(width - 5) / (float)files.size(); 
  for (CsvFile csv : files) {
    rect(x0, yR, wR, hR);
    fill(csv.color_Of_Ticker); 
    float textX = x0 + wR/2;
  
    text(csv.ticker, textX, yR + hR/2);
    x0 += wR;
    fill(#ffffff);
  }
}