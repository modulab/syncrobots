class ClientThread extends Thread {
   int clientIndex;
   PApplet app;
   public ClientThread(int index, PApplet app){
      this.clientIndex = index;
      this.app = app;
   }
  
  public void run() {

     cPort23[clientIndex] = new Client(app, ips[clientIndex], 23);
     cPort24[clientIndex] = new Client(app, ips[clientIndex], 24);
     if (cPort23[clientIndex].active() == false || cPort23[clientIndex].active() == false) {
       cf.UpdateButton(clientIndex, color(255,0,0));
       println("UPS eroare (port23) index: " + clientIndex);       
     } else {
       cf.UpdateButton(clientIndex, color(0,255,0));
       println("Init robot index: " + clientIndex);
     }
     
  }
}
