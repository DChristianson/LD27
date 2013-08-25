class Goal {

  PVector location = new PVector();
  boolean completed = false;
  
  Goal next; 
    
  public void execute(Agent agent, float deltaTimeInSeconds) {}

  public void draw() {}

  public String getDescription() {
    return null;
  }
    
}

class MoveTo extends Goal {

  PVector direction = new PVector();

  public void draw() {
    pushMatrix();
    translate(location.x, location.y);
    stroke(255);
    fill(200);
    ellipseMode(CENTER);
    ellipse(0, 0, 1, 1);
    popMatrix();
  }
 
  public void execute(Agent agent, float deltaTimeInSeconds) {
    direction.set(location);
    direction.sub(agent.location);
    if (direction.mag() < .5) {
      completed = true; 
      agent.velocity.mult(0);
      
    } else {      
      float desiredHeading = direction.heading();
      agent.velocity.lerp(direction, deltaTimeInSeconds);
      agent.heading = lerp(agent.heading, desiredHeading, deltaTimeInSeconds);  
      
    }
  }
  
}

class Tell extends Goal {
  
  String statement;
  boolean showMap;
  
  public Tell(String statement, boolean showMap) {
    this.location.set(agent.location); // KLUDGE
    this.statement = statement; 
    this.showMap = showMap;
  }
  
  public void execute(Agent agent, float deltaTimeInSeconds) {
    radio.add(new Message(statement, true, !showMap));
    completed = true;
  }
  
}

class Ask extends Goal {
  
  String question;
  
  public Ask(String question) {
    this.location.set(agent.location);// KLUDGE
    this.question = question; 
  }
  
  public void execute(Agent agent, float deltaTimeInSeconds) {
    radio.add(new Message(question, false, false));
    completed = true;
  }
  
  public void draw() {
    pushMatrix();
    ellipseMode(CENTER);
    translate(agent.location.x, agent.location.y);
    stroke(0, 0, 255);
    noFill();
    ellipse(0, 0, 2, 2);
    popMatrix();
  }
  
}

class Wait extends Goal {
 
  float timeLeft;
  
  public Wait(float waitTime) {
    this.location.set(agent.location); // KLUDGE
    this.timeLeft = waitTime; 
  }
  
  public void execute(Agent agent, float deltaTimeInSeconds) {
    if (!radio.isActive()) timeLeft -= deltaTimeInSeconds;
    completed = (timeLeft <= 0) || (next != null); // I've got a new goal
  }
 
}

/**
 * Mission goal
 */
class Breach extends Goal {

    public void execute(Agent agent, float deltaTimeInSeconds) {
      completed = location.dist(agent.location) < .5;
    }

    public String getDescription() {
      return "Breach the facility"; 
    }
  
    public void draw() {
      pushMatrix();
      ellipseMode(CENTER);
      translate(location.x, location.y);
      stroke(0, 255, 0);
      noFill();
      ellipse(0, 0, 2, 2);
      popMatrix();
    }

}

/**
 * Mission goal
 */
class Exit extends Goal {
  
    public void execute(Agent agent, float deltaTimeInSeconds) {
      completed = location.dist(agent.location) < .5;
    }
  
    public String getDescription() {
      return "Get to the exit"; 
    }
  
    public void draw() {
      pushMatrix();
      ellipseMode(CENTER);
      translate(location.x, location.y);
      stroke(255, 0, 0);
      noFill();
      ellipse(0, 0, 2, 2);
      popMatrix();
    }

}