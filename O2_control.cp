#line 1 "C:/Users/Ed Phillips/Documents/Organox/O2_project/O2_control.c"
#line 15 "C:/Users/Ed Phillips/Documents/Organox/O2_project/O2_control.c"
unsigned long sensor_output, mass_flow, air_flow, sensor_output2, sensor_output3, sensor_output4, pressure0, pressure1;
unsigned long _Avg_Output[128] = {0};
unsigned long _Avg_Pressure0[128] = {0};
unsigned long _Avg_Pressure1[128] = {0};
unsigned long _Avg_Air[128] = {0};
float FlowValue;
float PressureValue0;
float PressureValue1;
float AirValue;


char String[64];
char inputMsg[64+1];
char usermsg[64+1];


char buf[8];


int valve_duty = 0;
unsigned short pump_duty = 0x00;


float set_flow=0.0;
unsigned int control_state = 0;
unsigned int control_counter=0;


unsigned int counter = 0;


void read_analogue();
extern unsigned long Average(unsigned long Data, unsigned long Array[]);
void GPIO();
void air_controller();
void O2_controller();
void pressure_controller();


void interrupt(void)
 {
 static int i = 0;
 static int j = 0;
 char ch;
 static char cmd[64+1];
 char us;
 static char usr[64+1];


 if(PIR1.RC1IF == 1)
 {
 while (UART1_Data_Ready() == 1) {
 ch = UART1_Read();
 cmd[i] = ch;

 if (cmd[i] == '\n') {
 cmd[i] = 0;
 strcpy(inputMsg,cmd);
 i = 0;
 }
 else if (++i>=64) i = 0;
 }

 }

 if(PIR3.RC2IF == 1)
 {
 while (UART2_Data_Ready() == 1) {
 us = UART2_Read();
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



ANSELA = 0x0F;
TRISA = 0xFF;
ANSELB = 0x00;
TRISB = 0x80;
ANSELC = 0X00;
TRISC = 0x00;
ANSELD = 0X00;
TRISD = 0x80;


UART1_Init(9600);
Delay_ms(100);
UART2_Init(9600);
Delay_ms(100);



PWM1_Init(15000);
C1ON_bit = 0;
valve_duty = 0;
PWM1_Start();
PWM1_Set_Duty(valve_duty);



PWM2_Init(15000);
C1ON_bit = 0;
pump_duty = 0;
PWM2_Start();
PWM2_Set_Duty(pump_duty);



PIE1.RC1IE = 1;
PIE3.RC2IE = 1;
INTCON.PEIE = 1;
INTCON.GIE = 1;

for(;;)
 {
 read_analogue();
 mass_flow = Average(sensor_output,_Avg_Output);
 FlowValue = (mass_flow * 0.3961) - 206.4;
 air_flow = Average(sensor_output4, _Avg_Air);
 AirValue = (air_flow * 0.396) - 202.8;
 pressure0 = Average(sensor_output2, _Avg_Pressure0);
 pressure1 = Average(sensor_output3, _Avg_Pressure1);
 PressureValue0 = (2.09 * pressure0) - 5245.6;
 PressureValue1 = (2.09 * pressure1) - 5245.9;
#line 157 "C:/Users/Ed Phillips/Documents/Organox/O2_project/O2_control.c"
 O2_controller();
 pressure_controller();

 Counter++;

 if(Counter == 50) {
 Counter = 0;
 sprintf(String, "%f, %f, %f, %f, %d\r\n",(float)FlowValue,(float)PressureValue0, (float)PressureValue1, (float)set_flow, (int)pump_duty);
 UART2_Write_Text(String);
 }

 Delay_ms(10);
 }
}
