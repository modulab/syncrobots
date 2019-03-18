import processing.net.*;
import java.net.*;
Client c,c1;
String data;
int x,y,dir;
boolean esc = true;

int[][] puncte= {{100,100}, {10,0}, {30,30}, {40,30}, {30,20}};

void setup() {
  x=y=dir=0;
  c = new Client(this, "192.168.1.83", 23); 
  c1 = new Client(this, "192.168.1.83", 24); 

 // frameRate(30);
 size(1000, 500);
  background(0);
    
}



void draw() {
  
  //println("ddddddd");
  background(0);
  
//float spre = (getAngle(puncte[0][1],y,puncte[0][0],x) + 90) % 360;
float deltaX = (x-puncte[0][0]);
float deltaY = (y-puncte[0][1]);
float spre =0;


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
}


float getAngle(int y12, int y11, int x12,int x11) {
  
  float m1 = (float)(abs(y12 - y11)) / (float)(abs(x12 - x11));  
  float A = atan(m1) * 180 / PI;

  return A;
  
}

void clientEvent(Client someClient) {
   
  if (someClient == c) {
    
  while (someClient.available() > 35) {
  
     data = someClient.readStringUntil(10);
   // println(data);
   
     data = data.replaceAll("\\n", "");
     data = data.replaceAll("\\r", "");
     
     if (data.indexOf("X") == 0) {
          
        try{
          x = Integer.valueOf(data.substring(1))*(-1);
        }
        catch (NumberFormatException e) {   
          println("err x");
        }
      }
      
      
      if (data.indexOf("Y") == 0) {
        //println(lines[i].substring(1));
        try{
        y = Integer.valueOf(data.substring(1));
            }
        catch (NumberFormatException e) {        
          println("err y");
        }

      }


      if (data.indexOf("O") == 0) {
        try {
        dir = Integer.valueOf(data.substring(1));
        dir = dir +60;
        dir = (dir / 6 +180) % 360;
        }
        catch (NumberFormatException e) {        
          println("err o");
        }

      }
  } 
  }

}


void stop() {
      c.stop();
    c1.stop();
} 



void keyPressed() {
  println("xxx");
  
  if (key=='q' || key == 'Q') {
    println("ESC!!");
    esc = !esc;
    c1.write("iw 0 4 0\r\n");
    c1.write("iw 0 12 0\r\n");
  }
  
  
  if (key=='w' || key == 'W') {
    c.stop();
    c1.stop();
  }
  
  
  
  if (key=='a' || key == 'A') {
    println("START!!");
    c1.write("iw 0 4 160\r\n");
  }
  
    if (key=='z' || key == 'Z') {
      println("STOP!!");
      c1.write("iw 0 4 0\r\n");
  }
  
  if (key=='k' || key == 'K') {
      println("START!!");
      c1.write("iw 0 12 160\r\n");
  }
  
    if (key=='m' || key == 'M') {
      println("STOP!!");
      c1.write("iw 0 12 0\r\n");
  }

  
      if (key=='r' || key == 'R') {
      println("STOP!!");
      puncte[0][0]=100+(int)random(200);
      puncte[0][1]=100+(int)random(300);
  }
  
        if (key=='e' || key == 'E') {
      println("STOP!!");
      puncte[0][0]=0;
      puncte[0][1]=0;
  }
  
}


void disconnectEvent(Client someClient) {
  print("Server Says:  ");


}
