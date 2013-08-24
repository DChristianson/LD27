
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
     text(ceil(time), width / 2, height * 3 / 4);
   }
   
   textAlign(CENTER); 
   text("Infiltrators", width / 2, height / 2);

}
