
class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  Slider sw, sh, zoom;
  controlP5.Button[] but = new controlP5.Button[30]; 

  public ControlFrame(final PApplet _parent, int _w, int _h, String _name, Config config) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);
    
    sw = cp5.addSlider("Transpune X")
       .plugTo(parent, "translateX")
       .setBroadcast(false)
       .setRange(0, 1000)
       .setValue(config.getTranslateX())
       .setPosition(50, 40)
       .setSize(200, 10)
       .setBroadcast(true);

       
    sh = cp5.addSlider("Transpune Y")
       .plugTo(parent, "translateY")
       .setRange(-500, 500)
       .setValue(config.getTranslateY())
       .setPosition(50, 55)
       .setSize(200, 10)
       ;

    zoom = cp5.addSlider("Zoom")
       .plugTo(parent, "zoom")
       .setRange(0, 10)
       .setValue(config.getZoom())
       .setPosition(50, 75)
       .setSize(200, 10)
       ;



    cp5.addSlider("Raza de ocolit")
       .plugTo(parent, "razaDeOcolit")
       .setBroadcast(false)
       .setRange(0, 250)
       .setValue(197)
       .setPosition(50, 130)
       .setSize(200, 30)
       .setBroadcast(true)
       ;

    cp5.addSlider("Raza Robot")
       .plugTo(parent, "razaRobot")
       .setBroadcast(false)
       .setRange(0, 200)
       .setValue(107)
       .setPosition(50, 160)
       .setSize(200, 15)
       .setBroadcast(true)
       ;


    cp5.addSlider("Motor Speed")
       .plugTo(parent, "motorSpeed")
       .setBroadcast(false)
       .setRange(400, 1000)
       .setValue(870)
       .setPosition(50, 190)
       .setSize(200, 30)
       .setBroadcast(true)
       ;





    cp5.addSlider("Fine Tune Motors")
       .plugTo(parent, "fineTuneMotors")
       .setBroadcast(false)
       .setRange(0, 50)
       .setValue(0)
       .setPosition(50, 220)
       .setSize(200, 30)
       .setBroadcast(true)
       ;


  cp5.addToggle("Staging")
       .plugTo(parent, "staging")
       .setPosition(50,260)
       .setSize(15,15)
       .setState(false)
       ;


  cp5.addToggle("Swarm Mode")
       .plugTo(parent, "swarmMode")
       .setPosition(50,290)
       .setSize(15,15)
       .setState(false)
       ;


   cp5.addToggle("Rotire in loc clockwise")
     .setLabel("Rotire in loc clockwise")
     .plugTo(parent, "rotireInLocClockwise")
     .setBroadcast(false)
     .setValue(false)
     .setPosition(20,400)
     .setSize(120,19)
     .setBroadcast(true)
     ;      

   cp5.addButton("Rotire in loc anti-wise")
     .setLabel("Rotire in loc anti-wise")
     .plugTo(parent, "rotireInLocAntiClockwise")
     .setBroadcast(false)
     .setValue(1)
     .setPosition(150,400)
     .setSize(120,19)
     .setBroadcast(true)
     ;      

   cp5.addButton("Stop Rotire!")
     .setLabel("Stop Rotire!")
     .plugTo(parent, "rotireInLocStop")
     .setBroadcast(false)
     .setValue(1)
     .setPosition(290,400)
     .setSize(120,19)
     .setBroadcast(true)
     ;      


   cp5.addButton("Start")
     .setValue(0)
     .setPosition(50,500)
     .setSize(100,19)
     ;      

   cp5.addButton("Stop")
     .setValue(1)
     .setPosition(200,500)
     .setSize(100,19)
     ;      

      
     for (int i = 0; i < config.ips.length; i++) {
         but[i] = cp5.addButton(config.ips[i])
             .setLabel(config.ips[i])
            .setValue(i)
            .setPosition(5 + i%5*80, 600+(int)(i/5)*25)
            .setSize(70, 20)
            .onPress(new CallbackListener() { // a callback function that will be called onPress
            public void controlEvent(CallbackEvent theEvent) {
              String name = theEvent.getController().getName();
              int value = (int)theEvent.getController().getValue();
              println("got a press from a " + name + ", the value is " + value);
              robot[value].sendReset();
            }});
     };
       
  }




public void UpdateXYZ(int x, int y, float z) {
  sw.setValue(x);
  sh.setValue(y);
  zoom.setValue(z);
}


public void UpdateButton(int index, int c) {
  but[index].setColorBackground(c);
}


public void Start(int theValue) {
  println("a button event from colorA: "+theValue);
}

public void Stop(int theValue) {
  println("a button event from colorA: "+theValue);
}



  void draw() {
    background(190);
  }
}
