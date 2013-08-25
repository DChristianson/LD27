class Game extends Screen {

  boolean gameOver = false; 
  int missionNumber = 0;
  float totalPlayTime = 0;  
  
  public void setup() {}
  
  public void restart() {
    gameOver = false;
    missionNumber = 0;
  }
  
  public void nextLevel() {
    level.initMap(missionNumber); 
    
    // find level start
    boolean found = level.find(TILE_ENTRANCE, agent.location);
    println("found entrance: " + found + " -> " + agent.location);
    
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
      
    } else if (2 == missionNumber) {
      
      agent.add(new Tell("Made it.", false));
      agent.add(new Tell("There's a control panel on this level, we have to make it there first before we can exit.", true));
      
      Terminal terminal = new Terminal();
      terminal.location.set(1.5 + (int) random(MAP_WIDTH - 2), 1.5 + (int) random(MAP_HEIGHT - 2));
      setTile(level.playfield, (int) terminal.location.x, (int) terminal.location.y, TILE_EMPTY);
      agent.addMission(terminal);
      
    } else if (3 == missionNumber) {
      
      agent.add(new Tell("Okay.", false));
      agent.add(new Tell("The suitcase is on this level, grab it and we can get out of here.", true));
      
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
    agent.update(deltaTimeInSeconds);
    radio.update(deltaTimeInSeconds);
    
    if (null == agent.nextMissionGoal) {
      missionNumber++;
      agent.clear();
      agent.velocity.mult(0);
      nextLevel();
      if (missionNumber > 3) {
        gameOver = true;
      }
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
