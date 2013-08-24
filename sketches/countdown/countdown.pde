
long start = 0;
float time = 10;

public void setup() {
 
 size(800, 450, P2D); 
  
}


public void draw() {
   if (0 == start) {
     start = millis();
   }
   background(64);
   long deltaTime = (millis() - start);
   time = 10 - (float) deltaTime / 1000 ;
   if (time < 0) {
     start = millis();
   } else {
     textAlign(CENTER); 
     text(time, width / 2, height / 2);
   }
}
