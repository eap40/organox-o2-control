#line 1 "C:/Users/Ed Phillips/Documents/Organox/O2_project/GPIO.c"
#line 11 "C:/Users/Ed Phillips/Documents/Organox/O2_project/GPIO.c"
extern int valve_duty;
extern unsigned short pump_duty;
extern float set_flow, FlowValue, PressureValue1, PressureValue0, AirValue;


extern char usermsg[];
extern unsigned int control_state, control_counter;


 void GPIO() {
 short duty1;
 char buf2[8];

 strncpy(buf2,&usermsg[0],3);
 buf2[4] = 0;
 valve_duty = (short)atoi(buf2);


 strncpy(buf2,&usermsg[3],3);
 buf2[4] = 0;
 pump_duty = (short)atoi(buf2);




 PWM2_Set_Duty(pump_duty);
 if (valve_duty>255) valve_duty=255;
 if (valve_duty<0) valve_duty=0;
 PWM1_Set_Duty(valve_duty);


 return;
 }

 void air_controller(){
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
 control_state = (short)atoi(buf2);

 if (control_state==0) return;
#line 64 "C:/Users/Ed Phillips/Documents/Organox/O2_project/GPIO.c"
 error = set_flow - AirValue;
 diff = error - last_error;
 if (fabs(error) < 100.0) integral += error;
 pump_duty = (int)floor((k_p * error) + (k_i * integral) + (k_d * diff) + 0.5) +55;
 if (pump_duty < 0) pump_duty=0;
 if (pump_duty >255) pump_duty=255;
 PWM2_Set_Duty(pump_duty);
 return;
}

void O2_controller(){
 char buf2[8];
 double error;
 float k_p = 8.0;
 float k_i = 0.1;
 float k_d = 15.0;
 double diff = 0.0;
 static double integral=0.0;
 static double last_error = 0.0;
#line 87 "C:/Users/Ed Phillips/Documents/Organox/O2_project/GPIO.c"
 strncpy(buf2,&usermsg[0],3);
 buf2[4] = 0;
 control_state = (short)atoi(buf2);

 if (control_state==0) return;
#line 100 "C:/Users/Ed Phillips/Documents/Organox/O2_project/GPIO.c"
 error = set_flow - FlowValue;
 diff = error - last_error;
 if (fabs(error)<20.0) integral += error;
 valve_duty = (int)floor((k_p * error) + (k_i * integral) + (k_d * diff) + 0.5) +88;
 if (valve_duty < 0) valve_duty=0;
 if (valve_duty >255) valve_duty=255;
 PWM1_Set_Duty(valve_duty);

 last_error = error;
 return;
}

void pressure_controller(){
#line 117 "C:/Users/Ed Phillips/Documents/Organox/O2_project/GPIO.c"
 float p_min = 20.0;
 float p_max = 250.0;
 float d_min = 20.0;
 float d_max = 30.0;
 static int valve_state=0;
 float difference;
#line 137 "C:/Users/Ed Phillips/Documents/Organox/O2_project/GPIO.c"
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
