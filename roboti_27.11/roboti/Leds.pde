class Leds {
// iw 6 0 0xrrggbb  jumate de banda
// iw 6 1 0xrrggbb  cealalta jumatate
// iw 6 0 {0-255pwm} pwm juma
// iw 6 1 {0-255pwm} pwm juma2

    
    public void TurnOnHalf1(Client client, String c) {
      client.write("iw 6 0 " + c + "\r\n");
      //println(c);
    }
  
    public void TurnOffHalf1(Client client) {
      client.write("iw 6 0 0x0\r\n");
    }
  
  
    public void TurnOnHalf2(Client client, String c) {
      client.write("iw 6 1 " + c + "\r\n");
    }
  
    public void TurnOffHalf2(Client client) {
      client.write("iw 6 1 0x0\r\n");
    }
  
  
    public void PwmHalf1(Client client, String c) {
      client.write("iw 6 0 " + c + "\r\n");
    }
  
  
    public void PwmHalf2(Client client, String c) {
      client.write("iw 6 1 " + c + "\r\n");
    }

}
