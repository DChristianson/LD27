
public void generateMap(int[] playfield, int number) {
  
  randomSeed(number);
  
  createMaze(playfield);
  //clearMap(playfield);
  
}

/**
 * check line of sight
 */
public boolean playfieldLineOfSight(int[] playfield, int fromI, int fromJ, int toI, int toJ) {
  
  float dx = toI - fromI;
  float dy = toJ - fromJ;
  float distance = sqrt((dx * dx) + (dy * dy));
  
  float ddx = dx / distance;
  float ddy = dy / distance;
  
  float i = fromI;
  float j = fromJ;
  
  for (int n = 0; n < distance; n++) {
    i = i + ddx;
    j = j + ddy;
    int idx = indexOf((int) i, (int) j);
    if (TILE_WALL == playfield[idx]) {
      return false; 
    }
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

class Wall {
 
  int ci;
  int oi;
  
  public Wall(int from, int di, int dj) {
    this.ci = tileAdd(from, di, dj);
    this.oi = tileAdd(ci, di, dj); 
  }
  
}

public boolean inBounds(int idx) {
  int j = (int) idx / MAP_WIDTH;
  int i = idx - j * MAP_WIDTH;
  return 0 < i && MAP_WIDTH - 1 > i && 0 < j &&  MAP_HEIGHT - 1 > j;
}

public void addRandomWall(Stack<Wall> s, Wall w) {
  if (!s.isEmpty()) {
    int r = (int) random(s.size());
    Wall d = s.get(r);
    s.set(r, w);
    s.push(d);
  } else {
    s.push(w);
  }
}

/**
 * Note this is making a crappy maze
 */ 
public void createMaze(int[] playfield) {
    Stack<Wall> wallList = new Stack<Wall>();
    boolean[] visited = new boolean[playfield.length];

    for (int i = 0; i < MAP_WIDTH; i++) {
      for (int j = 0; j < MAP_HEIGHT; j++) {
        if (0 == i || MAP_WIDTH - 1 == i || 0 == j || MAP_HEIGHT - 1 == j) {
          visited[indexOf(i, j)] = true;
        }
        setTile(playfield, i, j, TILE_WALL);
      }  
    } 
    
    int entrance = (int) random(MAP_WIDTH - 2) + 1;
    setTile(playfield, entrance, MAP_HEIGHT - 1, TILE_ENTRANCE);
  
    // start at entra    
    int pick = indexOf(entrance, MAP_HEIGHT - 1);
    visited[pick] = true;
    wallList.add(new Wall(pick, 0, -1));

    while (!wallList.isEmpty()) {
      Wall wall = wallList.pop();
      
      println("checking wall: " + wall.ci + "->" + wall.oi);
      
      if (!visited[wall.oi]) {
    
        int left = tileAdd(wall.ci, -1, 0);
        int right = tileAdd(wall.ci, 1, 0);
        int up = tileAdd(wall.ci, 0, -1);
        int down = tileAdd(wall.ci, 0, 1);
      
        println(" " + playfield[up]);
        println(playfield[left] + " " + playfield[right]);
        println(" " + playfield[down]);

        println(" " + visited[up]);
        println(visited[left] + " " + visited[right]);
        println(" " + visited[down]);
   
        println("digging");
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
