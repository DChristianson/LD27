class Game extends Screen {

  boolean gameOver = false; 
  boolean overLimit = false;
  int missionNumber = 0;
  float totalPlayTime = 0;  
  
  public void setup() {}
  
  public void restart() {
    gameOver = false;
    missionNumber = 0;
  }
  
  public void nextLevel() {
    
    level.initMap(missionNumber); 
    radio.reset();
    overLimit = false;
    agent.clear();
    agent.velocity.mult(0);
    agent.active = true;
    guard.clear();
    guard.velocity.mult(0);
    guard.active = false;
    
    // find level start and put agent there
    boolean found = level.find(TILE_ENTRANCE, agent.location);
    
    // mission parameters: enter level
    Breach breach = new Breach();
    breach.location.set(agent.location.x, agent.location.y);
    agent.addMission(breach);
        
    if (1 == missionNumber) {
      
      agent.add(new Tell("This is " + agent.name + ". I've just infiltrated the compound.", false));
      agent.add(new Tell("Unfortunately this place is a maze and I'll need your help to navigate it.", false));
      agent.add(new Tell("Click on your copy of the map to give me directions.", true));
      agent.add(new Tell("If I get confused I'll check back in but we have to keep chatter to a minimum.", false));
      agent.add(new Tell("The guards will pinpoint my location if I use this channel for more than 10 seconds in one location.", false));
      agent.add(new Tell("I'm counting on you to work fast.", true));
      agent.add(new Tell("Let's do this.", false));

      guard.location.set(agent.location);
      guard.active = false;

            
    } else if (2 == missionNumber) {

      agent.add(new Tell("Made it.", false));
      agent.add(new Tell("There's a control panel on this level, we have to make it there first before we can exit.", true));
      agent.add(new Tell("There's a guard wandering around too, we'll have to avoid him.", true));
      agent.add(new Tell("Let's do this.", false));
      
      Terminal terminal = new Terminal();
      terminal.location.set(1.5 + (int) random(MAP_WIDTH - 2), 1.5 + (int) random(MAP_HEIGHT - 2));
      setTile(level.playfield, (int) terminal.location.x, (int) terminal.location.y, TILE_EMPTY);
      agent.addMission(terminal);
      
      guard.location.set(terminal.location);
      guard.active = true;
      
    } else if (3 == missionNumber) {
      
      agent.add(new Tell("Okay.", false));
      agent.add(new Tell("The suitcase is on this level, grab it and we can get out of here.", true));
      agent.add(new Tell("I don't see any guards so this should be super easy.", true));
      agent.add(new Tell("Let's do this.", false));
      
      guard.location.set(agent.location);
      guard.active = false;
      
      Suitcase suitcase = new Suitcase();
      suitcase.location.set(1.5 + (int) random(MAP_WIDTH - 2), 1.5 + (int) random(MAP_HEIGHT - 2));
      setTile(level.playfield, (int) suitcase.location.x, (int) suitcase.location.y, TILE_EMPTY);
      agent.addMission(suitcase);      
      
    }

    // mission parameters: exit level
    Exit exit = new Exit();
    level.find(TILE_EXIT, exit.location);
    exit.location.y += 1;
    agent.addMission(exit);

    agent.add(new Wait(WAIT_TIME));
    
  }
  
  public void update(float deltaTimeInSeconds) {
    
    totalPlayTime += deltaTimeInSeconds;
    
    level.update(deltaTimeInSeconds);

    if (agent.active) {
      agent.update(deltaTimeInSeconds);
    }
    if (guard.active) {
      guard.update(deltaTimeInSeconds); 
    }

    if (agent.active && guard.active) {
      boolean hasLos = level.lineOfSight(agent.location.x, agent.location.y, guard.location.x, guard.location.y); 
      println("line of sight:" + hasLos);
      if (hasLos) {
        && null != agent.nextGoal) {
        agent.nextGoal.seesOpponent(guard); 
      }
      if (hasLos && null != guard.nextGoal) {
        guard.nextGoal.seesOpponent(agent);
      }
    }
    
    radio.update(deltaTimeInSeconds);
        
    // game states
    if (null == agent.nextMissionGoal) {
      missionNumber++;
      nextLevel();
      if (missionNumber > 3) {
        gameOver = true;
      }
      
    } else if (!overLimit && radio.isOverLimit()) {
      overLimit = true;
      
      // agent should do this
      agent.clear();
      agent.add(new Tell("We've keep radio communication open too long, guards are alerted.", true));
      
      // activate guard 
      Path seek = searchPathTree(level.playfield, (int) guard.location.x, (int) guard.location.y, (int) agent.location.x, (int) agent.location.y, 1000);
      guard.clear();
      guard.add(new Follow(seek));
      guard.active = true;
      
    }
    
    if (key == 'Q') {
      gameOver = true;
      key=0;
    }
  }
  
  public void draw() {
    
    background(0);
    
    level.draw();
    radio.draw();

  }  
  
  public Screen next() {
    if (gameOver) {
      return credits;  
    }
    return game;
  }
  
}
