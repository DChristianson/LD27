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
  int levelColor = color(64, 64, 128, 192);
  Path path;
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
                
    left = lerp(constrain((width / 2) - x * scale, width - rightMargin - w, leftMargin), left, 0.1);
    top = lerp(constrain((height / 2) - y * scale, height - bottomMargin - h, topMargin), top, 0.1);
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
  
  public void random(int tile, PVector location) {
    int idx = findRandomTile(playfield, tile);
    int j = floor(idx / MAP_WIDTH);
    int i = idx - (j * MAP_WIDTH);
    location.x = i + 0.5;
    location.y = j + 0.5;
  }
  
  public void collide(PVector location, PVector velocity, float radius, float deltaTimeInSeconds) {
    float lx = location.x + velocity.x * deltaTimeInSeconds;
    float ly = location.y + velocity.y * deltaTimeInSeconds;
    if (TILE_WALL == getTile(playfield, (int) (lx - radius), (int) ly)) {
      lx = ceil(lx - 1) + radius;
       
    }
    if (TILE_WALL == getTile(playfield, (int) (lx + radius), (int) ly)) {
      lx = floor(lx + 1) - radius;

    }
    if (TILE_WALL == getTile(playfield, (int) lx, (int) (ly - radius))) {
      ly = ceil(ly - 1) + radius;
       
    }
    if (TILE_WALL == getTile(playfield, (int) lx, (int) (ly + radius))) {
      ly = floor(ly + 1) - radius;
      
    }
    location.x = lx;
    location.y = ly;
  }
  
  public void update(float deltaTimeInSeconds) {
    
    if (radio.isModal()) {
      
      // zoom by radio focus
      zoom = radio.next.zoom;

    }
          
    resize(agent.location.x, agent.location.y);

    cursorX = (mouseX - left) / scale;
    cursorY = (mouseY - top) / scale;
         
    if (!radio.isModal() && mouseX > (width / 2 - 50) && mouseX < (width / 2 + 50) && mouseY < topMargin && click) {
      
      // zoom click
      zoom = !zoom;
      
    } else if (cursorX >= 0  && cursorX < MAP_WIDTH && cursorY >= 0 && cursorY < MAP_HEIGHT) {
  
        float targetX = floor(cursorX) + 0.5;
        float targetY = floor(cursorY) + 0.5;
        float sourceX = (null != agent.lastGoal) ? agent.lastGoal.location.x : agent.location.x;
        float sourceY = (null != agent.lastGoal) ? agent.lastGoal.location.y : agent.location.y;

        if (!dragging) {
          
          path = searchPathTree(playfield, (int) sourceX, (int) sourceY, (int) targetX, (int) targetY, 20);
  
          if (null != path && click) {
            // go to path
            Follow follow = new Follow(path);
            agent.add(follow); 
            if (radio.isOverLimit()) {
              guard.hunt(agent); 
            }
          }
          
        } else {

          float hideX = (dragVector.x - left) / scale;
          float hideY = (dragVector.y - top) / scale;
          
          
          path = searchPathTree(playfield, (int) sourceX, (int) sourceY, (int) hideX, (int) hideY, 20);
  
          if (null != path && dragClick) {
            // go to hide spot and set up ambush
            Follow follow = new Follow(path);
            agent.add(follow);
            Ambush ambush = new Ambush();
            ambush.location.set(targetX, targetY);
            agent.add(ambush); 
            if (radio.isOverLimit()) {
              guard.hunt(agent); 
            }
          }
          
        }

    }  
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
    fill(levelColor);
    
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

    // draw path
    if (!radio.isModal()) {
      if (null != path) {
        Path node = path.child;
        float alpha = 255;
        while (null != node) {
          alpha *= 0.9;
          pushMatrix();
          strokeWeight(0.1);
          stroke(255, 255, 255, alpha); 
          fill(64, 64, 64, alpha); 
          translate(node.i + 0.5, node.j + 0.5);
          ellipseMode(CENTER);
          ellipse(0, 0, 0.5, 0.5);
          popMatrix();
          node = node.child;
        }
      }
    }
    
    // draw agent on this map
    if (agent.active) {
      agent.draw();
    }
    
    // draw guard on this map
    if (guard.active) {
      guard.draw();
    }
    
    popMatrix();
    
    // draw zoom bar
    if (!radio.isModal()) {
      noStroke();
      fill(255);
      rect(width / 2 - 50, 0, 100, topMargin);
      stroke(0);
      fill(0);
      textAlign(CENTER);
      text(zoom ? "ZOOM OUT" : "ZOOM IN", width / 2, 12);
    }
    
    // heading pointer
    if (dragging) {
      strokeWeight(1);
      stroke(255, 0, 0);
      line(dragVector.x, dragVector.y, mouseX, mouseY); 
    }
    
  }
  

  
}
