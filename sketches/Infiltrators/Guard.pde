class Guard extends Agent {
  
   public void setup() {
    name = "Guard " + ((int) random(100));
    teamColor = color(255, 0, 0, 255);
  }
   
  public void update(float deltaTimeInSeconds) {

    if (active && alive && null == nextGoal) {
      // go patrol
      PVector target = new PVector();
      level.random(TILE_EMPTY, target);
      Path seek = searchPathTree(level.playfield, (int) location.x, (int) location.y, (int) target.x, (int) target.y, 1000);
      clear();
      add(new Follow(seek));
    }
    
    super.update(deltaTimeInSeconds);

  }
  
  public void hunt(Agent agent) {
    Path seek = searchPathTree(level.playfield, (int) guard.location.x, (int) guard.location.y, (int) agent.location.x, (int) agent.location.y, 1000);
    clear();
    add(new Follow(seek));
    active = true;
    alive = true;
  }
  
}
