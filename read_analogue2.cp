#line 1 "C:/Users/Ed Phillips/Documents/Organox/O2_project/read_analogue2.c"





extern unsigned long sensor_output, sensor_output2, sensor_output3, sensor_output4;

 void read_analogue () {

 unsigned long Vin;
 unsigned long Vin2;
 unsigned long Vin3;
 unsigned long Vin4;

 Vin = ADC_Read(0);
 sensor_output = (Vin * 5000) >>10;

 Vin2 = ADC_Read(1);
 sensor_output2 = (Vin2 * 5000)>>10;

 Vin3 = ADC_Read(2);
 sensor_output3 = (Vin3 * 5000)>>10;

 Vin4 = ADC_Read(3);
 sensor_output4 = (Vin4 * 5000)>>10;
 return;
 }
