class Motor {
  public int ON = 1;
  public int OFF = 0;
  int motorLFwdPwm, motorRFwdPwm, motorLRevPwm, motorRRevPwm;
  boolean sentSuccess = false;
  int idRobot;
  
  
  void init() {
    motorLFwdPwm = motorRFwdPwm = motorLRevPwm = motorRRevPwm = 0;
  }
 
 
 public void start(int _idRobot, int leftPwm, int rightPwm, int direction) {
   idRobot = _idRobot;

   if (direction == 0) {
     startCommand();
     startMotorLFwd(leftPwm);
     startMotorRFwd(rightPwm);
     endCommand();
   } 
   
   if (direction == 1) {
     startCommand();
     startMotorLRev(leftPwm);
     startMotorRRev(rightPwm);
     endCommand();
   }
   
   if (direction == 2) {
      startCommand();
      startMotorPiruieta(0,max(leftPwm,rightPwm));
      endCommand();
      //startMotorPiruieta(0,1000);
   }

   if (direction == 3) { //pentru aliniere 180grade
      //startMotorPiruieta(max(leftPwm,rightPwm));

      startMotorPiruieta(1000,1000);
   }

   
 }
 
 public void stop(int _idRobot) {
   idRobot = _idRobot;
   startCommand();
   stopMotorLFwd();
   stopMotorLRev();
   stopMotorRFwd();
   stopMotorRRev();
   endCommand();
 }
 
 
   private void startMotorPiruieta(int pwmValue1, int pwmValue) {
   if (pwmValue != motorLRevPwm && pwmValue != motorRFwdPwm) 
   {
   //return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    startCommand();
    stopMotorLRev();
    stopMotorRFwd();
    //delay(10);
    stopMotorLFwd();
    stopMotorRRev();
   }

    sendMotor("iw 0 " + config.motorLeftRev + " " + pwmValue + "\r\n");
    sendMotor("iw 0 " + config.motorRightFwd + " " + pwmValue + "\r\n");

    sendMotor("iw 0 " + config.motorLeftFwd + " " + pwmValue1 + "\r\n");
    sendMotor("iw 0 " + config.motorRightRev + " " + pwmValue1 + "\r\n");

    motorLRevPwm = pwmValue;
    motorRFwdPwm = pwmValue;
    motorLFwdPwm = pwmValue1;
    motorRRevPwm = pwmValue1;

    endCommand();
  }
 
 
  private void startMotorLFwd(int pwmValue) {
    //if (pwmValue == motorLFwdPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorLRev();
    sendMotor("iw 0 " + config.motorLeftFwd + " " + pwmValue + "\n");
    motorLFwdPwm = pwmValue;
  }
  
  
  private void startMotorLRev(int pwmValue) {
    //if (pwmValue == motorLRevPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorLFwd();
    sendMotor("iw 0 " + config.motorLeftRev + " " + pwmValue + "\n");
    motorLRevPwm = pwmValue;
  }


  private void startMotorRRev(int pwmValue) {
    //if (pwmValue == motorRRevPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorRFwd();
    sendMotor("iw 0 " + config.motorRightRev + " " + pwmValue + "\n");
    motorRRevPwm = pwmValue;
  }


  private void startMotorRFwd(int pwmValue) {
    //if (pwmValue == motorRFwdPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorRRev();
    sendMotor("iw 0 " + config.motorRightFwd + " " + pwmValue + "\n");
    motorRFwdPwm = pwmValue;
  }


 
  private void stopMotorLRev() {
   // if (motorLRevPwm != 0) { //oprim cealalta directie
    //delay(10);
      sendMotor("iw 0 " + config.motorLeftRev + " 0\n");
      motorLRevPwm = 0;
    //}
  }

  
  private void stopMotorRRev() {
    //if (motorRRevPwm != 0) { //oprim cealalta directie
    //delay(10);
      sendMotor("iw 0 " + config.motorRightRev + " 0\n");
      motorRRevPwm = 0;
    //}
  }


  private void stopMotorLFwd() {
    //if (motorLFwdPwm != 0) { //oprim cealalta directie
    //delay(10);
      sendMotor("iw 0 " + config.motorLeftFwd + " 0\n");
      motorLFwdPwm = 0;
    //}
  }

  private void stopMotorRFwd() {
    //if (motorRFwdPwm != 0) { //oprim cealalta directie
    //delay(10);
      sendMotor("iw 0 " + config.motorRightFwd + " 0\n");
      motorRFwdPwm = 0;
    //}
  }

  private void startCommand() {
     robot[idRobot].toSend.offer("s");
  }
  
  private void endCommand() {
     robot[idRobot].toSend.offer("g");
  }
  
  private void sendMotor(String comanda) {
   // if (true) return;
    //do {
      //intln("ccc: " + robot[idRobot].toSend);
     if (robot[idRobot].toSend!=null)
      robot[idRobot].toSend.offer(comanda);
    //}while (!sentSuccess);
    //sentSuccess =  false;
  }
    
  
}
