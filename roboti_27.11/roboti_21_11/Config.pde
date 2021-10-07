class Config {
  
  int translateX = 438;
  int translateY = -100;
  float zoom = 3;
  public int motorLeftFwd = 14;
  public int motorLeftRev = 12;
  
  public int motorRightFwd = 5;
  public int motorRightRev = 4;
  
    
/*
  public String[] ips = {
      "192.168.1.5",
    //  "192.168.1.12",
      "192.168.1.15",
      "192.168.1.24",
      "192.168.1.27",
      "192.168.1.35",
      "192.168.1.36",
      "192.168.1.39",
      "192.168.1.58",
     // "192.168.1.60",
      "192.168.1.65", 
      "192.168.1.103",
      "192.168.1.109",
      "192.168.1.130",
      //"192.168.1.186",
      "192.168.1.214",
     // "192.168.1.215", 
    //  "192.168.1.222",
    //  "192.168.1.223"
  };
  */
    public String[] ips = {
      "192.168.1.65",
     // "192.168.1.36", probleme la sezori
      //"192.168.1.223",
      "192.168.1.186",
      "192.168.1.233",
     "192.168.1.5",
      "192.168.1.15",
      "192.168.1.35",
     "192.168.1.109",      
      "192.168.1.27",
      "192.168.1.196",
    "192.168.1.214",
     "192.168.1.12",
   "192.168.1.97",
     "192.168.1.39",
      "192.168.1.215",
      "192.168.1.130",
      "192.168.1.37",
  
     "192.168.1.222",
      "192.168.1.24",
      "192.168.1.103",
      "192.168.1.106",
      "192.168.1.58",
      //"192.168.1.54",
      
  };
  


  void setZoom(float z) {
    zoom = z;
  }

  float getZoom() {
    return zoom;
  }

  
  int getTranslateX(){
    return translateX;
  }

  int getTranslateY(){
    return translateY;
  }

  void setTranslateX(int x){
    translateX = x;
  }

  void setTranslateY(int y){
    translateY = y;
  }


  int getNrRobots(){
    return robotNR;
  }


}
