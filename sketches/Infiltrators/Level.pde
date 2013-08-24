class Level {
 
  int[] playfield;
  
  
  public void setup() {
    playfield = new int[MAP_WIDTH * MAP_HEIGHT];
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
  
  public void draw() {
    
    noStroke();
    fill(128, 128, 128);
    rect(0, 0, MAP_WIDTH * 2, MAP_HEIGHT * 2);


    stroke(0, 255, 0);
    fill(128, 128, 128);

    for (int i = 0; i < MAP_WIDTH; i++) {
      for (int j = 0; j < MAP_WIDTH; j++) {
        int tile = getTile(playfield, i, j);
        if (TILE_WALL == tile) {
          float x = MAP_SCALE * i;
          float y = MAP_SCALE * j;
          rect(x, y, MAP_SCALE, MAP_SCALE);
        }
      }
    }
    
  }
  
}
