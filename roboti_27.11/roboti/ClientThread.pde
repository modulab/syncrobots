import java.util.Iterator;

class ClientThread extends Thread {
  int clientIndex;
  PApplet app;
  public Boolean readyToSend;
  public ClientThread(int index, PApplet app) {
    this.clientIndex = index;
    this.app = app;
  }

  public void run() {

    cPort23[clientIndex] = new Client(app, ips[clientIndex], 23);
    cPort24[clientIndex] = new Client(app, ips[clientIndex], 24);
    if (cPort23[clientIndex].active() == false || cPort24[clientIndex].active() == false) {
      cf.UpdateButton(clientIndex, color(255, 0, 0));
      println("UPS eroare (port23) index: " + clientIndex);
      return;
    } else {

      robot[clientIndex].init(cPort24[clientIndex], ips[clientIndex], clientIndex);
      println("Init robot index: " + clientIndex);
      cPort24[clientIndex].write("iw 0 0 0\r\n");
      delay(15);
      cPort24[clientIndex].write("iw 0 0 1\r\n");
      cf.UpdateButton(clientIndex, color(0, 200, 0));
    }

  delay(190);

    while (true) {
      /*
      for (int i=0; i<robot[clientIndex].toSend.size(); i++) {
        println(clientIndex + " " + robot[clientIndex].toSend);
          //cPort24[clientIndex].write(robot[clientIndex].toSend.get(i));
         // println(clientIndex + " " + robot[clientIndex].toSend);
          
          robot[clientIndex].toSend.remove(i);
      }
      */

      while (!robot[clientIndex].toSend.isEmpty()) {
         String xxx = robot[clientIndex].toSend.poll();
         cPort24[clientIndex].write(xxx);
         robot[clientIndex].readyToSend = false;
      }
      
      /*
    for (Iterator<String> iterator = robot[clientIndex].toSend.iterator(); iterator.hasNext();) {
      String xxx = iterator.next();
        println(clientIndex + " " + xxx);
          cPort24[clientIndex].write(xxx);
         // println(clientIndex + " " + robot[clientIndex].toSend);
          
          iterator.remove();
      }
*/
      
      delay(10);
    }
  }
}
