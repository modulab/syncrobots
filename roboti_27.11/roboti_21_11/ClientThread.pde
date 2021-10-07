import java.util.Iterator;

class ClientThread extends Thread {
  int clientIndex;
  PApplet app;

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

      robot[clientIndex].init(ips[clientIndex], clientIndex);
      println("Init robot index: " + clientIndex);
      /*
      delay(125);
      cPort24[clientIndex].write("iw 0 0 0\r\n");
      delay(125);
      cPort24[clientIndex].write("iw 0 0 1\r\n");
      delay(125);
      cPort24[clientIndex].write("iw 0 0 0\r\n");
      delay(125);
      cPort24[clientIndex].write("iw 0 0 1\r\n");
      */
      cf.UpdateButton(clientIndex, color(0, 200, 0));
    }

  delay(190);
    boolean readyToSend = true;
    while (true) {

      
      while (!robot[clientIndex].toSend.isEmpty()) {
         String command = robot[clientIndex].toSend.poll();
         if (command.charAt(0) == 's') {
           readyToSend = true;
           continue;
         }

         if (command.charAt(0) == 'g') {
           robot[clientIndex].toSend.clear();
           readyToSend = false;           
           continue;
         }

         
         if (readyToSend) {
           //println(command);
           
          if (cPort24[clientIndex].active())   
           cPort24[clientIndex].write(command);
  

           delay(10);
         }
         
         
         
      }
        delay(10);
      
    }
  }
}
