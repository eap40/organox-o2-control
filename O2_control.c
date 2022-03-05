/*
Base program on which oxygen, air or pressure controller programs in GPIO file can be run.

I/0: PWM1 O2 Valve, RC2; PWM2 Air Pump, RC1; Analogue Flow Sensor 1,2  AN0 RA0 AN3 RA3;
     Pressure control: Analogue Pressure Sensors 1,2  AN1 RA1 and AN2 RA2;
     UART1: (to be completed)
     UART2: Write output to terminal program and User input RD6 TX, RD7 RX;
*/


//Global variables and Defines

//Analogue flow sensors
unsigned long sensor_output, mass_flow, air_flow, sensor_output2, sensor_output3, sensor_output4, pressure0, pressure1; //Analogue inputs
unsigned long _Avg_Output[128] = {0}; //Array for creating mass flow moving average
unsigned long _Avg_Pressure0[128] = {0};//Array for creating pressure moving Average
unsigned long _Avg_Pressure1[128] = {0};
unsigned long _Avg_Air[128] = {0};//Array for creating air flow moving average
float FlowValue;
float PressureValue0;
float PressureValue1;
float AirValue;

//UART
char String[64]; //for UART output
char inputMsg[64+1]; // for mass flow input
char usermsg[64+1]; // for user input

//02
char buf[8]; //used in control of O2 valve

//GPIO
int valve_duty = 0; //O2 PWM
unsigned short pump_duty = 0x00; //air pump PWM

//Air/O2 controller
float set_flow=0.0;
unsigned int control_state = 0; //value to toggle controller on/off according to user input
unsigned int control_counter=0;//counter used to cycle controller step demands


unsigned int counter = 0; // Timer for UART writes

//functions
void read_analogue(); //Read analogue sensors
extern unsigned long Average(unsigned long Data, unsigned long Array[]); // averaging routine
void GPIO(); //set outputs
void air_controller(); //air flow control function
void O2_controller();//O2 flow control function
void pressure_controller();//pressure control function

//***ISR***//
void interrupt(void)
 {
  static int i = 0;
  static int j = 0;
  char ch;
  static char cmd[64+1];
  char us;
  static char usr[64+1];


  if(PIR1.RC1IF == 1)  //If this is a uart1 rx interrupt
   {
    while (UART1_Data_Ready() == 1) {          // if data is received
     ch = UART1_Read();    // reads text until new line is found
     cmd[i] = ch;

      if (cmd[i] == '\n') {
        cmd[i] = 0;
        strcpy(inputMsg,cmd);
        i = 0;
      }
     else if (++i>=64) i = 0;
    }

   }

   if(PIR3.RC2IF == 1)    //If this is a uart2 rx interrupt
   {
    while (UART2_Data_Ready() == 1) {          // if data is received
     us = UART2_Read();    // reads text until new line is found
     usr[j] = us;

      if (usr[j] == '\r') {
        usr[j] = 0;
        strcpy(usermsg,usr);
        j = 0;
      }
     else if (++j>=64) j = 0;
    }
   }
}
   
 

      void main() {

//Port configuration

ANSELA = 0x0F; // configure PortA as analogue
TRISA = 0xFF; //PortA direction (inputs)
ANSELB = 0x00; //configure PortB as digital
TRISB = 0x80;   //PortB direction (outputs RB7 is RX)
ANSELC = 0X00;  // configure PortC as digital
TRISC = 0x00;   //PortC direction
ANSELD = 0X00;  // configure PortD as digital
TRISD = 0x80;   //PortD direction (outputs RD7 is RX)

// Intitialise UART
UART1_Init(9600);           // Initialise UART1 module at 9600 bps
Delay_ms(100);
UART2_Init(9600);           // Initialise UART1 module at 9600 bps
Delay_ms(100);
// End

// Initialise PWM1
PWM1_Init(15000);                   // Initialise PWM1 module at 15KHz
C1ON_bit = 0;                       // Disable comparator
valve_duty  = 0;                    // initial value for current_duty  OFF
PWM1_Start();                       // start PWM1
PWM1_Set_Duty(valve_duty);          // Set current duty for PWM1
// End

//Initialise PWM2
PWM2_Init(15000);                   // Initialise PWM1 module at 15KHz
C1ON_bit = 0;                       // Disable comparator
pump_duty  = 0;                    // initial value for current_duty  OFF
PWM2_Start();                       // start PWM1
PWM2_Set_Duty(pump_duty);          // Set current duty for PWM1
// End

// Enable interrupts
PIE1.RC1IE = 1;                     //enable interrupt UART1
PIE3.RC2IE = 1;                     //enable interrupt UART2
INTCON.PEIE = 1;                    //PERIPHERAL INTERRUPT ENABLE
INTCON.GIE = 1;                     // Global interrupt enable

for(;;)
 {
  read_analogue();  //read flow and pressure
  mass_flow = Average(sensor_output,_Avg_Output); // Store and average values for sensor output  !!ADD SENSOR SCALING HERE!!
  FlowValue = (mass_flow * 0.3961) - 206.4; //scale Flow sensor output mlpm
  air_flow = Average(sensor_output4, _Avg_Air);
  AirValue = (air_flow * 0.396) - 202.8;//scale flow sensor for air pump
  pressure0 = Average(sensor_output2, _Avg_Pressure0);
  pressure1 = Average(sensor_output3, _Avg_Pressure1);
  PressureValue0 = (2.09 * pressure0) - 5245.6; //convert from mV to mbar
  PressureValue1 = (2.09 * pressure1) - 5245.9;
  /*strncpy(buf,&inputMsg[3],5);   // read CO2 sensor intput and extract characters
  buf[5] = 0;  //
  CO2_PPM = (int)atoi(buf); //convert characters to CO2 value ppm*/

  //GPIO();  //call the GPIO function
  
  O2_controller();//call the O2 control function
  pressure_controller();//call the pressure control function
  
  Counter++;   //Increment Counter

  if(Counter == 50) {  //write data every second
    Counter = 0;  // Clear Counter
    sprintf(String, "%f, %f, %f, %f, %d\r\n",(float)FlowValue,(float)PressureValue0, (float)PressureValue1, (float)set_flow, (int)pump_duty);
    UART2_Write_Text(String);   //
   }

  Delay_ms(10); // 10ms loop time  WHY
  }
}