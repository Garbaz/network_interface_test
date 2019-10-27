
void initServer() {
  println("initServer");
  server = new Server(this, NETWORK_PORT);
}

void initClient() {
  println("initClient");
  client = new Client(this, NETWORK_IP, NETWORK_PORT);
}

void serverRoutine() {
  int time = millis();
  if (time - network_last_update > UPDATE_INTERVALL) {
    network_last_update = time;
    server.write("update!");
    server.write(network_id + "\n" + player.statusString());
  }

  network_player_cleanup();

  Client c = server.available();
  if (c != null) {
    String str = c.readString();
    handleStatus(str);
    server.write(str);
  }
}

void clientRoutine() {
  network_player_cleanup();
}

void clientRecieve(Client c) {
  String str = c.readString();
  if (str.equals("update!")) {
    client.write(network_id + "\n" + player.statusString());
  } else {
    handleStatus(str);
  }
}


void handleStatus(String str) {
  String[] sp = str.split("\n", 2);
  if (sp.length == 2) {
    String id = sp[0];
    String status = sp[1];
    
    //println("Status by Player@" + id + ":\n" + status);
    
    if (int(id) != 0 && !id.equals(network_id)) {
      network_players_last_update.set(id, millis());
      if (!network_players.containsKey(id)) {
        addPlayer(id, new Player(UNKNOWN_POSITION));
      }
      network_players.get(id).setFromStatusString(status);
      //println(network_players.get(id).statusString());
    }
  }
}

void network_player_cleanup() {
  int time = millis();
  if (time-network_last_cleanup > CLEANUP_INTERVALL) {
    network_last_cleanup = time;
    for (String id : network_players_last_update.keys()) {
      if (time-network_players_last_update.get(id) > CLEANUP_INTERVALL) {
        network_players_last_update.remove(id);
        network_players.remove(id);
      }
    }
  }
}
