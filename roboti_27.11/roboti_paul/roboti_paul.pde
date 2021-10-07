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
//{{-754,2653},{-897,2040},{-364,2212},{-466,1665},{-637,2107},{-557,2407},{-1111,1872},{-809,2963},{-686,1729},{-232,1608},{-199,2795},{-910,1793},{0,1548},{-515,2883},{67,2720},{328,2673},}, //m
//{{-1085,2837},{-1252,2453},{137,1930},{-623,1387},{-1130,1557},{-285,2928},{-1324,2064},{-855,2928},{-873,1400},{-327,1472},{-84,2747},{-1270,1760},{-35,1671},{-587,2961},{86,2528},{135,2314},}, //o
//{{-1074,2860},{-1293,2918},{98,2189},{-497,1977},{-1001,2138},{-383,2690},{-1334,2618},{-848,2810},{-767,1992},{-285,1943},{-181,2597},{-1194,2326},{-115,2009},{-624,2765},{65,2520},{263,2386},}, //d
//{{-1055,3029},{-1282,3083},{-58,2014},{-783,1904},{-1210,2050},{-306,2836},{-1562,2181},{-802,2966},{-1017,1973},{-591,1826},{-84,2755},{-1397,2111},{-320,1850},{-543,2941},{71,2470},{79,2227},}, //u
//{{-1055,3029},{-1282,3083},{-2,2205},{-149,2338},{-324,2608},{-306,2836},{-100,2535},{-802,2967},{-1222,2899},{-936,2819},{-84,2755},{-630,2722},{-64,2037},{-558,2909},{136,2666},{61,2417},}, //l
//{{-1041,2706},{-1342,2591},{-442,2260},{-390,1521},{-640,1738},{-285,2710},{-172,1367},{-741,2716},{-1187,2405},{-963,2092},{-96,2698},{-779,1908},{-521,2033},{-523,2718},{114,2706},{-382,2463},}, //a
//{{-1002,3047},{-1231,3094},{-648,2674},{-140,2107},{-456,2155},{-362,2792},{63,2354},{-747,2954},{-1314,2859},{-1266,2587},{-116,2716},{-1062,2411},{-822,2533},{-528,2867},{134,2566},{-567,2423},}, //b
//{{-1241,2906},{-927,2565},{-526,2868},{-1286,2102},{-482,1952},{-830,1748},{-342,2363},{-1037,2210},{-657,1949},{-1488,1951},{-1108,2766},{-848,1985},{-454,2570},{-681,2615},{-1082,2395},{-371,2154},}, //traian
{{-111,2030},{28,4060},}, //simly




};

boolean staging = false;
boolean swarmMode = true;
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

  if (someClient == cPort24[0]) {
      
      byte interesting = 10;
      robot[0].readyToSend = false;
      String myString = someClient.readStringUntil(interesting);
      if (myString.length()>24) {
        println("xxx: " + myString.length());
      }
      
      someClient.clear(); 
      robot[0].readyToSend = true;
  }

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


  boolean selected = true;
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
