// This function reads 2 analogue inputs.  Results are in millivolts
// ADC configuration must be set in the calling function

//

extern unsigned long sensor_output, sensor_output2, sensor_output3, sensor_output4;     //Analogue inputs

 void read_analogue () {
 
  unsigned long Vin;  //temp input value
  unsigned long Vin2;
  unsigned long Vin3;
  unsigned long Vin4;
 
  Vin = ADC_Read(0);  // read ADC0 for mass flow
  sensor_output = (Vin * 5000) >>10;  // mV = Vin x 5000/1024   10bit ADC
  
  Vin2 = ADC_Read(1); // read ADC1 for pressure reading   1
  sensor_output2 = (Vin2 * 5000)>>10;
  
  Vin3 = ADC_Read(2); // read ADC2 for pressure reading 2
  sensor_output3 = (Vin3 * 5000)>>10;
  
  Vin4 = ADC_Read(3); // read ADC3 for mass flow sensor 2
  sensor_output4 = (Vin4 * 5000)>>10;
  return;
 }