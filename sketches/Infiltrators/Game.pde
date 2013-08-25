class Game extends Screen {

  boolean gameOver = false; 
  int missionNumber = 0;
  
  
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
    breach.location.set(agent.location.x, agent.location.y - 1);
    agent.addMission(breach);
    
    // mission parameters: exit level
    Exit exit = new Exit();
    level.find(TILE_EXIT, exit.location);
    agent.addMission(exit);
    agent.add(new Tell("This is " + agent.name + ". I've just infiltrated the compound.", false));
    agent.add(new Tell("Unfortunately this place is a maze and I'll need your help to navigate it.", false));
    agent.add(new Tell("Click on your copy of the map to give me directions.", true));
    agent.add(new Tell("If I get confused I'll check back in but we have to keep chatter to a minimum.", false));
    agent.add(new Tell("The guards will pinpoint my location if I use this channel for more than 10 seconds in one location.", false));
    agent.add(new Tell("I'm counting on you to work fast.", true));
    agent.add(new Tell("Let's do this.", false));
    agent.add(new Wait(WAIT_TIME));
    
  }
  
  public void update(float deltaTimeInSeconds) {
    level.update(deltaTimeInSeconds);
    agent.update(deltaTimeInSeconds);
    radio.update(deltaTimeInSeconds);
    
    if (null == agent.nextMissionGoal) {
      agent.clear();
      println("agent completed mission"); 
      missionNumber++;
      nextLevel();
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
