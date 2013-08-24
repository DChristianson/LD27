class Credits extends Screen {
 
  public void setup() {}
  
  public void draw() {
    background(0);
    textAlign(CENTER);
    text("Game Over", width / 2, height / 2);
    text("<click mouse to continue>", width / 2, height / 2 + 12);
  }  
  
  public Screen next() {
    if (click) {
      return attract;  
    }
    return credits;
  }
 
}
