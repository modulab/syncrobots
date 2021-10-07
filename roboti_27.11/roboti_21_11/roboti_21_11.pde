import java.awt.*;
import controlP5.*;
import org.apache.commons.math3.geometry.euclidean.twod.Vector2D;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

int fineTuneMotors = 0;

int razaRobot = 107;
int razaDeOcolit = 197;

int motorSpeed = 870;

int robotSelected = -1;

String[] data =new String[robotNR];

//[stage][x][y] {{200,2214},{875,1671},{1045,1967},{754,1487},{317,2045},{660,875},{74,1339},{633,1783},},
//{{457,1505},{80,2140},{1,1875},{333,1217},{-66,1619},{224,1516},{74,1340},{315,1739},},

//cu tasta N se trece la urmatoarea
// cu P se afiseaza snapshot de pozitie care urmeaza sa fie copiat aici
int[][][] puncte = {
//{{688,2102},{-70,2349},{-507,2515},{451,2163},{-678,1267},{-286,1146},{191,2239},{451,894},{-296,2434},{232,983},{-592,1253},{890,2020},{-41,1074},{688,2102},{-70,2349},{-507,2515},{451,2163},{-678,1267},{-286,1146},{191,2239},{451,894},{-296,2434},{232,983},{-592,1253},{890,2020},{-41,1074},},
//{{264,967},},
{{168,2361},{549,1710},{-229,2039},{-325,2387},{358,2272},{-20,1941},{730,2084},{-584,2338},{127,1862},{-138,2559},{415,1954},{333,1782},{524,2198},{-440,2218},{-297,2689},{626,1879},{-459,2523},{-4,2457},{235,2038},{77,2137},{-111,2240},},
{{627,2789},{949,1680},{-534,1668},{-67,2885},{993,2167},{-371,1407},{962,2409},{-581,2185},{88,1168},{225,2894},{344,1145},{624,1273},{862,2603},{-639,1943},{-346,2732},{1040,1912},{-507,2433},{409,2813},{760,1452},{-146,1297},{186,2060},},
{{709,2748},{949,1680},{-534,1668},{77,2922},{994,2167},{-370,1408},{962,2409},{-581,2185},{89,1168},{307,2912},{345,1145},{624,1273},{862,2602},{-639,1943},{-369,2684},{1040,1912},{-507,2432},{498,2825},{760,1452},{-146,1296},{-161,2808},},

};

boolean staging = true;
boolean swarmMode = false;
boolean rotireInLocClockwise = false;
boolean[] stageComplete = {false, false, false, false, false};

String[] culori = {"0xff0000", "0xffff00", "0xff00ff", "0x0000ff"};

int stage = 0;

public Client[] cPort23 = new Client[robotNR];
public Client[] cPort24 = new Client[robotNR];
public Robot[] robot = new Robot[robotNR];

final Simulator instance = new Simulator();

void settings() {
  size(1000, 800, P2D);
}


void setup() {

  println((byte)(255&0xff));

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
  text("fps: " + (int)frameRate, 10, 10);
  draw0x0();

  //blocks.updateVisualization();
  blocks.setPreferredVelocities();  
  instance.doStep();

  for (int i=0; i<robotNR; i++)
  {

    
      translate((float)instance.getAgentPosition(i).getX()/config.getZoom() + config.getTranslateX(), 
     (float)instance.getAgentPosition(i).getY()/config.getZoom() + config.getTranslateY()
     );
     ellipse(0,0,10,10);
     

    if (!esc) {


      if (swarmMode) {
        for (int j=0; j<robotNR; j++) {
          if (j != robotSelected) {
            puncte[stage][j][0] = robot[robotSelected].x;
            puncte[stage][j][1] = robot[robotSelected].y;
          }
        }
        updateGoal();
      }

      if (isStageComplete() && staging) {
        if (stage < puncte.length - 1) stage++;
        else stage = 0;
        updateGoal();
        for (int j=0; j<robotNR; j++) {
          leds.TurnOnHalf1(cPort24[j], culori[stage]);
          //leds.TurnOnHalf2(cPort24[j], culori[stage]);
        }
      }

      robot[i].update(instance.getAgentPosition(i).getX(), instance.getAgentPosition(i).getY());
      instance.setAgentPosition(i, new Vector2D(robot[i].x, robot[i].y));
      instance.setAgentRadius(i, razaRobot);
      instance.setAgentNeighborDistance(i, razaDeOcolit);
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
void draw0x0() {
  translate(config.getTranslateX(), 
    config.getTranslateY()
    );       
  line(-5, 0, 5, 0);
  line(0, -5, 0, 5);
  resetMatrix();
}

void drawLimits() {
  println("!!!!Sa nu uiti sa desenezi si sa setezi limitele!!!!!!");
  //documentatia e in Simulation.pde
}

    public static Float scanNumber(String args) {
        Pattern pattern = Pattern.compile("([0-9]+)");
        Matcher matcher = pattern.matcher(args);

        if (matcher.find()) {
          return Integer.parseInt(matcher.group(1)) / (float)15650;
        }
        return 0.0;
    }


void clientEvent(Client someClient) {

  int indexRobot = -1;

  for (int i=0; i<robotNR; i++)
  {
    if (someClient == cPort23[i]) {
      indexRobot = i;
      break;
    }
  }


  if (indexRobot > -1) {

    boolean xRead = false;
    boolean yRead = false;
    boolean oRead = false;
    while (someClient.available() > 20) {

      data[indexRobot] = someClient.readStringUntil(10);   
      data[indexRobot] = data[indexRobot].replaceAll("\\n", "");
      data[indexRobot] = data[indexRobot].replaceAll("\\r", "");

      if (indexRobot==1) {
        //println(someClient.available());
       // println(data[indexRobot]);
      }


      if (data[indexRobot].indexOf("X") == 0) {

        try {
          robot[indexRobot].x = Integer.valueOf(data[indexRobot].substring(1)) * (-1);
          xRead = true;
        }
        catch (NumberFormatException e) {   
          println("err x");
        }
      }


      if (data[indexRobot].indexOf("Y") == 0) {
        try {
          robot[indexRobot].y = Integer.valueOf(data[indexRobot].substring(1));
          yRead = true;
        }
        catch (NumberFormatException e) {        
          println("err y");
        }
      }


      if (data[indexRobot].indexOf("O") == 0) {
        try {
          int tmpDir = Integer.valueOf(data[indexRobot].substring(1));
          robot[indexRobot].dir = (int)(tmpDir / 6.27 + 180) % 360;
          oRead = true;
        }
        catch (NumberFormatException e) {        
          println("err o");
        }
      }
      
      if (xRead && yRead && oRead) {
        someClient.clear();
        break;
      }
      
    }
  }
}


void updateGoal() {
  for (int i = 0; i < robotNR; i++)
  {
    robot[i].goalX = puncte[stage][i][0];
    robot[i].goalY = puncte[stage][i][1];
    blocks.updateGoal(i, puncte[stage][i][0], puncte[stage][i][1]);
  }
}


void stop() {
  for (int i = 0; i < robotNR; i++)
  {
    cPort23[i].stop();
    cPort24[i].stop();
  }
} 


void keyPressed() {

  if (key=='q' || key == 'Q') {
    println("ESC!!");
    esc = !esc;
    for (int i=0; i<robotNR; i++)
    {

      if (cPort24[i] != null && cPort24[i].active()) {
        cPort24[i].write("iw 0 " + config.motorLeftFwd + " 0\n");
        cPort24[i].write("iw 0 " + config.motorRightFwd + " 0\n");
      }
    }
  }


  if (key=='w' || key == 'W') { //exit!
    for (int i=0; i<robotNR; i++)
    {
      if (cPort24[i]!=null) {
        cPort24[i].write("iw 0 " + config.motorLeftFwd + " 0\n");
        cPort24[i].write("iw 0 " + config.motorRightFwd + " 0\n");
        delay(10);
        leds.TurnOffHalf1(cPort24[i]);
        leds.TurnOffHalf2(cPort24[i]);
      }
    }
  }

  if (key=='a' || key == 'A') { //exit!
    for (int i=0; i<robotNR; i++)
    {
      if (cPort24[i]!=null) {
        leds.TurnOffHalf1(cPort24[i]);
        leds.TurnOffHalf2(cPort24[i]);
      }
    }
  }

  if (key=='s' || key == 'S') { //exit!
    for (int i=0; i<robotNR; i++)
    {
      if (cPort24[i]!=null) {
        leds.TurnOnHalf1(cPort24[i],"0xFF0000");
        leds.TurnOnHalf2(cPort24[i],"0xFF0000");
      }
    }
  }


  if (key=='r' || key == 'R') {
    println("RANDOM!!");
    for (int i=0; i<robotNR; i++)
    {
      puncte[0][i][0] = (int)random(1000 ) - 500;
      puncte[0][i][1] = 200 + (int)random(600);        
      blocks.updateGoal(i, puncte[0][i][0], puncte[0][i][1]);
    }
  }

  if (key=='p' || key == 'P') {
    print("{");
    for (int i=0; i<robotNR; i++)
    {
      print("{" + robot[i].x + "," + robot[i].y + "},");
    }
    println("},");
  }



  if (key=='n' || key == 'N') {
    if (stage<puncte.length-1) { 
      stage++;
    } else {
      stage = 0;
    }
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


  boolean selected = false;
  for (int i=0; i<robotNR; i++) {
    if (_x > robot[i].x - 20 && _x  < robot[i].x +20)
      if (_y > robot[i].y -20  && _y < robot[i].y + 20)
      {
        println("Robot: " + i + " selected");
        robotSelected = i;
        selected = true;
        cPort24[i].write("ir 1 1\r\n");  //afla bateria!!!
      }
  }

  if (robotSelected > -1 && !selected) {
    println("pacapaca");
    puncte[stage][robotSelected][0] = _x;
    puncte[stage][robotSelected][1] = _y;
    


    if (swarmMode) {
      robot[robotSelected].isLeader = true;
      for (int i=0; i<robotNR; i++) {
        if (i != robotSelected) {
          puncte[stage][i][0] = robot[robotSelected].x;
          puncte[stage][i][1] = robot[robotSelected].x;
          robot[i].isLeader = false;
          leds.TurnOffHalf1(cPort24[i]);
          leds.TurnOffHalf2(cPort24[i]);
        } else {
          leds.TurnOnHalf1(cPort24[i], culori[stage]);
          leds.TurnOnHalf2(cPort24[i], culori[stage]);
        }
      }
    }

    updateGoal();
  }
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  config.setZoom(config.getZoom() + e);
  cf.UpdateXYZ(config.getTranslateX(), config.getTranslateY(), config.getZoom());
}
