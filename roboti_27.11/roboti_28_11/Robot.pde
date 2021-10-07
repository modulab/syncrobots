import java.util.concurrent.*; 
class Robot {

  public int x, y, dir;
  public int goalX, goalY;
  public boolean goalReached = false;
  String ip="";
  int direction = 0;
  private Motor engine = new Motor();
  int histeresys = 0;
  boolean isLeader = false;
  int idRobot;
  boolean readyToSend = true;
  
  //ArrayList<String> toSend;
  ConcurrentLinkedQueue<String> toSend;


  public void init( String _ip, int id) {
    x = 0;
    y = 0;
    dir = 0;
    ip = _ip;
    idRobot = id;
    engine.init();
    toSend = new ConcurrentLinkedQueue<String>();
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

    if (deltaX < 0 && deltaY < 0) {
      spre = 180 + (degrees(atan(deltaX/deltaY)));
    } else if (deltaX>0 && deltaY<0) {
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


    if (unghiReal > 100 && !isLeader) {
      direction = 1;
    } else {
      direction = 0;
    }


if (unghiReal > 160) direction = 2; 


    if (rotireInLocClockwise) {
      direction = 3;
      //println(dir);
      if (dir > 20 ) {
        engine.start(idRobot,0, 0, direction);
      } else {
        engine.stop(idRobot);
      }
      return;
    }





int newMotorSpeed = motorSpeed;
    int distantaSafe = 40;
    for (int k = 0; k < robotNR; k++) {
      //println(dist(x, y, robot[k].x, robot[k].y));
      if (dist(x, y, robot[k].x, robot[k].y) < razaDeOcolit && k != idRobot) {
        distantaSafe = 20;
      }
    }

    if (distantaSafe == 40) {          
          if (dist(x, y, goalX, goalY) < 150) {
            newMotorSpeed /=2/1.7;
          }
    }

    if (dist(x, y, goalX, goalY) < 100 && unghiReal > 90) {
      newMotorSpeed = motorSpeed;
      newMotorSpeed /=4;
    }



    float coeficient = abs(90 - unghiReal) / 90;  //e intre 0 si 1
    coeficient = coeficient*coeficient*coeficient*coeficient*coeficient;
    int motor = 500 + (int)((newMotorSpeed - 500 + fineTuneMotors) * coeficient);

    if (swarmMode) {

      if (dist(x, y, goalX, goalY) < 200) {
          engine.stop(idRobot);
      }
    } 
  
    //println(dist(x, y, goalX, goalY) + "   " + dist(x, y, (float)newX, (float)newY));
//println(dist(x, y, goalX, goalY)+ " " + dist(x, y, (float)newX, (float)newY));
   // if (dist(x, y, goalX, goalY) < 30 && dist(x, y, (float)newX, (float)newY) > distantaSafe && !swarmMode) {
      if (dist(x, y, goalX, goalY) < 30 && dist(x, y, (float)newX, (float)newY) < distantaSafe) {
       
      engine.stop(idRobot);
      goalReached = true;
    } else if (((360 - (float)(spre - dir)) % 360) < 180) {  // corect !
        engine.start(idRobot,motor, newMotorSpeed, direction);
      goalReached = false;
    } else {
       
        engine.start(idRobot,newMotorSpeed, motor, direction);
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
    line(0, -10, 0, 10);
    line(0, 10, -5, 0);
    line(0, 10, 5, 0);

    stroke(240);
    ellipse(0, 0, razaDeOcolit/config.getZoom(), razaDeOcolit/config.getZoom());
    stroke(0);
    ellipse(0, 0, razaRobot/config.getZoom(), razaRobot/config.getZoom());

    resetMatrix();
  }

  void stop() {
    engine.stop(idRobot);
  }

  void sendReset() {
    if (cPort24 != null) {
      //cPort24.write("iw 0 0 0\r\n");
      delay(25);
      //cPort24.write("iw 0 0 1\r\n");
    }
  }
}
