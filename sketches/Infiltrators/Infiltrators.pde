
int MAP_WIDTH = 32;
int MAP_HEIGHT = 32;
int MAP_SCALE = 10;

int TILE_EMPTY = 0;
int TILE_WALL = 1;
int TILE_ENTRANCE = 2;
int TILE_EXIT = 3;

int AGENTS_NORMAL = 3;
float MAX_TALK_TIME = 10;

long lastMillis = 0;

Bootup bootup;
Attract attract;
Game game;
Credits credits;

Screen screen;

public void setup() {
 
 size(800, 450, P2D); 
 
 bootup = new Bootup();
 bootup.setup();
 screen = bootup; 
 
}

public void draw() {
  
  // timing
  long nextMillis = millis();
  float deltaTime;
  if (0 == lastMillis) {
    deltaTime = 0;
  } else {
    deltaTime = (nextMillis - lastMillis) / 1000f;
  }
  lastMillis = nextMillis; 
  
  // update screen
  screen.update(deltaTime);
  screen.draw();
  screen = screen.next();  
  
  // clear input
  click = false;
  
}

boolean click = false;

public void mouseReleased() {
  println("mouse released");
  click = true; 
}


