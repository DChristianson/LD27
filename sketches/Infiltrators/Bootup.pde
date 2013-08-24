class Bootup extends Screen {
  
  float percent = 0;
  boolean done = false;
  
  public void update(float deltaTimeInSeconds) {
    percent = constrain(percent + deltaTimeInSeconds * 10, 0, 100);
    if (null == attract) {
      attract = new Attract();
      attract.setup();
      percent = 33;
    } else if (null == game) {
      game = new Game();
      game.setup();     
      percent = 66;
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
