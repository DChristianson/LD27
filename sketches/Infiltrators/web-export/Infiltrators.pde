
long lastMillis = 0;

Screen screen;

public void setup() {
 
 size(800, 450, P3D); 
 
 screen = new Bootup();
 screen.setup();
 
}

public void draw() {
  
  // timing
  long nextMillis = mills();
  float deltaTime;
  if (0 == lastMillis) {
    deltaTime = 0;
  } else {
    deltaTime = nextMillis - lastMillis;
  }
  lastMillis = nextMillis; 
  
  screen.update(deltaTime);
  screen.draw();
  screen = screen.next();  
  
}


class Bootup extends Screen {
  
  float percent = 0;
  
  public void update(float deltaTime) {
    percent += deltaTime * 10;  
  }
  
  public void draw() {
    textAlign(CENTER);
    text(percent, width / 2, height / 2);
  } 
  
}
class Screen {
  
  public Screen() {
    self = this;  
  }
  
  public void setup() {}
  
  public void update(float deltaTimeInSeconds) {}
  
  public void draw();
  
  public Screen next() {
    return self;
  }  
  
}

