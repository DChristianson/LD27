class Guard extends Agent {
  
   public void setup() {
    name = "Guard " + (floor(random(100)));
    teamColor = color(255, 0, 0, 255);
  }
   
  public void update(float deltaTimeInSeconds) {

    if (active && alive && null == nextGoal) {
      // go patrol
      PVector target = new PVector();
      level.random(TILE_EMPTY, target);
      Path seek = searchPathTree(level.playfield, floor(location.x), floor(location.y), floor(target.x), floor(target.y), 1000);
      clear();
      add(new Follow(seek));
    }
    
    super.update(deltaTimeInSeconds);

  }
  
  public void hunt(Agent agent) {
    Path seek = searchPathTree(level.playfield, floor(guard.location.x), floor(guard.location.y), floor(agent.location.x), floor(agent.location.y), 1000);
    clear();
    add(new Follow(seek));
    active = true;
    alive = true;
  }
  
}
