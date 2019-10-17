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

float demultiplicator = 1;
float demultiplicatorMotor = 1;

int razaDeOcolit = 80;
int motorSpeed = 870;

int robotSelected = -1;

String[] data =new String[robotNR];

//[stage][x][y]
int[][][] puncte = {
    {{741,1221},{841,945},{-667,1221},{-530,2258},{976,2024}},
    {{741,1221},{-667,1221},{-530,2258},{976,2024},{841,945}},
    {{741,1221},{-530,2258},{976,2024},{841,945},{-667,1221}},
    {{741,1221},{976,2024},{841,945},{-667,1221},{-530,2258}}
    };

boolean staging = false;
boolean[] stageComplete = {false,false,false,false,false};

String[] culori = {"0xff0000", "0xffff00","0xff00ff","0x0000ff"};

int stage = 0;

public Client[] cPort23 = new Client[robotNR];
public Client[] cPort24 = new Client[robotNR];
public Robot[] robot = new Robot[robotNR];

final Simulator instance = new Simulator();
 
void settings() {
  size(1000, 800, P2D);
}

 
void setup() {
  
  cf = new ControlFrame(this, 400, 800, "Controls", config);
  delay(1000); // de reviziut  ii ia ceva lu controlp5 sa se activeze
  
    for (int i = 0; i < robotNR; i++)
  {
    new ClientThread(i, this).start();
    println("Init client " + ips[i]);
  }
 
    for (int i = 0; i < robotNR; i++)
  {
    robot[i] = new Robot();
    println("Init robot " + i);
  }

  blocks.setupScenario();
  updateGoal();  
  //blocks.setPreferredVelocities();

  
  println("Setup completed!");
  drawLimits();
  strokeWeight(2);
}


void draw() {
  //println(stage);
  background(255);
  textSize(10);
  noFill();
  draw0x0();
  
  blocks.updateVisualization();
  blocks.setPreferredVelocities();  
  instance.doStep();
   
  for (int i=0; i<robotNR; i++)
  {
    
      if (!esc) {
        
          if (isStageComplete() && staging) {
             if (stage < puncte.length - 1) stage++;
             else stage = 0;
             updateGoal();
             for (int j=0;j<robotNR;j++) {
               leds.TurnOnHalf1(cPort24[j],culori[stage]);
               leds.TurnOnHalf2(cPort24[j],culori[stage]);
             }
          }
          
          robot[i].update(instance.getAgentPosition(i).getX(), instance.getAgentPosition(i).getY());
          instance.setAgentPosition(i, new Vector2D(robot[i].x, robot[i].y));
          instance.setAgentRadius(i, razaDeOcolit);
      } else {
        robot[i].stop();
      }
      robot[i].drawRobot();
      
  }
  
}


boolean isStageComplete() {
  for (int i=0; i<robotNR; i++) {
    if (robot[i].goalReached == false) return false;
  }
  
  for (int i=1; i < robotNR; i++) {
    robot[i].goalReached = false;
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

void drawLimits() {
  println("!!!!Sa nu uiti sa desenezi si sa setezi limitele!!!!!!");
  //documentatia e in Simulation.pde
}

void clientEvent(Client someClient) {
  
  int indexRobot = -1;

  for (int i = 0;i < robotNR; i++)
  {
    if (someClient == cPort24[i]) {
      indexRobot = i;
    }
  }

  if (indexRobot > -1 && someClient == cPort24[indexRobot]) {
    if (someClient.available() > 0) {
       if (someClient.readChar() == 'p') {
         someClient.clear();
         robot[indexRobot].engine.sentSuccess = true;
       } else { return; }
    }
  }

  if (indexRobot != -1) return;

  
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
            robot[indexRobot].x = Integer.valueOf(data[indexRobot].substring(1))*(-1);
          }
          catch (NumberFormatException e) {   
            println("err x");
          }
        }
        
        
        if (data[indexRobot].indexOf("Y") == 0) {
          try {
            robot[indexRobot].y = Integer.valueOf(data[indexRobot].substring(1));
          }
          catch (NumberFormatException e) {        
            println("err y");
          }
        }
  
  
        if (data[indexRobot].indexOf("O") == 0) {
          try {
            int tmpDir = Integer.valueOf(data[indexRobot].substring(1));
            robot[indexRobot].dir = (int)(tmpDir / 6.27 +180) % 360;            
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
        robot[i].goalX = puncte[stage][i][0];
        robot[i].goalY = puncte[stage][i][1];
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
      
      if (cPort24[i] != null && cPort24[i].active()) {
        cPort24[i].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
        cPort24[i].write("iw 0 " + config.motorRightFwd + " 0\r\n");
      }
    }
  }
  
  
  if (key=='w' || key == 'W') { //exit!
    for (int i=0;i<robotNR;i++)
    {
      if (cPort24[i]!=null) {
        cPort24[i].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
        cPort24[i].write("iw 0 " + config.motorRightFwd + " 0\r\n");
        delay(10);
        leds.TurnOffHalf1(cPort24[i]);
        leds.TurnOffHalf2(cPort24[i]);
      }
    }
  }
  
    
    if (key=='r' || key == 'R') {
      println("RANDOM!!");
      for (int i=0;i<robotNR;i++)
      {
        puncte[0][i][0] = (int)random(1000)-500;
        puncte[0][i][1] = 200 + (int)random(600);        
        blocks.updateGoal(i, puncte[0][i][0], puncte[0][i][1]);
      }
  }
   
    if (key=='p' || key == 'P') {
      print("{");
      for (int i=0;i<robotNR;i++)
      {
        print("{" + robot[i].x + "," + robot[i].y + "},");
      }
      println("},");
    }
   
   
      if (key=='a' || key == 'A') {
         delay(10);
         cPort24[0].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorRightFwd + " 0\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorLeftRev + " 800\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorRightRev + " 800\r\n");
      }

         if (key=='s' || key == 'S') {
           delay(10);
         cPort24[0].write("iw 0 " + config.motorLeftRev + " 0\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorRightRev + " 0\r\n");
delay(10);
         cPort24[0].write("iw 0 " + config.motorLeftFwd + " 800\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorRightFwd + " 800\r\n");
      }

      if (key=='d' || key == 'D') {
        delay(10);
         cPort24[0].write("iw 0 " + config.motorLeftRev + " 0\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorRightRev + " 0\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorLeftFwd + " 0\r\n");
         delay(10);
         cPort24[0].write("iw 0 " + config.motorRightFwd + " 0\r\n");

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


void mouseClicked() {
  int _x = (int)((mouseX - config.getTranslateX())*config.getZoom());
  int _y = (int)((mouseY - config.getTranslateY())*config.getZoom());
  
  println(_x);

  
  boolean selected = false;
  for (int i=0;i<robotNR;i++) {
    if (_x > robot[i].x - 20 && _x  < robot[i].x +20)
      if (_y > robot[i].y -20  && _y < robot[i].y + 20)
      {
        println("Robot: " + i + " selected");
        robotSelected = i;
        selected = true;
      }
  }
  
  if (robotSelected>-1 && !selected) {
    println("pacapaca");
    puncte[stage][robotSelected][0] = _x;
    puncte[stage][robotSelected][1] = _y;
    updateGoal();
  }

  
}


void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    config.setZoom(config.getZoom() + e);
    cf.UpdateXYZ(config.getTranslateX(), config.getTranslateY(), config.getZoom());
}
