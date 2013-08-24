class Game extends Screen {

  boolean gameOver; 
  int mission;
  int agentsLeft;
  
  Level level;
  Radio radio;
  Agent agent;
  
  public void setup() {
    level = new Level();
    level.setup();
    radio = new Radio();
    radio.setup();
    agent = new Agent();
    agent.setup();
  }
  
  public void restart() {
    gameOver = false;
    mission = 0;
    level.initMap(0); 
    
    agentsLeft = AGENTS_NORMAL;
    boolean found = level.find(TILE_ENTRANCE, agent.location);
    println("found entrance: " + found + " -> " + agent.location);
    
    radio.add(new Message("Hey I need your help. I've infiltrated the compound but this place is a maze.", true));
    radio.add(new Message("Click on your copy of the map to help me navigate.", true));
    radio.add(new Message("If I get confused I'll check back in on the radio but we have to keep chatter to a minimum.", true));
    radio.add(new Message("The guards will pinpoint my location if I leave this channel open for more than 10 seconds in one location.", true));
    radio.add(new Message("I'm counting on you to work fast.", true));
  }
  
  public void update(float deltaTimeInSeconds) {
    agent.update(deltaTimeInSeconds);
    radio.update(deltaTimeInSeconds);
  }
  
  public void draw() {
    
    background(0);
    
    level.draw();
    radio.draw();
    agent.draw();
    
  }  
  
  public Screen next() {
    if (gameOver) {
      return credits;  
    }
    return game;
  }
  
}
