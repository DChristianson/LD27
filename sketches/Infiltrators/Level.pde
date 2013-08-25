class Level {
 
  float top;
  float left;
  float bottom;
  float right;
  float w;
  float h;
  int[] playfield;
  float[] activityLevels;
  
  public void setup() {
    playfield = new int[MAP_WIDTH * MAP_HEIGHT];
    
    left = (width - MAP_WIDTH * MAP_SCALE) / 2;
    top = (height - MAP_HEIGHT * MAP_SCALE) / 2;
    w = MAP_WIDTH * MAP_SCALE;
    h = MAP_HEIGHT * MAP_SCALE;
    bottom = top + h;
    right = left + w;
    
  }
  
  public void initMap(int number) {
    generateMap(playfield, number);
  }
  
  public boolean find(int tile, PVector location) {
    int idx = findTile(playfield, tile, 0);
    if (idx < 0) return false;
    int j = floor(idx / MAP_WIDTH);
    int i = idx - (j * MAP_WIDTH);
    location.x = i * MAP_SCALE + MAP_SCALE / 2;
    location.y = j * MAP_SCALE + MAP_SCALE / 2;
    return true;
  }
  
  public boolean lineOfSight(float fromX, float fromY, float toX, float toY) {
    int fromI = (int) (fromX / MAP_SCALE);
    int fromJ = (int) (fromY / MAP_SCALE);
    int toI = (int) (toX / MAP_SCALE);
    int toJ = (int) (toY / MAP_SCALE);
    return playfieldLineOfSight(playfield, fromI, fromJ, toI, toJ); 
  }
  
  public void update(float deltaTimeInSeconds) {
  }
  
  public void draw() {

    pushMatrix();
    
    translate(left, top);    
    noStroke();
    fill(64, 64, 64);
    rect(0, 0, w, h);

    stroke(0, 255, 0);
    fill(128, 128, 128);

    for (int i = 0; i < MAP_WIDTH; i++) {
      for (int j = 0; j < MAP_HEIGHT; j++) {
        int tile = getTile(playfield, i, j);
        if (TILE_WALL == tile) {
          float x = MAP_SCALE * i;
          float y = MAP_SCALE * j;
          rect(x, y, MAP_SCALE, MAP_SCALE);
        }
      }
    }
    
    // draw agent on this map
    agent.draw();
    
    if (mouseX >= left && mouseX < right && mouseY >= top && mouseY < bottom) {

      float cursorX = mouseX - left;
      float cursorY = mouseY - top;
      
      pushMatrix();
      if (lineOfSight(cursorX, cursorY, agent.location.x, agent.location.y)) {
        stroke(0, 255, 0); 
      } else {
        stroke(255, 0, 0); 
      }
      noFill(); 
      translate(cursorX - 2.5, cursorY - 2.5);
      ellipse(0, 0, 5, 5);
      popMatrix();
      
      if (!radio.isModal() && click) {
        MoveTo waypoint = new MoveTo();
        waypoint.location.set(cursorX, cursorY);
        agent.add(waypoint); 
      }
    
    }
    
    popMatrix();
    
  }
  
}
