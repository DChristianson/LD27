class Game extends Screen {

  boolean gameOver; 
  int mission;
  int agentsLeft;
  Level level;
  Radio radio;
  
  public void setup() {
    level = new Level();
    radio = new Radio();
  }
  
  public void restart() {
    gameOver = false;
    mission = 0;
    agentsLeft = AGENTS_NORMAL;
    level.initMap(0); 
    radio.add(new Message("Hey I need your help. I've infiltrated the compound but this place is a maze."));
    radio.add(new Message("Click on your copy of the map to send me directions."));
    radio.add(new Message("If I get confused I'll check in but we have to keep chatter to a minimum."));
    radio.add(new Message("The radio can only stay on for up to ten seconds at time."));
    radio.add(new Message("You'll have to work fast."));
  }
  
  public void update(float deltaTimeInSeconds) {
    
  }
  
  public void draw() {
    background(0);
    
    radio.draw();
    level.draw();
    
  }  
  
  public Screen next() {
    if (gameOver) {
      return credits;  
    }
    return game;
  }
  
}
