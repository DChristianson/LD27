class Message {
  
  String text;
  float timeLeft;
  Message next;
 
  public Message(String text) {
    this.text = text;
    this.timeLeft = MAX_TALK_TIME;
  }
 
  public void decrement(float deltaTimeInSeconds) {
    timeLeft = constrain(timeLeft - deltaTimeInSeconds, 0, MAX_TALK_TIME);
  }
  
}
