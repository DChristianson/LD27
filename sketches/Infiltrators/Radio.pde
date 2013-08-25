class Radio {
  
  Message next = null;
  Message lastGoal = null;
  float talkTime = 0;
  
  public void setup() {

  }
  
  public boolean isModal() {
    return null != next && next.modal;  
  }

  public boolean isActive() {
    return null != next;  
  }
  
  public void add(Message message) {
    if (null == lastGoal) {
      next = message;  
    } else {
      lastGoal.next = message; 
    }
    lastGoal = message;
    message.next = null;
  }
  
  public void update(float deltaTimeInSeconds) {
    if (!isActive()) return;
    
    if (!next.modal) {
      talkTime += deltaTimeInSeconds;
    }
    next.decrement(deltaTimeInSeconds);
    if (!(next.timeLeft > 0) || (next.modal && click)) {
      next = next.next;
    }
    
    if (null == next) {
      lastGoal = null; 
    }
    
  } 
  
  public void draw() {
    stroke(255);
    pushMatrix();
    translate(width - 50, 0);
    line(0, 0, 20, 20); 
    line(0, 20, 20, 0); 
    text(floor(talkTime), 0, 20);
    popMatrix();


    if (isActive()) {
      pushMatrix();
      translate(width / 2, height * 3 / 4);
      float tw = textWidth(next.text);
      noStroke();
      fill(64, 64, 64, 220);
      rect(-tw / 2 - 12, -12, tw + 24, 24);
      stroke(255);
      fill(255);
      text(next.text, 0, 0); 
      popMatrix();
    }
  }
  
}
