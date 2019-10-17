class Config {
  
  int translateX = 480;
  int translateY = 180;
  float zoom = 3;
  public int motorLeftFwd = 14;
  public int motorLeftRev = 12;
  
  public int motorRightFwd = 5;
  public int motorRightRev = 4;
  
    


  public String[] ips = {
      "192.168.1.15",
      "192.168.1.220",
      "192.168.1.27",
      "192.168.1.103",
      //"192.168.1.130",
      //"192.168.1.35",
      "192.168.1.65"
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
