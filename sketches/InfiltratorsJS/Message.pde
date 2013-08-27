class Message {
  
  String text;
  boolean modal;
  boolean zoom;
  float timeLeft;
  Message next;
 
  public Message(String text, boolean modal, boolean zoom) {
    this.text = text;
    this.modal = modal;
    this.timeLeft = MESSAGE_TIME;
    this.zoom = zoom;
  }
 
  public void decrement(float deltaTimeInSeconds) {
    timeLeft = constrain(timeLeft - deltaTimeInSeconds, 0, MAX_TALK_TIME);
  }
  
}
