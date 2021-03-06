// @authors: Bert Heinzelman, Emily Suhadolnik, Jimmy Boyle //<>// //<>// //<>//
// @date: april 20, 2016
// @description: Stock market visualization
//               Final Homework
//

import static javax.swing.JOptionPane.*;

//holds the data for each stock 
ArrayList<CsvFile> files;


//the max and min closing price for 
//all the stocks in the overview
//screen
float MAX_OVERVIEW_VAL;
float MIN_OVERVIEW_VAL;

//The max and min closing price
//for the stocks in the selected
//view/
float MAX_SELECTED_VAL;
float MIN_SELECTED_VAL;

//The max and min values for the selected points in the top left graph
float MAX_DRAGGED_VAL;
float MIN_DRAGGED_VAL;
float minX, minY, maxX, maxY;
float last_mouseX_pos;

boolean dragging;

//if box drawn, leave it up
boolean boxDrawn = false;

//used for dragging to store the coorinates
float startX; 
float startY; 
float endX; 
float endY;

enum View {
  OVERVIEW, 
    SELECTED, 
    DETAIL_SELECTED
}

void setup() {
  surface.setResizable(true); 
  size(800, 600);
  dragging = false; 

  FileManager fm = new FileManager(sketchPath("") + "csv/");

  files = fm.getCsvFiles();

  if (files == null) {
    showMessageDialog(null, "invalid files");
    exit();
  }

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
}

void draw() {
  stroke(0);
  strokeWeight(1); 
  if (dragging) {
    minX = min(startX, mouseX); 
    minY = min(startY, mouseY);
    maxX = max(startX, mouseX);
    maxY = max(startY, mouseY); 

    if (minX >= 2 && maxX <= width/2 && minY >= 2 && maxY <= height/2) {
      rect(minX, minY, maxX, maxY);
    }
  }


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

  //Functions in charge of drawing what is in each of the four rectangles
  drawTickers();
  drawOverviewLines();
  drawSelectedLines();
  drawDetailedLines(); 

  stroke(#000000);
  //Checks to see if the user wants to focus in on certain points of the stocks
  if (boxDrawn) {
    noFill();
    if (dragging) {
      rect(startX, 2, mouseX-startX, height/2);
    } else {
      rect(startX, 2, last_mouseX_pos-startX, height/2);
    }
  }
}

/*
This function is in charge of drawing the stock symbols at the bottom of the screen. The
stock is initial gray but we attach what color it should be if it becomes selected. 
*/
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

/*
This function is in charge of detecting if the user is selecting a certain area of time
for the stocks. We need to see when the user stopped dragging their mouse so that we know
that value.
*/
void mouseReleased() {
  if (dragging) {
    last_mouseX_pos = mouseX;
  }

  dragging = false;
}

/*
In order to detect which area the user has selected we will look at the rectangle's
height and width. If the user clicks on a certain area containing a stock symbol that
stock symbol will then be shown with color all throughout the visualization instead of
being gray. If the user unselects the stock symbol, then the color will go away. 

Once a stock is selcted we have to keep track of it in order to scale it properly to itself
or to the other stocks that were selected as well. 
*/
void mousePressed() {
  final float yR = height/2.0 + 10 + height/3.0;
  final float hR = height/7.0;
  float wR = (float)(width - 5) / (float)files.size();

  if (mouseX >= 2 && mouseX <= width/2 && mouseY>=2 && mouseY<= height/2 && !boxDrawn) {
    dragging = true;
    startX = mouseX;
    startY = mouseY;
    boxDrawn = true;
  } else if (mouseX >= 2 && mouseX <= width/2 && mouseY>=2 && mouseY<= height/2 && boxDrawn) {
    boxDrawn = false;
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

/*
This function is in charge of determining what is the highest closing value for the
stock table that is passed into the function. 
*/
float getMaxCloseVal(Table tab) {
  Float max = null;
  for (TableRow row : tab.rows()) {
    float close = row.getFloat("Close");

    if (max == null) {
      max =  new Float(close);
    } else if (close > max.floatValue()) {
      max = new Float(close);
    }
  }
  return max.floatValue();
}

/*
This function is in charge of determining what closing value is the smallest value in the
table that was passed into the function. 
*/
float getMinCloseVal(Table tab) {
  Float max = null;
  for (TableRow row : tab.rows()) {
    float close = row.getFloat("Close");

    if (max == null) {
      max =  new Float(close);
    } else if (close < max.floatValue()) {
      max = new Float(close);
    }
  }
  return max.floatValue();
}

/*
This function is in charge of drawing the lines to scale of the rectangle they are in.
The function takes the specific table values that it is drawing, the starting x cord of 
the rectangle, the width of the rectangle, the height of the rectangle, and the maximum
closing value and the minimum closing value. 

This function can work with the overview rectangle as well as the selected stocks 
rectangle. 
*/
void drawLines(CsvFile file, 
  float xPos, 
  float boxWidth, 
  float boxHeight, 
  float MAX, 
  float MIN, 
  View v) {
  noFill();

  if (v == View.OVERVIEW && boxDrawn) {
    stroke(#BFBFBF);
  } else
    stroke(file.getColorOfTicker());

  //rect(2, 2, width/2 - 10, height/2); 
  float xWidth = boxWidth/(float)(file.csv.getRowCount());  

  boolean inSelectedZone = false;

  beginShape();
  for (TableRow r : file.csv.rows()) {
    float closeValue = r.getFloat("Close");

    if (boxDrawn && v == View.OVERVIEW) {
      float min = min(last_mouseX_pos, startX);
      float max = max(last_mouseX_pos, startX);

      if (boxWidth+xPos < max && boxWidth+xPos > min && !inSelectedZone) {
        endShape();
        stroke(file.getColorOfTicker());
        beginShape();
        inSelectedZone = true;
      } else if (inSelectedZone && boxWidth + xPos < min) {
        endShape();
        stroke(#BFBFBF);
        beginShape();
        inSelectedZone = false;
      }
    }
    vertex(boxWidth+xPos, boxHeight-(((closeValue-MIN)/(MAX-MIN))*boxHeight));
    boxWidth-=xWidth;
  }
  endShape();
}

/*
This function is in charge of iterating through the list of CSV files and determining
which files have been selected or not. If the files were selected, they will be passed
to the drawLines() function so that they can be drawn to the the selected rectangle.
*/
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
        MIN_SELECTED_VAL, 
        View.SELECTED);
    }
  }
}
/*
This function is in charge of calling drawLines() for all of the files in the list of
CSVs. We pass in the values for the top left rectanlge as well as the overview max and
min closing values. 
*/
void drawOverviewLines() {
  for (CsvFile f : files) 
    drawLines(f, 
      2, 
      width/2.0 - 10.0, 
      height/2.0, 
      MAX_OVERVIEW_VAL, 
      MIN_OVERVIEW_VAL, 
      View.OVERVIEW);
}

/*
This function is in charge of drawing the lines for the selected stocks and the selcted
timeline.
*/
void drawDetailedLines() {

  float boxHeight = height/3;
  float boxBottom = height/3 + height/2 + 5; 

  for (CsvFile f : files) {
    if (!f.selected)
      continue;
    else {
      setDragged();
      float MIN = MIN_DRAGGED_VAL;
      float MAX = MAX_DRAGGED_VAL;
      float newMaxX=min(maxX, width/2-2);
      float newMinX=max(0, minX);
      float minPct= (newMinX/(width/2-2));
      float maxPct= (newMaxX/(width/2-2));
      float rowMin=minPct*f.csv.getRowCount();
      float rowMax=maxPct*f.csv.getRowCount();

      float actualMin=f.csv.getRowCount()-rowMax;
      float actualMax=f.csv.getRowCount()-rowMin;

      float boxWidth = width-5.0;
      float xWidth = boxWidth/(float)(rowMax-rowMin); 

      //gets the upper and lower dates for the values in the long middle box and displayes the dates
      String lowerDate, higherDate;
      if (actualMax>=f.csv.getRowCount())
        lowerDate=f.csv.getRow(int(actualMax)-1).getString("Date");
      else
        lowerDate=f.csv.getRow(int(actualMax)).getString("Date");
      if (actualMin>=f.csv.getRowCount())
        higherDate=f.csv.getRow(1).getString("Date");
      else
        higherDate=f.csv.getRow(int(actualMin)).getString("Date");


      lowerDate=changeDate(lowerDate);
      higherDate=changeDate(higherDate);

      
      textSize(20);
      textAlign(LEFT);
      fill(0); 
      text(lowerDate, 3, height/2+height/3);
      textAlign(RIGHT);
      text(higherDate, width-3, height/2+height/3);

      noFill();
      stroke(f.getColorOfTicker()); 
      strokeWeight(1);
      int i=0;
      beginShape(); 
      for (TableRow r : f.csv.rows()) { 
        if (i>=actualMin&&i<=actualMax) {
          float closeValue = r.getFloat("Close"); 
          vertex(boxWidth+2, boxBottom-(((closeValue-MIN)/(MAX-MIN))*boxHeight));
          boxWidth-=xWidth;
        }
        i++;
      }
      endShape();
    }
  }
}
//sets the values for brushing so that the long pane scales to the selection
void setDragged() {
  Float max=null;
  Float min=null;
  float newMaxX=min(maxX, width/2-2);
  float newMinX=max(0, minX);
  float rowMin= (newMinX/(width/2-2));
  float rowMax= (newMaxX/(width/2-2));
  if (rowMax==0)
    rowMax=-1;
  for (CsvFile file : files) {
    if (!file.selected)
      continue;

    float localMax = getMaxDraggedCloseVal(file.csv, rowMin, rowMax);
    float localMin = getMinDraggedCloseVal(file.csv, rowMin, rowMax);

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
    MAX_DRAGGED_VAL = max.floatValue();

  if (min != null)
    MIN_DRAGGED_VAL = min.floatValue();
}

//This function gets the maximum close value for the selected/dragged portion
float getMaxDraggedCloseVal(Table tab, float minPct, float maxPct) {
  Float max = null;
  float rowMin=minPct*tab.getRowCount();
  float rowMax=maxPct*tab.getRowCount();

  float actualMin=tab.getRowCount()-rowMax;
  float actualMax=tab.getRowCount()-rowMin;

  if (actualMax-actualMin<15)
    actualMax=actualMax+1;
  int i=0;
  for (TableRow row : tab.rows()) {
    if ((i>=actualMin && i<=actualMax)||(maxPct==-1)) {
      float close = row.getFloat("Close");
      if (max == null) {
        max =  new Float(close);
      } else if (close > max.floatValue()) {
        max = new Float(close);
      }
    }
    i++;
  }
  return max.floatValue();
}

//This function gets the minimum close value for the selected/dragged portion
float getMinDraggedCloseVal(Table tab, float minPct, float maxPct) {
  Float max = null;
  float rowMin=minPct*tab.getRowCount();
  float rowMax=maxPct*tab.getRowCount();

  float actualMin=tab.getRowCount()-rowMax;
  float actualMax=tab.getRowCount()-rowMin;

  if (actualMax-actualMin<15)
    actualMax=actualMax+1;
  int i=0;
  for (TableRow row : tab.rows()) {
    if ((i>=actualMin &&i<=actualMax)||(maxPct==-1)) {
      float close = row.getFloat("Close");

      if (max == null) {
        max =  new Float(close);
      } else if (close < max.floatValue()) {
        max = new Float(close);
      }
    }
    i++;
  }
  return max.floatValue();
}

//This function gets the month and year from the dragged portion to be displayed in the
//middle triangle
String changeDate(String Date) {
  String year= Date.substring(0, 4);
  String month= Date.substring(5, 7);

  if (month.equals("01"))
    month="JAN";
  else if (month.equals("02"))
    month="FEB";
  else if (month.equals("03"))
    month="MAR";
  else if (month.equals("04"))
    month="APR";
  else if (month.equals("05"))
    month="MAY";
  else if (month.equals("06"))
    month="JUN";
  else if (month.equals("07"))
    month="JUL";
  else if (month.equals("08"))
    month="AUG";
  else if (month.equals("09"))
    month="SEPT";
  else if (month.equals("10"))
    month="OCT";
  else if (month.equals("11"))
    month="NOV";
  else if (month.equals("12"))
    month="DEC";

  return (month+" "+year);
}