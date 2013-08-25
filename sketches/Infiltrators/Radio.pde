class Radio {
  
  Message next = null;
  Message lastGoal = null;
  
  float talkTime = 0;
  float totalTalkTime = 0;
 
  public void setup() {

  }

  public void reset() {
    talkTime = 0;  
  }
  
  public boolean isModal() {
    return null != next && next.modal;  
  }

  public boolean isOverLimit() {
    return talkTime > MAX_TALK_TIME;  
  }

  public boolean isActive() {
    return (null != next); 
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
      totalTalkTime += deltaTimeInSeconds;
    }

    next.decrement(deltaTimeInSeconds);
    if (!(next.timeLeft > 0)) {
      next = next.next;
    }
    
    if (null == next) {
      lastGoal = null; 
    }
    
  } 
  
  public void draw() {
    
    // timer
    pushMatrix();
    translate(width - 40, height - 40);
    stroke(255, 255, 255, 200);
    strokeWeight(2);
    ellipseMode(CENTER);
    ellipse(0, 0, 60, 60);
    
    // 10S MARK
    rotate(- 2 * PI / 3);
    stroke(255, 0, 0, 200);
    line(0, 0, 0, 30);

    // TALK TIME
    rotate(talkTime * PI / 30f - PI / 3);
    stroke(255, 255, 255, 200);
    beginShape(TRIANGLES);
    vertex(-1, 0);
    vertex(0, 30);
    vertex(1, 0);
    endShape();


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
