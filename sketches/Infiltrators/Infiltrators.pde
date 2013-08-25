
import java.util.*;

int MAP_WIDTH = 64;
int MAP_HEIGHT = 32;
int MAP_SCALE = 10;

int TILE_EMPTY = 0;
int TILE_WALL = 1;
int TILE_ENTRANCE = 2;
int TILE_EXIT = 3;

float MAX_TALK_TIME = 10;
float MESSAGE_TIME = 2;
float WAIT_TIME = 10;
int MAX_GOALS = 7;

long lastMillis = 0;

Bootup bootup;
Attract attract;
Game game;
Credits credits;
Level level;
Radio radio;
Agent agent;


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


