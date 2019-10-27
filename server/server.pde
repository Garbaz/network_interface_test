import processing.net.*;


final int UPDATE_INTERVALL = 62;
final int CLEANUP_INTERVALL = 1000; 


Server server;

StringDict client_status = new StringDict();
IntDict client_last_update = new IntDict();

void setup() {
  size(640, 320);
  frameRate(100);

  server = new Server(this, 1729);
}

int last_update = 0;
int last_cleanup = 0;

void draw() {
  background(0);

  int time = millis();
  if (time - last_update > UPDATE_INTERVALL) {
    last_update = time;
    server.write("update!");
  }

  if (time - last_cleanup > CLEANUP_INTERVALL) {
    last_cleanup = time;
    for (String id : client_last_update.keys()) {
      if (time-client_last_update.get(id) > CLEANUP_INTERVALL) {
        client_last_update.remove(id);
        client_status.remove(id);
      }
    }
  }

  Client client = server.available();
  if (client != null) {
    String str = client.readString();
    //println("SERVER: " + str);
    String[] sp = str.split("\n", 2);
    client_last_update.set(sp[0], time);
    client_status.set(sp[0], sp[1]);
  }


  textAlign(CENTER, CENTER);
  text(client_status.toString(), width/2, height/2 -20 );
  text(client_last_update.toString(), width/2, height/2 + 20);
}

void disconnectEvent(Client c) {
}
