// @authors: Bert Heinzelman, Emily Suhadolnik, Jimmy Boyle
// @date: april 20, 2016
// @description: Stock market visualization
//               Final Homework
//

import static javax.swing.JOptionPane.*;

ArrayList<CsvFile> files;

float MAX_OVERVIEW_VAL;
float MIN_OVERVIEW_VAL;

float MAX_SELECTED_VAL;
float MIN_SELECTED_VAL;

boolean dragging; 
float startX; 
float startY; 
  
void setup() {
  surface.setResizable(true); 
  size(800, 600);
  
  FileManager fm = new FileManager(sketchPath("") + "csv/");
  
  files = fm.getCsvFiles();
  
  if (files == null) {
    showMessageDialog(null, "invalid files");
    exit(); 
  }
  colorMode(HSB); 
  
  Float max = null;
  Float min = null;
  
  for (CsvFile file : files) {
    float localMax = getMaxCloseVal(file.csv);
    float localMin = getMinCloseVal(file.csv);
    
    if (max == null) {
      max = new Float(localMax);
    } else if (max.floatValue() < localMax) {
      max = new Float(localMax);
    }
    
    if (min == null) {
      min = new Float(localMin);
    } else if (min.floatValue() > localMin) {
      min = new Float(localMin);
    }
  }
  
  MAX_OVERVIEW_VAL = max.floatValue();
  MIN_OVERVIEW_VAL = min.floatValue();
  
  println(MAX_OVERVIEW_VAL);
  println(MIN_OVERVIEW_VAL);
  
  
  
  
}

void draw() {
 //Top Left Rectangle
 background(#BFBFBF);
 fill(#ffffff);
 rect(2, 2, width/2, height/2);
  
 //Top Right Rectangle
 rect(width/2 + 5, 2, width/2 - 10, height/2); 
  
 //Middle - Long Rectangle 
 rect(2, height/2 + 5, width - 5, height/3);
  
 //Bottom - Button Rectangle
 rect(2, height/2 + 10 + height/3, width - 5, height/7); 
 
 drawTickers();
 
 drawOverviewLines();
 drawSelectedLines();
 //drawDetailedLines(); 
 
 stroke(0);
 strokeWeight(1); 
 if(dragging){
 }
 stroke(#000000);
}

void drawTickers() {
  textSize(20);
  textAlign(CENTER);
  stroke(#000000); 
  float x0 = 2;
  final int yR = height/2 + 10 + height/3;
  final int hR = height/7;
  float wR = (float)(width - 5) / (float)files.size();
  
  for (CsvFile csv : files) {
    rect(x0, yR, wR, hR);
    
    fill(csv.getColorOfTicker()); 
    float textX = x0 + wR/2;
  
    text(csv.ticker, textX, yR + hR/2);
    x0 += wR;
    fill(#ffffff);
  }
}

void mouseReleased(){
 dragging = false;  
}

void mousePressed() {
  final float yR = height/2.0 + 10 + height/3.0;
  final float hR = height/7.0;
  float wR = (float)(width - 5) / (float)files.size();
  // rect(2, 2, width/2, height/2);
  final float ovYR =  2;
  final float ovHR = height/2.0;
  float ovWR = (float)(width/2)/(float)files.size(); 
  
  if(mouseY > ovYR && mouseY < ovYR + ovHR && mouseX > 2 && mouseX < wR){
    dragging = true;
    startX = mouseX;
    startY = mouseY; 
  }
  
  boolean selectHappened = false;
  
  if (mouseY > yR && mouseY < yR + hR) {
    int x = 2;
    for (int i = 0; i < files.size(); i++) {
      boolean touch = mouseX > x && mouseX < x + wR;
      
      if (touch) {
        selectHappened = true;
        files.get(i).selected = !files.get(i).selected;
      }
      x += wR;
    }
  }
  
  if (selectHappened) {
    Float max = null;
    Float min = null;
    for (CsvFile file : files) {
      if (!file.selected)
        continue;
      
      float localMax = getMaxCloseVal(file.csv);
      float localMin = getMinCloseVal(file.csv);
      
      if (max == null) {
        max = new Float(localMax);
      } else if (max.floatValue() < localMax) {
        max = new Float(localMax);
      }
      
      if (min == null) {
        min = new Float(localMin);
      } else if (min.floatValue() > localMin) {
        min = new Float(localMin);
      }
    }
    if (max != null)
      MAX_SELECTED_VAL = max.floatValue();
      
    if (min != null)
      MIN_SELECTED_VAL = min.floatValue();
  }
}

float getMaxCloseVal(Table tab) {
  Float max = null;
  for (TableRow row : tab.rows()) {
    float close = row.getFloat("Close");
    
    if (max == null) {
      max =  new Float(close);
    }
    else if (close > max.floatValue()) {
      max = new Float(close);
    }
      
  }
  return max.floatValue();
}

float getMinCloseVal(Table tab) {
  Float max = null;
  for (TableRow row : tab.rows()) {
    float close = row.getFloat("Close");
    
    if (max == null) {
      max =  new Float(close);
    }
    else if (close < max.floatValue()) {
      max = new Float(close);
    }
      
  }
  return max.floatValue();
}

void drawLines(CsvFile file, 
               float xPos, 
               float boxWidth, 
               float boxHeight, 
               float MAX, 
               float MIN){
  noFill();
  stroke(file.getColorOfTicker()); 
  strokeWeight(1); 
  //rect(2, 2, width/2 - 10, height/2); 
 float xWidth = boxWidth/(float)(file.csv.getRowCount());  
 
 beginShape();
 for(TableRow r : file.csv.rows()){
   float closeValue = r.getFloat("Close"); 
   vertex(xPos, (closeValue/(MAX+MIN))*boxHeight);
   xPos += xWidth; 
 }
 endShape();
}

void drawSelectedLines() {
  //rect(width/2 + 5, 2, width/2 - 10, height/2); 
  for (CsvFile file : files) {
    if (!file.selected) 
      continue;
     else {
       drawLines(file, 
                 width/2.0+5.0, 
                 width/2.0 - 10.0, 
                 height/2.0, 
                 MAX_SELECTED_VAL, 
                 MIN_SELECTED_VAL);
     }
  }
  
}
void drawOverviewLines() {
  for (CsvFile f : files) 
    drawLines(f, 
              2, 
              width/2.0 - 10.0, 
              height/2.0, 
              MAX_OVERVIEW_VAL,
              MIN_OVERVIEW_VAL);      
}

void drawDetailedLines(){
   for(CsvFile f: files){
     if(!f.selected)
       continue;
     else{
       drawLines(f, 2, width - 5.0, height/2.0 + 5.0 + height/3.0, 
                 MAX_SELECTED_VAL, MIN_SELECTED_VAL); 
     }
   }
}
     
  