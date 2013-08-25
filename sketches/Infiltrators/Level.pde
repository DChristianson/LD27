class Level {
 
  float top;
  float left;
  float bottom;
  float right;
  float w;
  float h;
  float leftMargin = 15;
  float topMargin = 15;
  float rightMargin = 15;
  float bottomMargin = 15;
  float scale = 50;
  float cursorX;
  float cursorY;
  boolean zoom = false;
  
  int[] playfield;
  float[] activityLevels;
  
  PShader wallsF;
  
  public void setup() {
    
    playfield = new int[MAP_WIDTH * MAP_HEIGHT];
    wallsF = loadShader("edges.glsl");
    
    resize(MAP_WIDTH, MAP_HEIGHT);
    
  }
  
  public void resize(float x, float y) {
    
    scale = lerp(scale, zoom ? 50 : ((height - (topMargin + bottomMargin)) / MAP_HEIGHT), 0.1);

    w = MAP_WIDTH * scale;
    h = MAP_HEIGHT * scale;    
                
    left = constrain((width / 2) - x * scale, width - rightMargin - w, leftMargin);
    top = constrain((height / 2) - y * scale, height - bottomMargin - h, topMargin);
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
    location.x = i + 0.5;
    location.y = j + 0.5;
    return true;
  }
  
  public boolean lineOfSight(float fromX, float fromY, float toX, float toY) {
    int fromI = (int) (fromX);
    int fromJ = (int) (fromY);
    int toI = (int) (toX);
    int toJ = (int) (toY);
    return playfieldLineOfSight(playfield, fromI, fromJ, toI, toJ); 
  }
  
  public void collide(PVector location, PVector velocity, float radius, float deltaTimeInSeconds) {
    location.x += velocity.x * deltaTimeInSeconds;
    location.y += velocity.y * deltaTimeInSeconds;
    if (TILE_WALL == getTile(playfield, (int) (location.x - radius), (int) location.y)) {
      location.x = ceil(location.y - 1) + radius;
       
    } else if (TILE_WALL == getTile(playfield, (int) (location.x + radius), (int) location.y)) {
      location.x = floor(location.x + 1) - radius;

    } else if (TILE_WALL == getTile(playfield, (int) location.x, (int) (location.y - radius))) {
      location.y = ceil(location.y + 1) + radius;
       
    } else if (TILE_WALL == getTile(playfield, (int) location.x, (int) (location.y + radius))) {
      location.y = floor(location.y + 1) - radius;
      
    }
  }
  
  public void update(float deltaTimeInSeconds) {
    
    if (radio.isModal()) {
      
      // zoom by radio focus
      zoom = radio.next.zoom;

    } else {
      
      // zoom click
      if (mouseY < topMargin) {
        if (click) {
          zoom = !zoom;
        }
      }
      
    } 
    
    resize(agent.location.x, agent.location.y);

    cursorX = (mouseX - left) / scale;
    cursorY = (mouseY - top) / scale;

  }
  
  public void draw() {

    pushMatrix();     
    
    translate(left, top);    
    scale(scale);
    // draw corridors
    
    noStroke();
    fill(64, 255, 64);

    for (int i = 0; i < MAP_WIDTH; i++) {
      for (int j = 0; j < MAP_HEIGHT; j++) {
        int tile = getTile(playfield, i, j);
        if (TILE_WALL != tile) {
          float x = i;
          float y = j;
          rect(x, y, 1, 1);
        }
      }
    }
    
    // execute walls filter
    filter(wallsF);

    // draw floors
    noStroke();
    fill(64, 64, 128, 192);
    
    for (int i = 0; i < MAP_WIDTH; i++) {
      for (int j = 0; j < MAP_HEIGHT; j++) {
        int tile = getTile(playfield, i, j);
        if (TILE_WALL != tile) {
          float x = i;
          float y = j;
          rect(x, y, 1, 1);
        }
      }
    }
    
    // draw agent on this map
    agent.draw();

    // check mouse
    if (!radio.isModal()) {
      
      if (cursorX >= 0  && cursorX < MAP_WIDTH && cursorY >= 0 && cursorY < MAP_HEIGHT) {
      
        float targetX = floor(cursorX) + 0.5;
        float targetY = floor(cursorY) + 0.5;
        float sourceX = (null != agent.lastGoal) ? agent.lastGoal.location.x : agent.location.x;
        float sourceY = (null != agent.lastGoal) ? agent.lastGoal.location.y : agent.location.y;
        
        
        if (lineOfSight(targetX, targetY, sourceX, sourceY)) {
          pushMatrix();
          strokeWeight(0.1);
          stroke(0, 255, 0); 
          fill(64, 64, 64, 192); 
          translate(targetX, targetY);
          ellipseMode(CENTER);
          ellipse(0, 0, 1, 1);
          popMatrix();
          
          if (click) {
            zoom = true;
            MoveTo waypoint = new MoveTo();
            waypoint.location.set(targetX, targetY);
            agent.add(waypoint); 
          }
          
        }
        
      }
      
    }
    
    popMatrix();
    
    if (!radio.isModal() && zoom) {
      noStroke();
      fill(255);
      rect(width / 2 - 50, 0, 100, topMargin);
      stroke(0);
      fill(0);
      textAlign(CENTER);
      text("ZOOM OUT", width / 2, 12);
    }
  }
  
}
