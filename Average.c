/*This function returns the moving average based upon 30 samples */

unsigned long Average(unsigned long Data, unsigned long Array[])
{ if (Array[1] == 0) Array[1] = 2;
 Array[0] += Data;
 Array[0] -= Array[Array[1]];
 Array[Array[1]] = Data;
 Array[1]++;
 if (Array[1] > 127) Array[1] = 2;
 return (Array[0]/126);
}