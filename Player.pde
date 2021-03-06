class Player extends Actor {
  
  Player(PVector pos_) {
    super(pos_);
  }
  
  void show() {
    fill(#2270ff);
    circle(pos.x, pos.y, 2*RADIUS);
  }
  
  String statusString() {
    String status = super.statusString();
    
    return status;
  }
  
  void fromStatusString(String status) {
    super.fromStatusString(status);
    
  }
}
