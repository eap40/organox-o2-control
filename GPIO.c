// This function reads and sets the digital inputs and ouputs including two PWM channels

/*GPIO: Air_Valve,RB0; Air_Pump1,RB1; Air_Pump2,RB2; Sounder,RB3; Heat/Cool,RB4
   GPIO: START_Button, RD0; STOP_Button, RD1; SYS Power LED, RD6; Perfusion_Started, RD7
   PWM: O2_Valve, RC1; Heater_Power, RC2  */

// NOTES:  Channels assigned to membrane keypad cannot generate interrupts and will need to be polled
//         for the timebeing these are not enabled and the funtion does not return any values.

//extern unsigned short GPIO_config;  // GPIO Output configuration byte   Air_Valve; Air_Pump1; Air_Pump2; Sounder; Heat/Cool
extern int valve_duty;   // O2 valve setting
extern unsigned short pump_duty; //air pump setting
extern float set_flow, FlowValue, PressureValue1, PressureValue0, AirValue;
//extern unsigned short pump_duty;   // Air pump setting

extern char usermsg[];
extern unsigned int control_state, control_counter;


 void GPIO() {  //function for user to set PWM outputs
  short duty1;
  char buf2[8];

        strncpy(buf2,&usermsg[0],3);
        buf2[4] = 0;
        valve_duty = (short)atoi(buf2);
        //valve_duty = pressure/4;

        strncpy(buf2,&usermsg[3],3);
        buf2[4] = 0;
        pump_duty = (short)atoi(buf2);


 //duty1 =  pump_duty;
 //if(duty1 < 128 ) duty1 = 128;   // lower limit the duty on heater
  PWM2_Set_Duty(pump_duty);        // Set current duty for PWM2 // set air pump pwm
  if (valve_duty>255) valve_duty=255; //impose limits
  if (valve_duty<0) valve_duty=0;
  PWM1_Set_Duty(valve_duty);        // Set current duty for PWM1 // set O2 pwm
 
 
  return;
 }
 
 void air_controller(){//function to control air pump PWM based on a set flow
      char buf2[8];
      double error;
      double diff = 0.0;
      float k_p = 0.5;
      float k_i = 0.005;
      float k_d = 0.005;
      static double integral=0.0;
      static double last_error = 0.0;

      strncpy(buf2,&usermsg[0],3);
      buf2[4] = 0;
      control_state = (short)atoi(buf2);//this code for user input to toggle controller

      if (control_state==0) return;

      /*strncpy(buf2, &usermsg[0], 5);
      buf2[6]=0;
      set_flow = atof(buf2);*/
      error = set_flow - AirValue;
      diff = error - last_error;
      if (fabs(error) < 100.0) integral += error;
      pump_duty = (int)floor((k_p * error) + (k_i * integral) + (k_d * diff) + 0.5) +55; //air pump response starts at 55
      if (pump_duty < 0) pump_duty=0; //limit pump duty
      if (pump_duty >255) pump_duty=255;
      PWM2_Set_Duty(pump_duty);
      return;
}

void O2_controller(){//function to adjust O2 valve PWM duty in response to set flow
     char buf2[8];
     double error;
     float k_p = 8.0;
     float k_i = 0.1;
     float k_d = 15.0;
     double diff = 0.0;
     static double integral=0.0;
     static double last_error = 0.0;
     
     /*strncpy(buf2, &usermsg[0], 5);
     buf2[6]=0;
     set_flow = atof(buf2);*/
     strncpy(buf2,&usermsg[0],3);
     buf2[4] = 0;
     control_state = (short)atoi(buf2);//this code for user input to toggle controller

     if (control_state==0) return;
     /*
     control_counter++;
     if (control_counter==1500){//increment every 40 readings, ~20 seconds
       control_counter=0;
       set_flow+=5.0;
       if (set_flow > 15.0) set_flow=0.0;
      }*/
     
     error = set_flow - FlowValue;
     diff = error - last_error;
     if (fabs(error)<20.0) integral += error;//avoid adding large values when controller initialises
     valve_duty = (int)floor((k_p * error) + (k_i * integral) + (k_d * diff) + 0.5) +88;//add minimum PWM value from mvo test here
     if (valve_duty < 0) valve_duty=0;
     if (valve_duty >255) valve_duty=255;
     PWM1_Set_Duty(valve_duty);
     
     last_error = error;
     return;
}

void pressure_controller(){//function to regulate pressure in secondary bottle
     /*char buf2[8];
     strncpy(buf2,&usermsg[0],3);
     buf2[4] = 0;
     pump_duty = (short)atoi(buf2);*/
     float p_min = 20.0; //secondary pressure limits
     float p_max = 250.0;
     float d_min = 20.0;//primary/secondary pressure difference limits
     float d_max = 30.0;
     static int valve_state=0;
     float difference;
     
     //code for secondary pressure control
     /*if (PressureValue1 < p_min && valve_state==0){
        pump_duty=200;
        valve_state=1;
     }
     
     if (PressureValue1 > p_max && valve_state==1){
        pump_duty=0;
        valve_state=0;
     }               
     PWM2_Set_Duty(pump_duty);*/
     
     //code for differential pressure control
     difference = PressureValue0 - PressureValue1;
     if (PressureValue1 > p_max && valve_state==1){
        pump_duty = 0;
        valve_state=0;
        PORTC.B3 = 0;
        PWM2_Set_Duty(pump_duty);
        return;
        }
     else if (PressureValue1 < p_min){
          pump_duty=200;
          valve_state=1;
          PORTC.B3=1;
          PWM2_Set_Duty(pump_duty);
          return;
          }
          
     else if (PressureValue1 < p_max && difference > d_max && valve_state==0){
        pump_duty=200;
        valve_state=1;
        PORTC.B3=1;
        PWM2_Set_Duty(pump_duty);
        return;
        }
        
     else if (difference < d_min && valve_state==1){
        pump_duty=0;
        valve_state=0;
        PORTC.B3=0;
        PWM2_Set_Duty(pump_duty);
        return;
        }
     return;
}