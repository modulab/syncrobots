class Motor {
  public int ON = 1;
  public int OFF = 0;
  int motorLFwdPwm, motorRFwdPwm, motorLRevPwm, motorRRevPwm;
  Client client;
  
  void init(Client c) {
    motorLFwdPwm = motorRFwdPwm = motorLRevPwm = motorRRevPwm = 0;
    client = c;
  }
 
 
 public void start(int leftPwm, int rightPwm, int direction) {
   if (direction == 0) {
     startMotorLFwd(leftPwm);
     startMotorRFwd(rightPwm);
   } else {
     startMotorLRev(leftPwm);
     startMotorRRev(rightPwm);     
   }
 }
 
 public void stop() {
   stopMotorLFwd();
   stopMotorLRev();
   stopMotorRFwd();
   stopMotorRRev();
 }
 
  private void startMotorLFwd(int pwmValue) {
    if (pwmValue == motorLFwdPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorLRev();
    client.write("iw 0 " + config.motorLeftFwd + " " + pwmValue + "\r\n");
    motorLFwdPwm = pwmValue;
    delay(10);
  }
  
  
  private void startMotorLRev(int pwmValue) {
    if (pwmValue == motorLRevPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorLFwd();
    client.write("iw 0 " + config.motorLeftRev + " " + pwmValue + "\r\n");
    motorLRevPwm = pwmValue;
    delay(10);
  }


  private void startMotorRRev(int pwmValue) {
    if (pwmValue == motorRRevPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorRFwd();
    client.write("iw 0 " + config.motorRightRev + " " + pwmValue + "\r\n");
    motorRRevPwm = pwmValue;
    delay(10);
  }


  private void startMotorRFwd(int pwmValue) {
    if (pwmValue == motorRFwdPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorRRev();
    client.write("iw 0 " + config.motorRightFwd + " " + pwmValue + "\r\n");
    motorRFwdPwm = pwmValue;
    delay(10);
  }


 
  private void stopMotorLRev() {
    if (motorLRevPwm != 0) { //oprim cealalta directie
    delay(10);
      client.write("iw 0 " + config.motorLeftRev + " 0\r\n");
      motorLRevPwm = 0;
      delay(10);
    }
  }

  
  private void stopMotorRRev() {
    if (motorRRevPwm != 0) { //oprim cealalta directie
    delay(10);
      client.write("iw 0 " + config.motorRightRev + " 0\r\n");
      motorRRevPwm = 0;
      delay(10);
    }
  }


  private void stopMotorLFwd() {
    if (motorLFwdPwm != 0) { //oprim cealalta directie
    delay(10);
      client.write("iw 0 " + config.motorLeftFwd + " 0\r\n");
      motorLFwdPwm = 0;
      delay(10);
    }
  }

  private void stopMotorRFwd() {
    if (motorRFwdPwm != 0) { //oprim cealalta directie
    delay(10);
      client.write("iw 0 " + config.motorRightFwd + " 0\r\n");
      motorRFwdPwm = 0;
      delay(10);
    }
  }
  
}
