class Enemy extends Actor {
  Enemy(PVector pos_) {
    super(pos_);
  }
  
  void show() {
    fill(#3FBC2F);
    circle(pos.x, pos.y, RADIUS);
  }
  
  String statusString() {
    String status = super.statusString();
    
    return status;
  }
  
  void fromStatusString(String status) {
    super.fromStatusString(status);
    
  }
}
