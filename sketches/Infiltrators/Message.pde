class Message {
  
  String text;
  boolean modal;
  float timeLeft;
  Message next;
 
  public Message(String text, boolean modal) {
    this.text = text;
    this.modal = modal;
    this.timeLeft = MAX_TALK_TIME;
  }
 
  public void decrement(float deltaTimeInSeconds) {
    timeLeft = constrain(timeLeft - deltaTimeInSeconds, 0, MAX_TALK_TIME);
  }
  
}
