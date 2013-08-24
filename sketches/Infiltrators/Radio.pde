class Radio {
  
  Message next = null;
  Message last = null;
  
  public void setup() {

  }
  
  public boolean isActive() {
    return null != next;  
  }
  
  public void clear() {
    next = null;
    last = null; 
  }
  
  public void add(Message message) {
    if (null == last) {
      next = message;  
    } else {
      last.next = message; 
    }
    last = message;
    message.next = null;
  }
  
  public void update(float deltaTimeInSeconds) {
    if (!isActive()) return;
    
    next.decrement(deltaTimeInSeconds);
    if (!(next.timeLeft > 0) || (next.modal && click)) {
      next = next.next;
    }
    
    if (null == next) {
      last = null; 
    }
    
  } 
  
  public void draw() {
    stroke(255);
    pushMatrix();
    translate(width - 20, 0);
    line(0, 0, 20, 20); 
    line(0, 20, 20, 0); 
    popMatrix();
    if (isActive()) {
      text(next.text, width / 2, height / 2); 
      if (next.modal) {
        text("<click to continue>", width / 2, height / 2 + 12);        
      }
    }
  }
  
}
