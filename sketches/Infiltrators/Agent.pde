class Agent {
  
  String name;
  PVector location = new PVector();  
  PVector velocity = new PVector();
  float heading = - PI / 2;
  float patience = 75;

  Goal nextMissionGoal;
  Goal lastMissionGoal;
  
  int numGoals = 0;
  Goal nextGoal;
  Goal lastGoal;
  
  public void setup() {
    name = "Agent " + ((int) random(100));
  }
  
  public void update(float deltaTimeInSeconds) {

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
        nextGoal = nextGoal.next;
        numGoals--;
        if (null == nextGoal) {
          lastGoal = null;
        }  
      }
      
    } else if (null != nextMissionGoal) {
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
    if (MAX_GOALS == numGoals) {
      return; 
    }
    if (null == lastGoal) {
      nextGoal = goal;  
    } else {
      lastGoal.next = goal; 
    }
    lastGoal = goal;
    goal.next = null;
    numGoals++;
  }
  
  public void clear() {
    numGoals = 0;
    nextGoal = null;
    lastGoal = null; 
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
    stroke(255);
    fill(200);
    ellipseMode(CENTER);
    ellipse(0, 0, 1, 1);
    line(.5, .5, 1, 0);
    line(1, 0, .5, -.5);
    popMatrix(); 

   
  }
  
}
