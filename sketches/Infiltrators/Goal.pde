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
    strokeWeight(0.1);
    stroke(255);
    fill(200);
    ellipseMode(CENTER);
    ellipse(0, 0, 1, 1);
    popMatrix();
  }
 
  public void execute(Agent agent, float deltaTimeInSeconds) {
    direction.set(location);
    direction.sub(agent.location);
    if (direction.mag() < .1) {
      completed = true; 
      agent.velocity.mult(0);
      
    } else {      
      direction.normalize();
      direction.mult(2.0);
      float desiredHeading = direction.heading();
      agent.velocity.lerp(direction, deltaTimeInSeconds);
      agent.heading = lerp(agent.heading, desiredHeading, 0.1);  
      
    }
  }
  
}

class Follow extends MoveTo {

  Path path;
  
  public Follow(Path path) {
    this.path = path;
    Path end = path.getEnd();
    location.set(end.i + 0.5, end.j + 0.5);
  }
  
  public void draw() {
    pushMatrix();
    translate(location.x, location.y);
    strokeWeight(0.1);
    stroke(0, 255, 0);
    fill(200);
    ellipseMode(CENTER);
    ellipse(0, 0, 0.5, 0.5);
    popMatrix();

    if (null != path) {
      Path node = path;
      float alpha = 255;
      while (null != node) {
        alpha *= 0.75;
        pushMatrix();
        translate(node.i + 0.5, node.j + 0.5);
        stroke(255, 255, 255, alpha);
        fill(200, 200, 200, alpha);
        ellipseMode(CENTER);
        ellipse(0, 0, 0.5, 0.5);
        popMatrix();
        node = node.child;
      }
    }
    
  }
 
  public void execute(Agent agent, float deltaTimeInSeconds) {
    direction.set(path.i + 0.5, path.j + 0.5);
    direction.sub(agent.location);
    if (direction.mag() < .1) {
      path = path.child;
      if (null == path) {
        completed = true; 
        agent.velocity.mult(0);
      }
      
    } else {      
      direction.normalize();
      direction.mult(2.0);
      agent.velocity.set(direction);
      agent.heading = agent.velocity.heading();  
      
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
      completed = location.dist(agent.location) < .1;
    }

    public String getDescription() {
      return "Breach the facility"; 
    }
  
    public void draw() {
      pushMatrix();
      translate(location.x, location.y);
      strokeWeight(0.1);
      stroke(0, 255, 0);
      noFill();
      ellipseMode(CENTER);
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
      translate(location.x, location.y);
      strokeWeight(0.1);
      stroke(255, 0, 0);
      noFill();
      ellipseMode(CENTER);
      ellipse(0, 0, 2, 2);
      popMatrix();
    }

}

/**
 * Mission goal
 */
class Terminal extends Goal {

    public void execute(Agent agent, float deltaTimeInSeconds) {
      completed = location.dist(agent.location) < .1;
    }

    public String getDescription() {
      return "Hack the terminal"; 
    }
  
    public void draw() {
      pushMatrix();
      translate(location.x, location.y);
      strokeWeight(0.1);
      stroke(0, 0, 255);
      noFill();
      ellipseMode(CENTER);
      ellipse(0, 0, 2, 2);
      popMatrix();
    }

}

/**
 * Mission goal
 */
class Suitcase extends Goal {

    public void execute(Agent agent, float deltaTimeInSeconds) {
      completed = location.dist(agent.location) < .1;
    }

    public String getDescription() {
      return "Get the suitcase"; 
    }
  
    public void draw() {
      pushMatrix();
      translate(location.x, location.y);
      strokeWeight(0.1);
      stroke(0, 0, 255);
      noFill();
      ellipseMode(CENTER);
      ellipse(0, 0, 2, 2);
      popMatrix();
    }

}
