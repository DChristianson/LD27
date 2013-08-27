class Goal {

  PVector location = new PVector();
  boolean completed = false;
  int weight = 0;
  
  Goal next; 
    
  public void execute(Agent agent, float deltaTimeInSeconds) {}

  public void seesOpponent(Agent agent, Agent opponent) {}

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
      float desiredHeading = direction.heading2D();
      agent.velocity.lerp(direction, deltaTimeInSeconds);
      agent.heading = lerp(agent.heading, desiredHeading, 0.1);  
      
    }
  }
  
}

class Follow extends MoveTo {

  Path path;
  
  public Follow(Path path) {
    this.path = path;
    this.weight = path.getNumTurns();
    Path end = path.getEnd();
    location.set(end.i + 0.5, end.j + 0.5, 0);
  }
  
  public void seesOpponent(Agent agent, Agent other) {
    agent.clear();
    agent.add(new Fight(other));
    agent.nextGoal.seesOpponent(agent, other);
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
        strokeWeight(0.1);
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
    direction.set(path.i + 0.5, path.j + 0.5, 0);
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
      agent.heading = agent.velocity.heading2D();  
      
    }
  }
  
}

class Fight extends MoveTo {
  
  float fightTime = 0;
  float warmUp = 0;
  Agent opponent;
  PVector lastSeenAt = new PVector();
  boolean shooting = false;
  
  public Fight(Agent opponent) {
    this.opponent = opponent;
  }  
  
  public void seesOpponent(Agent agent, Agent other) {
    if (opponent != other) return;
    lastSeenAt.set(other.location);
  }
  
  public void execute(Agent agent, float deltaTimeInSeconds) {
    // kludge
    location.set(agent.location);
    
    // fight until win
    if (!opponent.alive) {
      agent.alert = false;
      completed = true;
      return; 
    }
    
    // keep fighting
    fightTime += deltaTimeInSeconds;
    warmUp += deltaTimeInSeconds;
    
    agent.alert = true;
    boolean los = playfieldLineOfSight(level.playfield, floor(agent.location.x), floor(agent.location.y), floor(lastSeenAt.x), floor(lastSeenAt.y), direction);
    float distance = direction.mag();
    if (distance < 1) {
      if (fightTime > 1 && random(100) > 50) {
        fightTime = 0;
        
        // struggle for a bit then execute throw for knockout
        direction.fromAngle(random(TWO_PI));
        direction.normalize();
        direction.mult(3.0);
        opponent.clear();
        opponent.velocity.set(direction);
        opponent.add(new Knockout());
        
      }
      
    } else {

      // shooting and dodging
      shooting = false;
      
      // Kludgey circle strafe
      agent.heading = direction.heading2D();
      float theta = sin(fightTime) > 0 ? HALF_PI : - HALF_PI;
      float tx = direction.x;
      direction.x = direction.x * cos(theta) - direction.y * sin(theta);
      direction.y = tx * sin(theta) + direction.y * cos(theta);
      direction.normalize();
      direction.mult(2.0);
      agent.velocity.set(direction);

      if (warmUp > 0.5 && warmUp < 1.0 && random(100) > 50 && los) {
          shooting = true;
          opponent.clear();
          opponent.velocity.set(direction);
          opponent.add(new Knockout());
          
      } else if (warmUp >= 1.0) {
          warmUp = 0;
          shooting = false; 
          
      }
      
    }
    
  }
  
  public void draw() {
    
    if (shooting) {
      // more bad last minute kludges to get gunpoint
      direction.set(lastSeenAt);
      direction.sub(location);
      direction.normalize();
      direction.mult(0.6);
      
      strokeWeight(0.1);
      stroke(255, 0, 255, 192 * cos(warmUp));
      line(location.x + direction.x, location.y + direction.y, lastSeenAt.x, lastSeenAt.y);
    }
    
  }
  
}

class Takedown extends Fight {
  
  float takedownTime = 0;

  public Takedown(Agent opponent) {
    super(opponent);
  }  

  public void execute(Agent agent, float deltaTimeInSeconds) {
    if (!opponent.alive) {
      agent.alert = false;
      completed = true;
      return; 
    }
    
    takedownTime += deltaTimeInSeconds;
    
    if (takedownTime > 3) {
      agent.alert = false;
      completed = true;
      return; 
    }
    
    direction.set(lastSeenAt);
    direction.sub(agent.location);
    float distance = direction.mag();
    if (distance < 1) {
      agent.alert = true;
      
      // try to take down
      opponent.clear();
      opponent.add(new Knockout());
      
    } else {
      agent.alert = false;

      // quickly move towards
      direction.set(lastSeenAt);
      direction.sub(agent.location);
      direction.normalize();
      direction.mult(3);
      agent.heading = direction.heading2D();
      agent.velocity.set(direction);
      
    }
  }
  
}

class Knockout extends Goal {

  float knockoutTime = 0;
  public void execute(Agent agent, float deltaTimeInSeconds) {
      agent.alert = false;
      agent.alive = false;
      knockoutTime  += deltaTimeInSeconds;
      if (knockoutTime > 5) {
        completed = true;
      }
  }
  
}
class Ambush extends Goal {

  public Ambush() {}
  
  public void execute(Agent agent, float deltaTimeInSeconds) {
    println("ambush mode");
    float distance = agent.location.dist(guard.location);
    if (distance < 1) {
      println("super awesome takedown!"); 
    } else {
      println("waiting for ambush");
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
      if (completed && !guard.active) {
        // send the guard out
        guard.hunt(agent);  
      }
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
