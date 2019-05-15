
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

String[] ips = config.ips;
int robotNR = config.ips.length;

int[] dir = new int[robotNR];

int demultiplicator = 1;
int razaDeOcolit = 50;
int rotireInLocStop = 0;
int rotireInLocClockwise = 0;
int rotireInLocAntiClockwise = 0;

String[] data =new String[robotNR];

int[][] puncte= {{-102,753}, {-445,913}, {30,30}, {40,30}, {30,20}};

public Client[] cPort23 = new Client[robotNR];
public Client[] cPort24 = new Client[robotNR];


//int img[]={0x00,0x00,0x00,0x00,0x00,0x00.....etc};

int x[] = {100,120,180,200};
int y[] = {100,120,180,200};
int xg[] = {200,180,120,100};
int yg[] = {200,180,120,100};


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
    
    float deltaX = ((float)x[i] - (float)instance.getAgentPosition(i).getX());
    float deltaY = ((float)y[i] - (float)instance.getAgentPosition(i).getY());
    
    instance.setAgentPosition(i, new Vector2D(x[i], y[i]));
    instance.setAgentRadius(i, razaDeOcolit);
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

    rect(puncte[i][0]/config.getZoom() + config.getTranslateX(),
         puncte[i][1]/config.getZoom() + config.getTranslateY(),
         30,
         30);
   
    
    /*    
    text("robot: " + (float)((dir[i])), 10, 30);
    text("spre_: " + (spre), 10, 50); 
    text("dist_: " + dist(x[i],y[i],puncte[i][0],puncte[i][1]), 10, 70); 
    text("x_: " + (x[i]), 10, 90); 
    text("y_: " + (y[i]), 10, 110);   
    text("diff_: " + ((360 - (float)(spre-dir[i]))%360), 10, 130); 
    */

    if (!esc) {
      
      float xx = ((360 - (float)(spre - dir[i])) % 360);
      
      if (dist(x[i],y[i],puncte[i][0],puncte[i][1]) < 150) {
        demultiplicator = 2;
      } else {
        demultiplicator = 1;
      }
      
      int motor = 200 + 800 * (abs(180 - (int)xx)) / 180 / demultiplicator;
                  
      if (dist(x[i],y[i],puncte[i][0],puncte[i][1]) < 50) {
           cPort24[i].write("iw 0 15 0\r\n");
           cPort24[i].write("iw 0 12 0\r\n");     
      } else if (((360- (float)(spre-dir[i]))%360) < 180) {
       cPort24[i].write("iw 0 15 " + motor + "\r\n");
       cPort24[i].write("iw 0 12 1000\r\n");
     } else {
       cPort24[i].write("iw 0 15 1000\r\n");
       cPort24[i].write("iw 0 12 " + motor + "\r\n");
     }
   }
  
  drawRobot(i);
   
  }
  
}

void draw0x0(){
         // (0, 0)
    translate(config.getTranslateX(),
              config.getTranslateY()
              );       
    line(-5,0,5,0);
    line(0,-5,0,5);
    resetMatrix();
}

void drawRobot(int i) {
  translate(x[i]/config.getZoom() + config.getTranslateX(),
            y[i]/config.getZoom() + config.getTranslateY()
            );
  text((x[i])+ "," + y[i], -10, 20); 
  rotate(radians(dir[i]+180));
  line(0,-10,0,10);
  line(0,10,-5,0);
  line(0,10,5,0);
  ellipse(0,0,razaDeOcolit,razaDeOcolit);
  resetMatrix();
}

void rotitInLoc(int indexRobot, int sens) {
  if (sens == 1) {
    cPort24[indexRobot].write("iw 0 15 0\r\n");
    cPort24[indexRobot].write("iw 0 14 0\r\n");
    delay(100);
    cPort24[indexRobot].write("iw 0 12 1000\r\n");
    cPort24[indexRobot].write("iw 0 5 1000\r\n");
  }
  if (sens == 2)
  {
    cPort24[indexRobot].write("iw 0 12 0\r\n");
    cPort24[indexRobot].write("iw 0 5 0\r\n");
    delay(100);
    cPort24[indexRobot].write("iw 0 15 1000\r\n");
    cPort24[indexRobot].write("iw 0 14 1000\r\n");
  }
  
  if (sens == 3)
  {
    cPort24[indexRobot].write("iw 0 12 0\r\n");
    cPort24[indexRobot].write("iw 0 5 0\r\n");
    delay(100);
    cPort24[indexRobot].write("iw 0 15 0\r\n");
    cPort24[indexRobot].write("iw 0 14 0\r\n");
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
        //println(lines[i].substring(1));
        try{
        y[indexRobot] = Integer.valueOf(data[indexRobot].substring(1));
            }
        catch (NumberFormatException e) {        
          println("err y");
        }

      }


      if (data[indexRobot].indexOf("O") == 0) {
        try {
        dir[indexRobot] = Integer.valueOf(data[indexRobot].substring(1));
        dir[indexRobot] = dir[indexRobot] +60;
        dir[indexRobot] = (dir[indexRobot] / 6 +180) % 360;
        }
        catch (NumberFormatException e) {        
          println("err o");
        }

      }
  } 
  }

}


void stop() {
  for (int i = 0;i < robotNR;i++)
  {
    cPort23[i].stop(); //c
    cPort24[i].stop(); //c1
  }
} 


void processRotitInLoc() {
    if (rotireInLocClockwise == 1) {
     rotireInLocClockwise = 0;
     rotitInLoc(2,1);
  }
   
  if (rotireInLocAntiClockwise == 1) {
     rotireInLocAntiClockwise = 0;
     rotitInLoc(2,2);
  }

  if (rotireInLocStop == 1) {
     rotireInLocStop = 0;
     rotitInLoc(2,3);
  }

}


void keyPressed() {
  
  if (key=='q' || key == 'Q') {
    println("ESC!!");
    esc = !esc;
    for (int i=0;i<robotNR;i++)
    {
      cPort24[i].write("iw 0 15 0\r\n");
      cPort24[i].write("iw 0 12 0\r\n");
    }
  }
  
  
  if (key=='w' || key == 'W') { //exit!
    for (int i=0;i<robotNR;i++)
    {
      cPort24[i].write("iw 0 15 0\r\n");
      cPort24[i].write("iw 0 12 0\r\n");
    }
  }
  
    
    if (key=='r' || key == 'R') {
      println("RANDOM!!");
      for (int i=0;i<robotNR;i++)
      {
        puncte[i][0]=(int)random(1000)-500;
        puncte[i][1]=200 + (int)random(600);        
        blocks.updateGoal(i,puncte[i][0], puncte[i][1]);
      }
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
