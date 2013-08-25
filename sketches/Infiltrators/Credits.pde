class Credits extends Screen {
 
  public void setup() {}
  
  public void draw() {
    background(0);
    strokeWeight(1);
    stroke(255);
    fill(255);
    textAlign(CENTER);
    text("Game Over - Thanks For Playing", width / 2, height / 2);
    text("Total Radio Time: " + radio.totalTalkTime + " Play Time: " + game.totalPlayTime, width / 2, height / 2 + 12);
    text("<click mouse to continue>", width / 2, height / 2 + 24);
  }  
  
  public Screen next() {
    if (click) {
      return attract;  
    }
    return credits;
  }
 
}
