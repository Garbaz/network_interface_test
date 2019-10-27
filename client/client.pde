import processing.net.*;

Client client;

String id;

void setup() {
  client = new Client(this, "127.0.0.1", 1729);


  id = hex(int(random(1<<31)));
}

int i = 0;

void draw() {
  i++;
}

void clientEvent(Client c) {
  String s = c.readString();
  println("CLIENT: "+s);
  if (s.equals("update!")) {
    println("CLIENT: Sending update!");
    client.write(id + "\n" + i);
  }
}
