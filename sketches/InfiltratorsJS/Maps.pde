
public void generateMap(int[] playfield, int number) {
  
  randomSeed(number);
  
  createMaze(playfield);
  //clearMap(playfield);
  
}

/**
 * check line of sight
 */
public boolean playfieldLineOfSight(int[] playfield, int fromI, int fromJ, int toI, int toJ, PVector direction) {
  
  float dx = toI - fromI;
  float dy = toJ - fromJ;
  float distance = sqrt((dx * dx) + (dy * dy));
  
  float ddx = dx / distance;
  float ddy = dy / distance;
  
  float x = fromI;
  float y = fromJ;
  
  for (int n = 0; n < distance; n++) {
    x = x + ddx;
    y = y + ddy;
    int idx = indexOf(floor(x), floor(y));
    if (TILE_WALL == playfield[idx]) {
      return false; 
    }
  }
  
  if (null != direction) {
    direction.x = dx;
    direction.y = dy;
  }
  
  return true;
  
}

/**
 * convert map x, y to index
 */
public int indexOf(int i, int j) {
  return i + j * MAP_WIDTH;
}

public void setTile(int[] playfield, int i, int j, int tile) {
  playfield[i + j * MAP_WIDTH] = tile;
}

public int getTile(int[] playfield, int i, int j) {
  if (i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT) return TILE_WALL;
  return playfield[i + j * MAP_WIDTH];
}

public int tileAdd(int idx, int di, int dj) {
  return idx + di + dj * MAP_WIDTH;
}

public int findTile(int[] playfield, int tile, int offset) {
  for (int i = offset; i < playfield.length; i++) {
    if (tile == playfield[i]) {
      return i;
    }
  }
  return -1;
}

public int findRandomTile(int[] playfield, int tile) {
  while (true) {
    int idx = floor(random(playfield.length));
    if (tile == playfield[idx]) {
      return idx; 
    }
  }
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
  
  int entrance = floor(random(MAP_WIDTH - 2)) + 1;
  setTile(playfield, entrance, MAP_HEIGHT - 1, TILE_ENTRANCE);

  int exit = floor(random(MAP_WIDTH - 2)) + 1;
  setTile(playfield, exit, 0, TILE_EXIT);

}

class Wall {
 
  int ci;
  int oi;
  
  public Wall(int from, int di, int dj) {
    this.ci = tileAdd(from, di, dj);
    this.oi = tileAdd(ci, di, dj); 
  }
  
}

public boolean inBounds(int idx) {
  int j = floor(idx / MAP_WIDTH);
  int i = floor(idx - j * MAP_WIDTH);
  return 0 < i && (MAP_WIDTH - 1) > i && 0 < j &&  (MAP_HEIGHT - 1) > j;
}

public boolean onMap(int idx) {
  int j = floor(idx / MAP_WIDTH);
  int i = idx - j * MAP_WIDTH;
  return 0 <= i && MAP_WIDTH > i && 0 <= j &&  MAP_HEIGHT > j;
}

public void addRandomWall(ArrayList<Wall> s, Wall w) {
  if (s.size() > 0) {
    int r = floor(random(s.size()));
    Wall d = s.get(r);
    s.set(r, w);
    s.add(d);
  } else {
    s.add(w);
  }
}

/**
 * Note this is making a crappy maze
 */ 
public void createMaze(int[] playfield) {
    ArrayList<Wall> wallList = new ArrayList<Wall>();
    boolean[] visited = new boolean[playfield.length];
    
    for (int i = 0; i < MAP_WIDTH; i++) {
      for (int j = 0; j < MAP_HEIGHT; j++) {
        if (0 == i || MAP_WIDTH - 1 == i || 0 == j || MAP_HEIGHT - 1 == j) {
          visited[indexOf(i, j)] = true;
        }
        setTile(playfield, i, j, TILE_WALL);
      }  
    } 
    
    int entrance = floor(random(MAP_WIDTH - 2)) + 1;
    setTile(playfield, entrance, MAP_HEIGHT - 1, TILE_ENTRANCE);
  
    // start at entra    
    int pick = indexOf(entrance, MAP_HEIGHT - 1);
    visited[pick] = true;
    wallList.add(new Wall(pick, 0, -1));

    while (wallList.size() > 0) {
      Wall wall = wallList.remove(wallList.size() - 1);
      
      if (!visited[wall.oi]) {
    
        int left = tileAdd(wall.ci, -1, 0);
        int right = tileAdd(wall.ci, 1, 0);
        int up = tileAdd(wall.ci, 0, -1);
        int down = tileAdd(wall.ci, 0, 1);
      
        playfield[wall.ci] = TILE_EMPTY;

        visited[left] = true;
        visited[tileAdd(wall.ci, -1, -1)] = true;
        visited[right] = true;
        visited[tileAdd(wall.ci, -1, 1)] = true;
        visited[up] = true;
        visited[tileAdd(wall.ci, 1, -1)] = true;
        visited[down] = true;
        visited[tileAdd(wall.ci, 1, 1)] = true;

        if (inBounds(left) && TILE_WALL == playfield[left]) {
          addRandomWall(wallList, new Wall(wall.ci, -1, 0));
        }
        if (inBounds(right) && TILE_WALL == playfield[right]) {
          addRandomWall(wallList, new Wall(wall.ci, 1, 0));
        }      
        if (inBounds(up) && TILE_WALL == playfield[up]) {
          addRandomWall(wallList, new Wall(wall.ci, 0, -1));
        }      
        if (inBounds(down) && TILE_WALL == playfield[down]) {
          addRandomWall(wallList, new Wall(wall.ci, 0, 1));
        }      
      }
    } 
    
    // find the empty tile nearest the top
    int exit = findTile(playfield, TILE_EMPTY, 0);
    while (exit > MAP_WIDTH) {
      exit = tileAdd(exit, 0, -1);
      setTile(playfield, exit, 0, TILE_EMPTY);       
    }
    setTile(playfield, exit, 0, TILE_EXIT);

}
