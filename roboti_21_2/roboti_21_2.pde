import processing.net.*;
import java.net.*;
//Client c,c1;

boolean esc = true;

int robotNR = 3;
int[] x = new int[robotNR];
int[] y = new int[robotNR];
int[] dir = new int[robotNR];

int aproape = 50;
int demultiplicator = 1;

String[] data =new String[robotNR];

int[][] puncte= {{-102,753}, {-445,913}, {30,30}, {40,30}, {30,20}};

String[] ips = {
                  "192.168.1.16" , "192.168.1.18" , "192.168.1.54" 
                };

Client[] cPort23 = new Client[robotNR];
Client[] cPort24 = new Client[robotNR];

//L_fwd = iw 0 4 (pwm) 
//L_bkw = iw 0 15 (pwm)
//R_fwd = iw 0 12 (pwm)
//R_bkw = iw 0 14 (pwm)
//192.168.1.18 square 250000
//192.168.1.83 jager 115000
//192.168.1.145 red 1 250000
//192.168.1.158 red 2 -

void setup() {

  for (int i=0; i<robotNR;i++)
  {
    x[i]=y[i]=dir[i]=0;
    cPort23[i] = new Client(this, ips[i], 23);
    cPort24[i] = new Client(this, ips[i], 24);
    println("Init robot " + ips[i]);
  }
  
  println("Setup completed!");
  
  //c = new Client(this, "192.168.0.102", 23); 
  //c1 = new Client(this, "192.168.0.102", 24); 

  size(1000, 800);
  background(0);
    
}



void draw() {
  
  background(0);
  textSize(12);
  
//float spre = (getAngle(puncte[0][1],y,puncte[0][0],x) + 90) % 360;

  for (int i=0; i<robotNR; i++)
  {
    
    resetMatrix();
    
    
    
    float deltaX = (x[i] - puncte[i][0]);
    float deltaY = (y[i] - puncte[i][1]);
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

/*
    text("robot: " + (float)((dir[i])), 10, 30);
    text("spre_: " + (spre), 10, 50); 
    text("dist_: " + dist(x[i],y[i],puncte[i][0],puncte[i][1]), 10, 70); 
    text("x_: " + (x[i]), 10, 90); 
    text("y_: " + (y[i]), 10, 110);   
    text("diff_: " + ((360- (float)(spre-dir[i]))%360), 10, 130); 
*/
    rect(puncte[i][0]/3+700,puncte[i][1]/4+300,20,40);
    translate(x[i]/3+700,y[i]/4+300);
    
    text("robot: " + (float)((dir[i])), 10, 30);
    text("spre_: " + (spre), 10, 50); 
    text("dist_: " + dist(x[i],y[i],puncte[i][0],puncte[i][1]), 10, 70); 
    text("x_: " + (x[i]), 10, 90); 
    text("y_: " + (y[i]), 10, 110);   
    text("diff_: " + ((360 - (float)(spre-dir[i]))%360), 10, 130); 

    
    rotate(radians(dir[i]+180));




    if (!esc) {
      
      float xx = ((360- (float)(spre-dir[i]))%360);
      
      if (dist(x[i],y[i],puncte[i][0],puncte[i][1]) < 150) {
        demultiplicator = 2;
      } else
      {
        demultiplicator = 1;
      }
      
      
      int motor = 200 + 800*(abs(180-(int)xx))/180/demultiplicator;
      
      
      
      if (dist(x[i],y[i],puncte[i][0],puncte[i][1]) < 50) {
           cPort24[i].write("iw 0 15 0\r\n");
           cPort24[i].write("iw 0 12 0\r\n");     
      } else
     //if (spre - (float)(dir/6+180)<0) {
       
       if (((360- (float)(spre-dir[i]))%360) < 180) {
       //cPort24[i].write("iw 0 15 400\r\n");
       cPort24[i].write("iw 0 15 " + motor + "\r\n");
       cPort24[i].write("iw 0 12 1000\r\n");
     } else {
       cPort24[i].write("iw 0 15 1000\r\n");
       cPort24[i].write("iw 0 12 " + motor + "\r\n");
       //cPort24[i].write("iw 0 12 400\r\n");
     }
   }
  rect(-10,-20,20,40);
  ellipse(0,20,20,20);

   
  }

/*
float deltaX = (x-puncte[0][0]);
float deltaY = (y-puncte[0][1]);
float spre = 0;


  if (x<0 && y <0) {
    spre = 180 + (degrees(atan(deltaX/deltaY)));
  }
  else if (x>0 && y<0){
    spre = 180 + (degrees(atan(deltaX/deltaY)));
  } else if (x<0 && y>0) {
    spre = (degrees(atan(deltaX/deltaY)));
  } else
    spre =  (degrees(atan(deltaX/deltaY)));

  spre = (360-spre) % 360;

  text("robot: " + (float)((dir)), 10, 30);
  text("spre_: " + (spre), 10, 50); 
  text("dist_: " + dist(x,y,puncte[0][0],puncte[0][1]), 10, 70); 
  text("x_: " + (x), 10, 90); 
  text("y_: " + (y), 10, 110); 
  
  text("diff_: " + ((360- (float)(spre-dir))%360), 10, 130); 
  
  rect(puncte[0][0]+700,puncte[0][1]+300,20,40);
  
   translate(x/3+700,y/4+300);
   rotate(radians(dir+180));
   //println("punct:" + getAngle(y,puncte[0][1],x,puncte[0][0]));
   
   if (!esc) {
   if (dist(x,y,puncte[0][0],puncte[0][1]) < 50) {
         c1.write("iw 0 4 0\r\n");
         c1.write("iw 0 12 0\r\n");
        
   } else
   
   //if (spre - (float)(dir/6+180)<0) {
     if (((360- (float)(spre-dir))%360) < 180) {
     c1.write("iw 0 4 110\r\n");
     c1.write("iw 0 12 200\r\n");
   } else {
     c1.write("iw 0 4 200\r\n");
     c1.write("iw 0 12 110\r\n");

   }
   }
  rect(-10,-20,20,40);
  ellipse(0,20,20,20);
  */
}


float getAngle(int y12, int y11, int x12,int x11) {
  
  float m1 = (float)(abs(y12 - y11)) / (float)(abs(x12 - x11));  
  float A = atan(m1) * 180 / PI;

  return A;
  
}

void clientEvent(Client someClient) {
  
  int indexRobot = -1;
  
  for (int i=0;i<robotNR; i++)
  {
    if (someClient == cPort23[i]) {
      indexRobot = i;
      //break;
    }
  }
  
  if (indexRobot > -1) {
    
  while (someClient.available() > 35) {
  
     data[indexRobot] = someClient.readStringUntil(10);
   // println(data);
   
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



void keyPressed() {
  println("xxx");
  
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
    //stop();
  }
  
  
  
  if (key=='a' || key == 'A') {
    println("START!!");
    //c1.write("iw 0 15 160\r\n");
  }
  
    if (key=='z' || key == 'Z') {
      println("STOP!!");
      //c1.write("iw 0 15 0\r\n");
  }
  
  if (key=='k' || key == 'K') {
      println("START!!");
      //c1.write("iw 0 12 160\r\n");
  }
  
    if (key=='m' || key == 'M') {
      println("STOP!!");
      //c1.write("iw 0 12 0\r\n");
  }

  
    if (key=='r' || key == 'R') {
      println("STOP!!");
      for (int i=0;i<robotNR;i++)
      {
        puncte[i][0]=(int)random(1000)-500;
        puncte[i][1]=200 + (int)random(1300);    
      }
  }
  

    if (key=='f' || key == 'F') {
      println("FOLLOW!!");
      puncte[1][0] = x[0];
      puncte[1][1] = y[0];
  }

  
  
  /*
        if (key=='e' || key == 'E') {
      println("STOP!!");
      puncte[0][0]=0;
      puncte[0][1]=0;
  }
  
  */
  if (key=='b' || key == 'B') {
    println("reset_sensor");
   
    cPort24[0].write("iw 0 0 0\r\n");
    delay(100);
    cPort24[0].write("iw 0 0 1\r\n");
  }
 
}


void disconnectEvent(Client someClient) {
  print("Server Says:  ");
}
