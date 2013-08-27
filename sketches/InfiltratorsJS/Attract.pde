class Attract extends Screen {
  
  public void setup() {}
  
  public void draw() {
    background(0);
    textAlign(CENTER);
    text("Infiltrators", width / 2, height / 2);
    text("<click mouse to continue>", width / 2, height / 2 + 12);
  }  
  
  public Screen next() {
    if (click) {
      game.restart();
      return game;  
    }
    return attract;
  }
  
}
