class Robot {
  int ON = 1;
  int OFF = 0;
  int motorLFwdPwm, motorRFwdPwm, motorLRevPwm, motorRRevPwm;
  Client client;
  
  private void init(Client c) {
    motorLFwdPwm = motorRFwdPwm = motorLRevPwm = motorRRevPwm = 0;
    client = c;
  }
  
  private void startMotorLFwd(int pwmValue) {
    if (pwmValue == motorLFwdPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorLRev();
    client.write("iw 0 " + config.motorLeftFwd + " " + pwmValue + "\r\n");
    motorLFwdPwm = pwmValue;
  }
  
  
  private void startMotorLRev(int pwmValue) {
    if (pwmValue == motorLFwdPwm) return; // daca e aceeasi valoare ca data trecuta nu mai trimitem
    stopMotorRFwd();
    client.write("iw 0 " + config.motorLeftFwd + " " + pwmValue + "\r\n");
    motorLFwdPwm = pwmValue;
  }



  
  private void stopMotorLRev() {
    if (motorLRevPwm != 0) { //oprim cealalta directie
      client.write("iw 0 " + config.motorLeftRev + " 0\r\n");
      motorLRevPwm = 0;
      delay(10);
    }
  }

  
  private void stopMotorRRev() {
    if (motorRRevPwm != 0) { //oprim cealalta directie
      client.write("iw 0 " + config.motorRightRev + " 0\r\n");
      motorRRevPwm = 0;
      delay(10);
    }
  }


  private void stopMotorLFwd() {
    if (motorLFwdPwm != 0) { //oprim cealalta directie
      client.write("iw 0 " + config.motorLeftFwd + " 0\r\n");
      motorLFwdPwm = 0;
      delay(10);
    }
  }

  private void stopMotorRFwd() {
    if (motorRFwdPwm != 0) { //oprim cealalta directie
      client.write("iw 0 " + config.motorRightFwd + " 0\r\n");
      motorRFwdPwm = 0;
      delay(10);
    }
  }


  
}
