class Config {
  
  int translateX = 480;
  int translateY = 180;
  float zoom = 3;

  public String[] ips = {
      //"192.168.1.18"
      "192.168.1.145"
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
