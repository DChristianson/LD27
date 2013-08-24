class Agent {
 
  String name;
  PVector location;

//  Goal next;
//  Goal last;
//  
  public void setup() {
    name = "Agent " + ((int) random(100));
    location = new PVector();   
  }
  
  public void update(float deltaTimeInSeconds) {
//    if (null == next) {
////      add(new Ask("Where to?");
//      
//    }
    
  }
  
  public void draw() {
    pushMatrix();
    translate(location.x, location.y);
    stroke(255);
    fill(200);
    rect(0, 0, 10, 10);
    popMatrix(); 
  }
  
}
