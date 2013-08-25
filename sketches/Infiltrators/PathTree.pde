
/**
 * Good old fashioned A*
 */
public Path searchPathTree(int[] playfield, int fromI, int fromJ, int toI, int toJ, int limit) {
  
  boolean[] visited = new boolean[playfield.length];
  SortedSet<Path> paths = new TreeSet<Path>();
  
  Path root = new Path(null, fromI, fromJ, toI, toJ);
  
  while (root.distance > 0 && limit > 0) {
    --limit;
    
    int idx = indexOf(root.i, root.j);
    visited[idx] = true;
    
    int left = tileAdd(idx, -1, 0);
    if (inBounds(left) && !visited[left] && TILE_WALL != playfield[left]) {
      paths.add(new Path(root, root.i - 1, root.j, toI, toJ));  
    }
    int right = tileAdd(idx, 1, 0);
    if (inBounds(right) && !visited[right] && TILE_WALL != playfield[right]) {
      paths.add(new Path(root, root.i + 1, root.j, toI, toJ));  
    }
    int up = tileAdd(idx, 0, -1);
    if (inBounds(up) && !visited[up] && TILE_WALL != playfield[up]) {
      paths.add(new Path(root, root.i, root.j - 1, toI, toJ));  
    }
    int down = tileAdd(idx, 0, 1);
    if (inBounds(down) && !visited[down] && TILE_WALL != playfield[down]) {
      paths.add(new Path(root, root.i, root.j + 1, toI, toJ));  
    }
    
    if (paths.isEmpty()) {
      break;
    }
    root = paths.first();
    paths.remove(root);
    
  }
  
  return root.link();
  
}

class Path implements Comparable<Path> {
 
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
 
 public int compareTo(Path p) {
   int c = Float.compare(distance, p.distance);  
   if (0 == c) {
     c = i - p.i; 
   }
   if (0 == c) {
     c = j - p.j;
   }
   return c;
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
