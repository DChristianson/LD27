class Agent {
  
  String name;
  PVector location = new PVector();  
  PVector velocity = new PVector();
  float heading = - PI / 2;
  float patience = 75;
  float fov = PI / 2;
  int teamColor;
  boolean active = false;
  boolean alert = false;
  boolean alive = true;
  float timeSpentDead = 0;
  
  Goal nextMissionGoal;
  Goal lastMissionGoal;
  
  int numGoals = 0;
  int cumWeight = 0;
  Goal nextGoal;
  Goal lastGoal;
  
  public void setup() {
    name = "Agent " + (floor(random(100)));
    teamColor = color(255, 255, 255, 255);
  }
  
  public boolean inFov(float losHeading) {
    float deltaAngle = heading - losHeading;
    float angle = abs(atan2(sin(deltaAngle), cos(deltaAngle)));
    return angle < fov;
  }
  
  public void seesOpponent(Agent opponent, float losHeading) {
    if (!opponent.alive) return;
    if (inFov(losHeading)) {
      if (null == nextGoal) {
        // can see
        if (opponent.inFov(-losHeading)) {
          // both can see
          // start fighting
          clear();
          add(new Fight(opponent));          
          
        } else {
          // takedown 
          clear();
          add(new Takedown(opponent));        
          
        }
      }
      
      nextGoal.seesOpponent(this, opponent);
         
    }
  }
  
  public void update(float deltaTimeInSeconds) {
    if (!alive) {
      // safety kludge 
      timeSpentDead += deltaTimeInSeconds;
    } else {
      timeSpentDead = 0;
    }

    // check mission goals
    if (null != nextMissionGoal) {
      nextMissionGoal.execute(this, deltaTimeInSeconds);
      if (nextMissionGoal.completed) {
        nextMissionGoal = nextMissionGoal.next;
        if (null == nextMissionGoal) {
          lastMissionGoal = null;
        } 
      }
    }

    // execute current sub goal
    if (null != nextGoal) {
      nextGoal.execute(this, deltaTimeInSeconds);  
      if (nextGoal.completed) {
        numGoals--;
        cumWeight -= nextGoal.weight;
        nextGoal = nextGoal.next;
        if (null == nextGoal) {
          lastGoal = null;
        }  
      }
      
    } else if (alive && null != nextMissionGoal) {
      // need a new sub goal
      if (random(100) > patience) {
        add(new Ask("Show me where to go next."));       
      }
      patience = constrain(patience - 10, 25, 100);
      add(new Wait(WAIT_TIME));
      
    }
    
    level.collide(location, velocity, 0.25, deltaTimeInSeconds);
        
  }
  
  public void addMission(Goal goal) {
    if (null == lastMissionGoal) {
      nextMissionGoal = goal;  
    } else {
      lastMissionGoal.next = goal; 
    }
    lastMissionGoal = goal;
    goal.next = null;
  }
 
  public void add(Goal goal) {
    if (null == lastGoal) {
      nextGoal = goal;  
    } else {
      lastGoal.next = goal; 
    }
    lastGoal = goal;
    goal.next = null;
    numGoals++;
    cumWeight += goal.weight;
       if (cumWeight > MAX_WEIGHT) {
      
    }  
  }
  
  public void clear() {
    numGoals = 0;
    cumWeight = 0;
    nextGoal = null;
    lastGoal = null; 
  }
  
  public void clearMission() {
    clear();
    nextMissionGoal = null;
    lastMissionGoal = null; 
  }
  
  public void draw() {
        
    Goal goal = nextGoal;
    while (null != goal) {
      goal.draw();
      goal = goal.next;
    }

    Goal missionGoal = nextMissionGoal;
    while (null != missionGoal) {
      missionGoal.draw();
      missionGoal = missionGoal.next;
    }
    
    pushMatrix();
    translate(location.x, location.y);
    rotate(heading);    
    scale(0.5);
    strokeWeight(0.1);
    stroke(alive ? teamColor : 64);
    fill(64);
    ellipseMode(CENTER);
    ellipse(0, 0, 1, 1);
    if (!alert) {
      // guns holstered
      scale(0.5);
      line(1, 1, 2, 0); // in js line rounds args. seriously?
      line(2, 0, 1, -1);
     
    } else {
      // guns drawn
      scale(0.5);
      line(1, 1, 2, 1);
      line(1, -1, 2, -1);
      
    }
    popMatrix(); 

   
  }
  
}
