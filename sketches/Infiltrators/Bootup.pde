class Bootup extends Screen {
  
  float percent = 0;
  boolean done = false;
  
  public void update(float deltaTimeInSeconds) {
    percent = constrain(percent + deltaTimeInSeconds * 10, 0, 100);
    if (null == attract) {
      attract = new Attract();
      attract.setup();
      percent = 10;
    } else if (null == game) {
      game = new Game();
      game.setup();     
      percent = 20;
    } else if (null == level) {
      level = new Level();
      level.setup();
      percent = 40;
    } else if (null == radio) {
      radio = new Radio();
      radio.setup();
      percent = 60;
    } else if (null == agent) {
      agent = new Agent();
      agent.setup();
      percent = 80;
    } else if (null == credits) {
      credits = new Credits();
      credits.setup(); 
      percent = 100;
    } else if (percent >= 100) {
      done = true; 
    }
  }
  
  public void draw() {
    background(0);
    textAlign(CENTER);
    text(percent, width / 2, height / 2);
  } 
  
  public Screen next() {
    if (done) {
      return attract;
    }
    return bootup;
  }
  
}
