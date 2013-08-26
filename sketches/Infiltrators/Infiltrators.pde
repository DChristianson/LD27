
import java.util.*;

int MAP_WIDTH = 64;
int MAP_HEIGHT = 32;

int TILE_EMPTY = 0;
int TILE_WALL = 1;
int TILE_ENTRANCE = 2;
int TILE_EXIT = 3;

float MAX_TALK_TIME = 10;
float MESSAGE_TIME = 2;
float WAIT_TIME = 10;
int MAX_WEIGHT = 15;

long lastMillis = 0;

Bootup bootup;
Attract attract;
Game game;
Credits credits;
Level level;
Radio radio;
Agent agent;
Guard guard;


Screen screen;

public void setup() {
 
 size(800, 400, P2D); 
 
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
  dragClick = false;
  
}

PVector dragVector = new PVector();
long dragMillis = 0;;
boolean dragging = false;
boolean dragClick = false;
boolean click = false;

public void mousePressed() {
  dragMillis = millis();
  dragVector.x = mouseX;
  dragVector.y = mouseY;
  dragging = false;
}

public void mouseReleased() {
  if (dragging) {
    dragClick = true;
  }
  dragging = false;
  click = true; 
}

public void mouseDragged() {
  if ((millis() - dragMillis) > 1000) {
    dragging = true;
  }
}

