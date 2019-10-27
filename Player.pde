class Player extends Actor {
  
  Player(PVector pos_) {
    super(pos_);
  }
  
  void show() {
    fill(#2270ff);
    circle(pos.x, pos.y, 2*RADIUS);
  }
}
