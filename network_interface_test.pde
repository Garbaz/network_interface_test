import processing.net.*;

final int PLAYER_RADIUS = 32;
final float PLAYER_SPEED = 200;

final int PROP_RADIUS = 64;

ArrayList<Drawable> drawables = new ArrayList<Drawable>();
ArrayList<Prop> props = new ArrayList<Prop>();

Player player;

HashMap<String, NetworkObject> network_objects;

PVector spawn_point = new PVector(100, 100);

final PVector UNKNOWN_POSITION = new PVector(1<<20, 1<<20);

final String NETWORK_IP = "192.168.2.101";
final int NETWORK_PORT = 1729;
final int UPDATE_INTERVALL = 62;
final int CLEANUP_INTERVALL = 1000;
final int MAX_CLIENT_PING = 1000;

Server server;
Client client;

//StringDict client_status;
IntDict network_players_last_update;

int network_last_update = 0;
int network_last_cleanup = 0;

String network_id;



void settings() {
  size(1000, 1000, P2D);
}

void setup() {
  frameRate(300);

  debug_init();

  textAlign(LEFT, TOP);

  player = new Player(spawn_point);
  drawables.add(player);

  network_id = str(int(random(1, 1<<20)));
  network_objects = new HashMap<String, NetworkObject>();
  network_players_last_update = new IntDict();
}


void draw() {
  float dt = deltatime();

  background(#44aa44);

  debug_begin_draw();

  player.update(dt);
  
  for(NetworkObject p : network_objects.values()) {
    if(p instanceof Actor) ((Actor)p).update(dt);
  }

/*
  pushStyle();
  strokeWeight(3);
  strokeCap(SQUARE);
  line(spawn_point.x, spawn_point.y, spawn_point.x, spawn_point.y - 50);
  rectMode(CORNERS);
  strokeWeight(1);
  fill(#cccccc);
  rect(spawn_point.x+1, spawn_point.y-25, spawn_point.x+40, spawn_point.y-50);
  popStyle();
*/

  for (Drawable d : drawables) {
    d.show();
  }


  if (server != null) {
    if (server.active()) {
      serverRoutine();
    } else {
      server = null;
    }
  }

  if (client != null) {
    if (!client.active()) {
      client = null;
    }
  }

  debug_end_draw();
}

void mousePressed() {
  /*
  if (mouseButton == LEFT) {
    addProp(new Barrel(new PVector(mouseX, mouseY), PROP_RADIUS));
  } else if (mouseButton == RIGHT) {
    addProp(new Box(new PVector(mouseX, mouseY), PROP_RADIUS));
  } else if (mouseButton == CENTER) {
    PVector mousePos = new PVector(mouseX, mouseY);
    ArrayList<Prop> toBeRemoved = new ArrayList<Prop>(); 
    for (Prop p : props) {
      if (p.collisionShape.shape == Shape.CIRCLE) {
        if (mousePos.dist(p.pos) < p.collisionShape.radius) {
          toBeRemoved.add(p);
        }
      } else if (p.collisionShape.shape == Shape.SQUARE) {
        if (abs(mousePos.x - p.pos.x) <= p.collisionShape.radius && abs(mousePos.y - p.pos.y) <= p.collisionShape.radius) {
          toBeRemoved.add(p);
        }
      }
    }
    removeAllProps(toBeRemoved);
  }
  */
}

boolean key_left  = false;
boolean key_right = false;
boolean key_up    = false;
boolean key_down  = false;

void keyPressed() {
  if (keyCode == LEFT || key == 'a') {
    key_left = true;
  } else if (keyCode == RIGHT || key == 'd') {
    key_right = true;
  } else if (keyCode == UP || key == 'w') {
    key_up = true;
  } else if (keyCode == DOWN || key == 's') {
    key_down = true;
  } else if (key == 'h') {
    if (server == null && client == null) {
      initServer();
    }
  } else if (key =='j') {
    if (server == null && client == null) {
      initClient();
    }
  }


  update_player_vel();
}

void keyReleased() {
  if (keyCode == LEFT || key == 'a') {
    key_left = false;
  } else if (keyCode == RIGHT || key == 'd') {
    key_right = false;
  } else if (keyCode == UP || key == 'w') {
    key_up = false;
  } else if (keyCode == DOWN || key == 's') {
    key_down = false;
  }

  update_player_vel();
}

void addProp(Prop p) {
  props.add(p);
  drawables.add(p);
}

void removeProp(Prop p) {
  drawables.remove(p);
  props.remove(p);
}

void addPlayer(String id, Player p) {
  network_objects.put(id, p);
  drawables.add(p);
}

void removePlayer(String id) {
  drawables.remove(network_objects.get(id));
  network_objects.remove(id);
}

void removeAllProps(java.util.Collection c) {
  if (!c.isEmpty()) {
    props.removeAll(c);
    drawables.removeAll(c);
  }
}

void update_player_vel() {
  player.vel.x = (int(key_right)-int(key_left));
  player.vel.y = (int(key_down)-int(key_up));
  player.vel.setMag(PLAYER_SPEED);
}


int lastTime = 0;
float deltatime() {
  int deltaTime = millis() - lastTime;
  lastTime += deltaTime;
  return deltaTime/1000.0;
}


void clientEvent(Client c) {
  if(client != null) clientRecieve(c);
}




// ~~~~~~~~~~~~ OLD CODE ~~~~~~~~~~~~~


//PVector norm = PVector.sub(barrel_pos, player_pos); 
//norm.normalize();
//PVector tang = new PVector(-norm.y, norm.x); 
//tang.normalize();


//  PVector player_vel_deflected;

//  if (player_pos.dist(barrel_pos) <= PLAYER_RADIUS + BARREL_RADIUS) {
//    PVector player_vel_nt_base = vector_toBasis(player_dir, norm, tang);
//    if (player_vel_nt_base.x > 0) player_vel_nt_base.x = 0;
//    player_vel_deflected = vector_fromBasis(player_vel_nt_base, norm, tang);
//  } else {
//    player_vel_deflected = player_dir;
//  }

//  player_pos.add(PLAYER_SPEED * player_vel_deflected.x * dt, PLAYER_SPEED * player_vel_deflected.y * dt);
