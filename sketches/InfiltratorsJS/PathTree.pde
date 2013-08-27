/**
 * Binary Heap Javascript code courtesy CC license 3.0
 * http://eloquentjavascript.net/appendix2.html
 */
 
/**
 * Good old fashioned A*
 */
public Path searchPathTree(int[] playfield, int fromI, int fromJ, int toI, int toJ, int limit) {
  boolean[] visited = new boolean[playfield.length];
  ArrayList<Path> paths = new ArrayList<Path>();
  
  Path root = new Path(null, fromI, fromJ, toI, toJ);
  while (root.distance > 0 && limit > 0) {
    --limit;
    
    int idx = indexOf(root.i, root.j);
    visited[idx] = true;
    
    int left = tileAdd(idx, -1, 0);
    if (onMap(left) && !visited[left] && TILE_WALL != playfield[left]) {
      insertPath(paths, new Path(root, root.i - 1, root.j, toI, toJ));  
    }
    int right = tileAdd(idx, 1, 0);
    if (onMap(right) && !visited[right] && TILE_WALL != playfield[right]) {
      insertPath(paths, new Path(root, root.i + 1, root.j, toI, toJ));  
    }
    int up = tileAdd(idx, 0, -1);
    if (onMap(up) && !visited[up] && TILE_WALL != playfield[up]) {
      insertPath(paths, new Path(root, root.i, root.j - 1, toI, toJ));  
    }
    int down = tileAdd(idx, 0, 1);
    if (onMap(down) && !visited[down] && TILE_WALL != playfield[down]) {
      insertPath(paths, new Path(root, root.i, root.j + 1, toI, toJ));  
    }
    
    if (paths.size() == 0) {
      break;
    }
    root = popPath(paths);
    
  }
  
  return root.link();
  
}

/**
 * Make a heap of an arraylist
 */
public void insertPath(ArrayList<Path> paths, Path path) {
  paths.add(path);
  bubbleUpPath(paths, paths.size() - 1);
}

public void bubbleUpPath(ArrayList<Path> paths, int n) {
  Path path = paths.get(n);
  while (n > 0) {
    int pn = Math.floor((n + 1) / 2) - 1;
    Path parent = paths.get(pn);
    if (path.distance >= parent.distance) {
      break; 
    }
    paths.set(pn, path);
    paths.set(n, parent);
    n = pn;
  }
}

public void sinkDownPath(ArrayList<Path> paths, int n) {
  int length = paths.size();
  Path path = paths.get(n);
  while (true) {
    int c2n = (n + 1) * 2;
    int c1n = c2n - 1;
    Path swap = null;
    int sn = 0;
    if (c1n < length) {
      Path c1 = paths.get(c1n);
      if (c1.distance < path.distance) {
        swap = c1;
        sn = c1n;
      }
    }
    if (c2n < length) {
      Path c2 = paths.get(c2n);
      if (c2.distance < (null == swap ? path.distance : swap.distance)) {
        swap = c2;
        sn = c2n;
      }
    }
    
    if (null == swap) break;
    
    paths.set(n, swap);
    paths.set(sn, path);
    n = sn;
  }
} 

public Path popPath(ArrayList<Path> paths) {
  Path result = paths.get(0);
  Path end = paths.remove(paths.size() - 1);
  if (paths.size() > 0) {
    paths.set(0, end);
    sinkDownPath(paths, 0);
  }
  return result;
}

class Path {
  
 int i;
 int j;
 float distance;
 Path parent;
 Path child;
 
 public Path(Path parent, int fromI, int fromJ, int toI, int toJ) {
  
  this.parent = parent;
  this.i = fromI;
  this.j = fromJ;
  float dx = toI - fromI;
  float dy = toJ - fromJ;
  this.distance = sqrt((dx * dx) + (dy * dy));
  
 }
  
 public boolean equals(Object b) {
   if (null == b) return false;
   if (! (b instanceof Path) ) return false;
   Path p = (Path) b;
   return i == p.i && j == p.j; 
 }
 
 public int hashCode() {
   return indexOf(i, j);  
 }
 
 public int getNumTurns() {
   int turns = 0;
   Path r = this;
   int di = 0;
   int dj = 0;
   while (null != r.child) {
     int ndi = r.i - r.child.i;
     int ndj = r.j - r.child.j;
     if (di - ndi != 0 || dj - ndj != 0) {
       turns++; 
     }
     di = ndi;
     dj = ndj;
     r = r.child;
   }
   return turns;
 }
 
 public Path getEnd() {
    Path r = this;
   while (null != r.child) {
     r = r.child;
   }
   return r;
 }
 
 public Path link() {
   Path r = this;
   while (null != r.parent) {
     r.parent.child = r;
     r = r.parent;
   }
   return r;
 }
  
}
