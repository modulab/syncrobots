
import java.awt.*;
import controlP5.*;
import org.apache.commons.math3.geometry.euclidean.twod.Vector2D;

import java.util.ArrayList;
import java.util.List;
import processing.net.*;
import java.net.*;

ControlFrame cf;

final Blocks blocks = new Blocks();
RVOMath RVOMath = new RVOMath();

boolean esc = true;
Config config = new Config();
Leds leds = new Leds();

String[] ips = config.ips;
int robotNR = config.ips.length;

int[] dir = new int[robotNR];

float demultiplicator = 1;
float demultiplicatorMotor = 1;

int razaDeOcolit = 120;
int rotireInLocStop = 0;
int rotireInLocClockwise = 0;
int rotireInLocAntiClockwise = 0;

int[] lastClientMotorCommand = {0,0,0,0,0};

int motorSpeed = 1000;

String[] data =new String[robotNR];


//[stage][x][y]
int[][][] puncte = {
    //{{458,1526},{400,1437},{272,1272},{229,1163},{343,1349}},
    {{274,2162},{236,1907},{189,1626},{119,1073},{160,1364}},
    {{517,1675},{-108,2081},{0,1549},{121,1116},{-520,1374}},
    {{271,1802},{-31,1906},{-119,1622},{-76,1226},{583,1629}}
    };

boolean[] stageComplete = {false,false,false,false,false};

String[] culori = {"0xff0000", "0xffff00","0xff00ff","0x0000ff"};

int stage = 0;

public Client[] cPort23 = new Client[robotNR];
public Client[] cPort24 = new Client[robotNR];

int x[] = {100,120,180,200,0};
int y[] = {100,120,180,200,0};
int xg[] = {200,180,120,100,0};
int yg[] = {200,180,120,100,0};


final Simulator instance = new Simulator();
 
void settings() {
  size(1000, 800, P2D);
}

 
void setup() {
  
  cf = new ControlFrame(this, 400, 800, "Controls", config);
  delay(1000); // de reviziut  ii ia ceva lu controlp5 sa se activeze
  blocks.setupScenario();
  //blocks.setPreferredVelocities();
  
  for (int i = 0; i < robotNR; i++)
  {
    x[i] = y[i] = dir[i] = 0;
    new ClientThread(i, this).start();
    println("Init robot " + ips[i]);
  }
  
  println("Setup completed!");
  strokeWeight(2);
}


void draw() {
  //println(stage);
  background(255);
  textSize(10);
  noFill();

  blocks.updateVisualization();
  blocks.setPreferredVelocities();  
  instance.doStep();

  draw0x0();   
  processRotitInLoc();
   
  for (int i=0; i<robotNR; i++)
  {
    
       //predictie
       rect((float)instance.getAgentPosition(i).getX() / config.getZoom() + config.getTranslateX() - 2,
         (float)instance.getAgentPosition(i).getY() / config.getZoom() + config.getTranslateY() - 2,
         4,
         4);
   //end predictie
    
    float deltaX = ((float)x[i] - (float)instance.getAgentPosition(i).getX());
    float deltaY = ((float)y[i] - (float)instance.getAgentPosition(i).getY());
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

    rect(puncte[stage][i][0] / config.getZoom() + config.getTranslateX() - 10,
         puncte[stage][i][1] / config.getZoom() + config.getTranslateY() - 10,
         20,
         20);
   

   
    if (!esc) {
      
      float xx = ((360 - (float)(spre - dir[i])) % 360);
      
      if (dist(x[i],y[i],puncte[stage][i][0],puncte[stage][i][1]) < 200) {
        demultiplicator = 4;
      } else {
        demultiplicator = demultiplicatorMotor;
      }
      
      if (abs(xx) > 90) {
        demultiplicator *= 4;
      }
      
      
      //int motor = 200 + (motorSpeed-200) * (int)sqrt(abs(180*180 - (int)(xx * xx))) / 180 / demultiplicator;
      int motor = 300 + (int)((motorSpeed-300) * (int)abs(180 - (int)xx) / 180 / demultiplicator);
      if (dist(x[i],y[i],puncte[stage][i][0],puncte[stage][i][1]) < 50 && dist(x[i],y[i],(float)instance.getAgentPosition(i).getX(),(float)instance.getAgentPosition(i).getY())<50) {
        if (cPort24[i].active()) {
          if (lastClientMotorCommand[i] != 0) {
           cPort24[i].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
           delay(10);
           cPort24[i].write("iw 0 " + config.motorRightFwd + " 0\r\n");
          }
           lastClientMotorCommand[i] = 0;
        }
            stageComplete[i] = true;
           
           //schimba goalul cu pozitia curenta
           //puncte[stage][i][0] = x[i];
           //puncte[stage][i][0] = x[i];
           updateGoal();
           //end schimba goalul cu pozitia curenta
           
           if (isStageComplete()) {
               if (stage<puncte.length-1) stage++;
               else stage = 0;
               delay(2000);
               updateGoal();
           }
           //delay(10);
           //leds.TurnOnHalf1(cPort24[i], culori[stage]);
           //leds.TurnOnHalf2(cPort24[i], culori[stage]);
           //delay(10);
      } else if (((360- (float)(spre-dir[i]))%360) < 180) {
        if (cPort24[i].active()) {
             cPort24[i].write("iw 0 " + config.motorLeftFwd + " " + motor + "\r\n");
             if (lastClientMotorCommand[i] != 1) {
               delay(10);
               cPort24[i].write("iw 0 " + config.motorRightFwd + " " + motorSpeed + "\r\n");
             }
           lastClientMotorCommand[i] = 1;
        }
     } else {
       if (cPort24[i].active()) {
          if (lastClientMotorCommand[i] != 2) {
             cPort24[i].write("iw 0 " + config.motorLeftFwd + " " + motorSpeed + "\r\n");
             delay(10);
          }
             cPort24[i].write("iw 0 " + config.motorRightFwd + " " + motor + "\r\n");
             lastClientMotorCommand[i] = 2;
       }
     }
   }
   
  instance.setAgentPosition(i, new Vector2D(x[i], y[i]));
  instance.setAgentRadius(i, razaDeOcolit);

  drawRobot(i);
   
  }
  
}


boolean isStageComplete() {
  for (int i=0; i<robotNR; i++) {
    if (stageComplete[i] == false) return false;
  }
  
  for (int i=1; i < robotNR; i++) {
    stageComplete[i] = false;
  }
  return true;
}


/* 
** Draws a cross in (0,0)
*/
void draw0x0(){
    translate(config.getTranslateX(),
              config.getTranslateY()
              );       
    line(-5,0,5,0);
    line(0,-5,0,5);
    resetMatrix();
}


/* 
** Main method to draw a robot
*/
void drawRobot(int i) {

 stroke(230);
 line(x[i]/config.getZoom() + config.getTranslateX(),
     y[i]/config.getZoom() + config.getTranslateY(),
     puncte[stage][i][0]/config.getZoom() + config.getTranslateX(),
     puncte[stage][i][1]/config.getZoom() + config.getTranslateY());
 stroke(0);

  
  translate(x[i]/config.getZoom() + config.getTranslateX(),
            y[i]/config.getZoom() + config.getTranslateY()
            );
  fill(0);
  text((x[i])+ "," + y[i], -10, 20);
  text((ips[i]), -10, 0);
  noFill();
  
  rotate(radians(dir[i]+180));
  line(0,-10,0,10);
  line(0,10,-5,0);
  line(0,10,5,0);
  ellipse(0,0,razaDeOcolit/config.getZoom(),razaDeOcolit/config.getZoom());
  resetMatrix();
 
}



/* 
** Rotates a robot by its center
*/
void rotitInLoc(int indexRobot, int sens) {
  
    if (!cPort24[indexRobot].active()) {
      return;
    }
    if (sens == 1) {
      cPort24[indexRobot].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorRightRev + " 0\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorRightFwd + " 700\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorLeftRev + " 700\r\n");
    }
    if (sens == 2)
    {
      cPort24[indexRobot].write("iw 0 " + config.motorRightFwd + " 0\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorLeftRev + " 0\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorLeftFwd + " 700\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorRightRev + " 700\r\n");
    }
    
    if (sens == 3)
    {
      cPort24[indexRobot].write("iw 0 " + config.motorRightFwd + " 0\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorRightRev + " 0\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
      delay(10);
      cPort24[indexRobot].write("iw 0 " + config.motorLeftRev + " 0\r\n");
    }

}

void processRotitInLoc() {
    if (rotireInLocClockwise == 1) {
     rotireInLocClockwise = 0;
     for (int i=0; i< robotNR; i++)
       rotitInLoc(i,1);
  }
   
  if (rotireInLocAntiClockwise == 1) {
     rotireInLocAntiClockwise = 0;
     for (int i=0; i< robotNR; i++)
       rotitInLoc(i,2);
  }

  if (rotireInLocStop == 1) {
     rotireInLocStop = 0;
     for (int i=0; i< robotNR; i++)
       rotitInLoc(i,3);
  }

}


void clientEvent(Client someClient) {
  
  int indexRobot = -1;
  
  for (int i=0;i<robotNR; i++)
  {
    if (someClient == cPort23[i]) {
      indexRobot = i;
    }
  }
  
  if (indexRobot > -1) {
    
    while (someClient.available() > 35) {
    
       data[indexRobot] = someClient.readStringUntil(10);   
       data[indexRobot] = data[indexRobot].replaceAll("\\n", "");
       data[indexRobot] = data[indexRobot].replaceAll("\\r", "");
       
       if (data[indexRobot].indexOf("X") == 0) {
            
          try{
            x[indexRobot] = Integer.valueOf(data[indexRobot].substring(1))*(-1);
          }
          catch (NumberFormatException e) {   
            println("err x");
          }
        }
        
        
        if (data[indexRobot].indexOf("Y") == 0) {
          try {
            y[indexRobot] = Integer.valueOf(data[indexRobot].substring(1));
          }
          catch (NumberFormatException e) {        
            println("err y");
          }
        }
  
  
        if (data[indexRobot].indexOf("O") == 0) {
          try {
            dir[indexRobot] = Integer.valueOf(data[indexRobot].substring(1));
            //dir[indexRobot] = dir[indexRobot] + 40;
            //dir[indexRobot] = (dir[indexRobot] / 6 +180) % 360;
            //2260/360 grade = 6.27
            dir[indexRobot] = (int)(dir[indexRobot] / 6.27 +180) % 360;
            
          }
          catch (NumberFormatException e) {        
            println("err o");
          }
  
        }
    } 
  }

}


void updateGoal() {
    for (int i = 0;i < robotNR;i++)
      {
        blocks.updateGoal(i,puncte[stage][i][0], puncte[stage][i][1]);
      }
}


void stop() {
  for (int i = 0;i < robotNR;i++)
  {
    cPort23[i].stop();
    cPort24[i].stop();
  }
} 


void keyPressed() {
  
  if (key=='q' || key == 'Q') {
    println("ESC!!");
    esc = !esc;
    for (int i=0;i<robotNR;i++)
    {
      if (cPort24[i].active()) {
        cPort24[i].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
        cPort24[i].write("iw 0 " + config.motorRightFwd + " 0\r\n");
      }
    }
  }
  
  
  if (key=='w' || key == 'W') { //exit!
    for (int i=0;i<robotNR;i++)
    {
      cPort24[i].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
      cPort24[i].write("iw 0 " + config.motorRightFwd + " 0\r\n");
      delay(10);
      leds.TurnOffHalf1(cPort24[i]);
      leds.TurnOffHalf2(cPort24[i]);
    }
  }
  
    
    if (key=='r' || key == 'R') {
      println("RANDOM!!");
      for (int i=0;i<robotNR;i++)
      {
        puncte[0][i][0]=(int)random(1000)-500;
        puncte[0][i][1]=200 + (int)random(600);        
        blocks.updateGoal(i,puncte[0][i][0], puncte[0][i][1]);
      }
  }
   
    if (key=='p' || key == 'P') {
      print("{");
      for (int i=0;i<robotNR;i++)
      {
        print("{" + x[i] + "," + y[i] + "},");
      }
      println("},");
  }
   
       if (key=='n' || key == 'N') {
         if (stage<puncte.length-1) { stage++; }
         else {stage = 0;}
         updateGoal();
  }
   
   
}

void disconnectEvent(Client someClient) {
  print("Server Says:  ");
}


void mouseDragged()
{
    config.setTranslateX(config.getTranslateX() + mouseX - pmouseX);
    config.setTranslateY(config.getTranslateY() + mouseY - pmouseY);  
    cf.UpdateXYZ(config.getTranslateX(), config.getTranslateY(), config.getZoom());
}


void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    config.setZoom(config.getZoom() + e);
    cf.UpdateXYZ(config.getTranslateX(), config.getTranslateY(), config.getZoom());
}
