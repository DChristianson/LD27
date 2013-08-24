class Screen {
  
  public Screen() {}
  
  public void setup() {}
  
  public void update(float deltaTimeInSeconds) {}
  
  public void draw() {
    background(0); 
  }
  
  public Screen next() {
    return this;
  }  
  
}
