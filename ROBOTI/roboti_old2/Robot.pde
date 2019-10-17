class Robot {
  
  public int x,y,dir;
  public int goalX, goalY;
  public boolean goalReached = false;
  String ip="";
  int direction = 0;
  Motor engine = new Motor();
  Client cPort24;
  int histeresys = 0;
  
  public void init(Client c, String _ip) {
    x = 0;
    y = 0;
    dir = 0;
    ip = _ip;
    cPort24 = c;
    engine.init(cPort24);
  }
  

  public void update(double newX, double newY) {
    //predictie
       rect((float)newX / config.getZoom() + config.getTranslateX() - 2,
         (float)newY / config.getZoom() + config.getTranslateY() - 2,
         4,
         4);
   //end predictie
    
    float deltaX = ((float)x - (float)newX);
    float deltaY = ((float)y - (float)newY);
    float spre = 0;
    
    if (deltaX<0 && deltaY<0) {
        spre = 180 + (degrees(atan(deltaX/deltaY)));
      } else if (deltaX>0 && deltaY<0){
        spre = 180 + (degrees(atan(deltaX/deltaY)));
      } else if (deltaX<0 && deltaY>0) {
        spre = (degrees(atan(deltaX/deltaY)));
      } else
        spre = (degrees(atan(deltaX/deltaY)));

      spre = (360-spre) % 360;
      float xx = ((360 - (float)(spre - dir)) % 360);
      

      float unghiReal = 0;
      float unghiTmp = abs(spre - dir); //cred ca xx
      if (unghiTmp > 180) {
        unghiReal = 360 - unghiTmp;
      } else {
        unghiReal = unghiTmp;
      }
      

      if (unghiReal > 110) {
        direction = 1;
      } else {
        direction = 0;
      }
      
      if (dist(x, y, goalX, goalY) < 150 && unghiReal > 30) {
        direction = 2;
      }
      
      int newMotorSpeed = motorSpeed;
      if (dist(x, y, goalX, goalY) < 100) {
        newMotorSpeed /=2/1.7;
      }
      
      float coeficient = abs(90 - unghiReal) / 90;  //e intre 0 si 1
      coeficient = coeficient*coeficient*coeficient;
      int motor = 450 + (int)((newMotorSpeed - 450) * coeficient);
      
      if (dist(x, y, goalX, goalY) < 30 && dist(x, y, (float)newX, (float)newY) < 40) {
          if (cPort24!=null && cPort24.active()) {
            engine.stop();
          }
          goalReached = true;
          
      } else if (((360 - (float)(spre - dir)) % 360) < 180) {  // corect !
        if (cPort24!=null && cPort24.active()) {
          engine.start(motor, newMotorSpeed, direction);
        }
        goalReached = false;
     } else {
        if (cPort24!=null && cPort24.active()) {
          engine.start(newMotorSpeed, motor, direction);
        }
        goalReached = false;
   }

  }


  void drawRobot() {
    resetMatrix();
     rect(goalX / config.getZoom() + config.getTranslateX() - 10,
         goalY / config.getZoom() + config.getTranslateY() - 10,
         20,
         20);
    
     stroke(230);
     line(x/config.getZoom() + config.getTranslateX(),
         y/config.getZoom() + config.getTranslateY(),
         goalX/config.getZoom() + config.getTranslateX(),
         goalY/config.getZoom() + config.getTranslateY());
     stroke(0);
    
      
      translate(x/config.getZoom() + config.getTranslateX(),
                y/config.getZoom() + config.getTranslateY()
                );
      fill(0);
      text(x+ "," + y, -10, 20);
      text((ip), -10, 0);
      noFill();
      
      rotate(radians(dir+180));
      line(0,-10,0,10);
      line(0,10,-5,0);
      line(0,10,5,0);
      ellipse(0,0,razaDeOcolit/config.getZoom(),razaDeOcolit/config.getZoom());
      resetMatrix();
  }
  
    void stop() {
      engine.stop();
    }
  
    void sendReset() {
       cPort24.write("iw 0 0 0\r\n");
       delay(15);
       cPort24.write("iw 0 0 1\r\n");
    }
  
}
