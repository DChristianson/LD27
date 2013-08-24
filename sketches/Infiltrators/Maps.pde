
public void generateMap(int[] playfield, int number) {
  
  randomSeed(number);
  
  clearMap(playfield);
  
}

public void setTile(int[] playfield, int i, int j, int tile) {
  playfield[i + j * MAP_WIDTH] = tile;
}

public int getTile(int[] playfield, int i, int j) {
  return playfield[i + j * MAP_WIDTH];
}

public int findTile(int[] playfield, int tile, int offset) {
  for (int i = offset; i < playfield.length; i++) {
    if (tile == playfield[i]) {
      return i;
    }
  }
  return -1;
}

/**
 * Clear map with walls, entrance and exit.
 */
public void clearMap(int[] playfield) {

  for (int i = 0; i < MAP_WIDTH; i++) {
    for (int j = 0; j < MAP_HEIGHT; j++) {
      setTile(playfield, i, j, TILE_EMPTY);
    }  
  } 
  
  for (int i = 0; i < MAP_WIDTH; i++) {
    setTile(playfield, i, 0, TILE_WALL);
    setTile(playfield, i, MAP_HEIGHT - 1, TILE_WALL);
  }
  
  for (int j = 0; j < MAP_HEIGHT; j++) {
    setTile(playfield, 0, j, TILE_WALL);
    setTile(playfield, MAP_WIDTH - 1, j, TILE_WALL);
  }  
  
  int entrance = (int) random(MAP_WIDTH - 2) + 1;
  setTile(playfield, entrance, MAP_HEIGHT - 1, TILE_ENTRANCE);

  int exit = (int) random(MAP_WIDTH - 2) + 1;
  setTile(playfield, exit, 0, TILE_EXIT);

}
