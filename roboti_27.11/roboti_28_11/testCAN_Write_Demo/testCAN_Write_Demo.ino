/****************************************************************************
CAN Write Demo for the SparkFun CAN Bus Shield. 

Written by Stephen McCoy. 
Original tutorial available here: http://www.instructables.com/id/CAN-Bus-Sniffing-and-Broadcasting-with-Arduino
Used with permission 2016. License CC By SA. 

Distributed as-is; no warranty is given.
*************************************************************************/

#include <Canbus.h>
#include <defaults.h>
#include <global.h>
#include <mcp2515.h>
#include <mcp2515_defs.h>

//********************************Setup Loop*********************************//

void setup() {
  Serial.begin(9600);
  Serial.println("CAN Write - Testing transmission of CAN Bus messages");
  delay(1000);
  
  if(Canbus.init(CANSPEED_250))  //Initialise MCP2515 CAN controller at the specified speed
    Serial.println("CAN Init ok");
  else
    Serial.println("Can't init CAN");
    
  delay(1000);
  tCAN m;
          m.id = 0x00; //formatted in HEX
        m.header.rtr = 0;
        m.header.length = 2; //formatted in DEC
        m.data[0] = 0x01;
        m.data[1] = 0x01;
  
mcp2515_bit_modify(CANCTRL, (1<<REQOP2)|(1<<REQOP1)|(1<<REQOP0), 0);
mcp2515_send_message(&m);


          m.id = 0x601; //formatted in HEX
        m.header.rtr = 0;
        m.header.length = 8; //formatted in DEC
        m.data[0] = 0x2F;
        m.data[1] = 0x60;
        m.data[2] = 0x60;
        m.data[3] = 0x00;
        m.data[4] = 0x03;
        m.data[5] = 0x00;
        m.data[6] = 0x00;
        m.data[7] = 0x00;
  
mcp2515_bit_modify(CANCTRL, (1<<REQOP2)|(1<<REQOP1)|(1<<REQOP0), 0);
mcp2515_send_message(&m);


          m.id = 0x601; //formatted in HEX
        m.header.rtr = 0;
        m.header.length = 8; //formatted in DEC
        m.data[0] = 0x2B;
        m.data[1] = 0x40;
        m.data[2] = 0x60;
        m.data[3] = 0x00;
        m.data[4] = 0x0F;
        m.data[5] = 0x00;
        m.data[6] = 0x00;
        m.data[7] = 0x00;
  
mcp2515_bit_modify(CANCTRL, (1<<REQOP2)|(1<<REQOP1)|(1<<REQOP0), 0);
mcp2515_send_message(&m);


}

//********************************Main Loop*********************************//

void loop() 
{
  
tCAN message;
tCAN messageRead;

        message.id = 0x601; //formatted in HEX
        message.header.rtr = 0;
        message.header.length = 8; //formatted in DEC
        message.data[0] = 0x23;
	message.data[1] = 0xFF;
	message.data[2] = 0x60;
	message.data[3] = 0x00; //formatted in HEX
	message.data[4] = 0x10;
	message.data[5] = 0x77;
	message.data[6] = 0x00;
	message.data[7] = 0x00;

mcp2515_bit_modify(CANCTRL, (1<<REQOP2)|(1<<REQOP1)|(1<<REQOP0), 0);
mcp2515_send_message(&message);

delay(1000);

Serial.println("Check!");
if (mcp2515_check_message()) 
  {
     Serial.print("OKk!");
    if (mcp2515_get_message(&messageRead)) 
  {
        //if(message.id == 0x620 and message.data[2] == 0xFF)  //uncomment when you want to filter
             //{
               
               Serial.print("ID: ");
               Serial.print(messageRead.id,HEX);
               Serial.print(", ");
               Serial.print("Data: ");
               Serial.print(messageRead.header.length,DEC);
               for(int i=0;i<messageRead.header.length;i++) 
                { 
                  Serial.print(messageRead.data[i],HEX);
                  Serial.print(" ");
                }
               Serial.println("");
             //}
           }}


}
