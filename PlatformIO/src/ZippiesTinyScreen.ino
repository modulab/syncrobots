
#include <Wire.h>
#include "Zippy.h"
#include "AutoDriveMode.h"
#include "Bluetooth.h"
#include "ZippyConfig.h"

#define BLE_RECEIVE_MOTORS_ALL_STOP  0x00
#define BLE_RECEIVE_MOTORS_SET       0x15
#define BLE_RECEIVE_FORWARD_STRAIGHT 0x16
#define BLE_SEND_DEBUG_INFO          0x00
#define BLE_AUTODRIVE_MODE           0x20
#define BLE_MANUAL_MODE              0x21
#define BLE_SEND_INTERVAL_MS          500

#define LOOP_INDICATOR_INTERVAL 5000

Zippy zippy;
int a,x,y,o;

String readString, servo1, servo2;

//L298N motor1(EN, 4, 5);
//L298N motor2(EN, 8, 9);


AutoDriveMode* autoDriver = NULL;

void setup()
{
  Wire.begin();
  Serial.begin(115200);
   // SerialUSB.begin(115200);
   while (!Serial); //  while (!SerialUSB);
   Serial.println("Started serial port."); //SerialUSB.println("Started serial port.");
   x=y=o=a=0;

   //pinMode(4, OUTPUT);//fwd
   //pinMode(5, OUTPUT);
   pinMode(11, OUTPUT);//fwd
   //pinMode(9, OUTPUT);

  zippy.start();
//  SerialUSB.println("Started Zippy.");
  Serial.println("Started Zippy.");

  autoDriver = new AutoDriveMode(&zippy);
  //SerialUSB.println("Started Auto-Drive mode.");
  Serial.println("Started Auto-Drive mode.");

  //pinMode(8, OUTPUT); //Onboard Blue LED
  //digitalWrite(8, HIGH);
  //analogWrite(4, 0);
  //analogWrite(8, 0);
}

void loop()
{
    static uint64_t loopTimer = millis();
/*
    while (Serial.available()) {
       delay(3);  //delay to allow buffer to fill
       if (Serial.available() >0) {
         char c = Serial.read();  //gets one byte from serial buffer
         readString += c; //makes the string readString
       }
     }


     if (readString.length() >0) {
           // expect a string like 07002100 containing the two servo positions
           servo1 = readString.substring(0, 4); //get the first four characters
           servo2 = readString.substring(4, 8); //get the next four characters

           int n1 = servo1.toInt();
           int n2 = servo2.toInt();

          //analogWrite(4, n1);
          //analogWrite(5, 0);
          analogWrite(11, n2);
          //analogWrite(9, 0);
         readString="";
       }
*/
    zippy.loop();

    Lighthouse* lighthouse = zippy.getLighthouse();
    KVector2* positionVector = lighthouse->getPosition();
    KVector2* orientVector = lighthouse->getOrientation();

    if ( o!=(int)(orientVector->getOrientation()*360) ||
      x != positionVector->getX() ||
      y != positionVector->getY()) {

      Serial.print("Y");
      Serial.println((int)positionVector->getY());
      Serial.print("X");
      Serial.println((int)positionVector->getX());
      Serial.print("O");
      Serial.println((int)(orientVector->getOrientation()*360));  // SerialUSB.println((int)(orientVector->getOrientation()*360));
      o = (int)(orientVector->getOrientation()*360);
      x = (int)positionVector->getX();
      y = (int)positionVector->getY();
    }

    if (autoDriver != NULL)
      autoDriver->loop();

}


void extractSensorPacket(LighthouseSensor* sensor, uint8_t* debugPacket)
{
    //X sync ticks (2 bytes)
    unsigned short nextShortValue = 0;//sensor->getXSyncTickCount();
    memcpy(debugPacket, &nextShortValue, sizeof(unsigned short));
    int packetPosition = sizeof(unsigned short);

    //X sweep ticks (4 bytes)
    unsigned int nextIntValue = sensor->getXSweepTickCount();
    memcpy(debugPacket+packetPosition, &nextIntValue, sizeof(unsigned int));
    packetPosition += sizeof(unsigned int);

    //calculated X position (4 bytes)
    KVector2* currentSensorPosition = sensor->getPosition();
    float nextFloatValue = currentSensorPosition->getX();
    memcpy(debugPacket+packetPosition, &nextFloatValue, sizeof(float));
    packetPosition += sizeof(float);

    //Y sync ticks (2 bytes)
    nextShortValue = 0;//sensor->getYSyncTickCount();
    memcpy(debugPacket+packetPosition, &nextShortValue, sizeof(unsigned short));
    packetPosition += sizeof(unsigned short);

    //Y sweep ticks (4 bytes)
    nextIntValue = sensor->getYSweepTickCount();
    memcpy(debugPacket+packetPosition, &nextIntValue, sizeof(unsigned int));
    packetPosition += sizeof(unsigned int);

    //calculated Y position (4 bytes)
    nextFloatValue = currentSensorPosition->getY();
    memcpy(debugPacket+packetPosition, &nextFloatValue, sizeof(float));
}
