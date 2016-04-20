void setup() {
  surface.setResizable(true); 
  size(800, 600);
}

void draw() {
  //Top Left Rectangle
  rect(2, 2, width/2, height/2);
  
  //Top Right Rectangle
  rect(width/2 + 5, 2, width/2 - 10, height/2); 
  
  //Middle - Long Rectangle 
  rect(2, height/2 + 5, width - 5, height/3);
  
  //Bottom - Button Rectangle
  rect(2, height/2 + 10 + height/3, width - 5, height/7); 
}