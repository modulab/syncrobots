class Config {
  
  int translateX = 438;
  int translateY = -100;
  float zoom = 3;
  public int motorLeftFwd = 14;
  public int motorLeftRev = 12;
  
  public int motorRightFwd = 5;
  public int motorRightRev = 4;
  
    

  public String[] ips = {
      "10.231.74.65",
      //"10.231.74.130",
      //"10.231.74.103",
      "10.231.74.15",
      //"10.231.74.233",
      "10.231.74.27"
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
