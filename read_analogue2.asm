
_read_analogue:

;read_analogue2.c,8 :: 		void read_analogue () {
;read_analogue2.c,15 :: 		Vin = ADC_Read(0);  // read ADC0 for mass flow
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_analogue_Vin_L0+0 
	MOVF        R1, 0 
	MOVWF       read_analogue_Vin_L0+1 
	MOVLW       0
	MOVWF       read_analogue_Vin_L0+2 
	MOVWF       read_analogue_Vin_L0+3 
;read_analogue2.c,16 :: 		sensor_output = (Vin * 5000) >>10;  // mV = Vin x 5000/1024   10bit ADC
	MOVF        read_analogue_Vin_L0+0, 0 
	MOVWF       R0 
	MOVF        read_analogue_Vin_L0+1, 0 
	MOVWF       R1 
	MOVF        read_analogue_Vin_L0+2, 0 
	MOVWF       R2 
	MOVF        read_analogue_Vin_L0+3, 0 
	MOVWF       R3 
	MOVLW       136
	MOVWF       R4 
	MOVLW       19
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVF        R0, 0 
	MOVWF       _sensor_output+0 
	MOVF        R1, 0 
	MOVWF       _sensor_output+1 
	MOVF        R2, 0 
	MOVWF       _sensor_output+2 
	MOVF        R3, 0 
	MOVWF       _sensor_output+3 
	MOVF        R4, 0 
L__read_analogue1:
	BZ          L__read_analogue2
	RRCF        _sensor_output+3, 1 
	RRCF        _sensor_output+2, 1 
	RRCF        _sensor_output+1, 1 
	RRCF        _sensor_output+0, 1 
	BCF         _sensor_output+3, 7 
	ADDLW       255
	GOTO        L__read_analogue1
L__read_analogue2:
;read_analogue2.c,18 :: 		Vin2 = ADC_Read(1); // read ADC1 for pressure reading   1
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_analogue_Vin2_L0+0 
	MOVF        R1, 0 
	MOVWF       read_analogue_Vin2_L0+1 
	MOVLW       0
	MOVWF       read_analogue_Vin2_L0+2 
	MOVWF       read_analogue_Vin2_L0+3 
;read_analogue2.c,19 :: 		sensor_output2 = (Vin2 * 5000)>>10;
	MOVF        read_analogue_Vin2_L0+0, 0 
	MOVWF       R0 
	MOVF        read_analogue_Vin2_L0+1, 0 
	MOVWF       R1 
	MOVF        read_analogue_Vin2_L0+2, 0 
	MOVWF       R2 
	MOVF        read_analogue_Vin2_L0+3, 0 
	MOVWF       R3 
	MOVLW       136
	MOVWF       R4 
	MOVLW       19
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVF        R0, 0 
	MOVWF       _sensor_output2+0 
	MOVF        R1, 0 
	MOVWF       _sensor_output2+1 
	MOVF        R2, 0 
	MOVWF       _sensor_output2+2 
	MOVF        R3, 0 
	MOVWF       _sensor_output2+3 
	MOVF        R4, 0 
L__read_analogue3:
	BZ          L__read_analogue4
	RRCF        _sensor_output2+3, 1 
	RRCF        _sensor_output2+2, 1 
	RRCF        _sensor_output2+1, 1 
	RRCF        _sensor_output2+0, 1 
	BCF         _sensor_output2+3, 7 
	ADDLW       255
	GOTO        L__read_analogue3
L__read_analogue4:
;read_analogue2.c,21 :: 		Vin3 = ADC_Read(2); // read ADC2 for pressure reading 2
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_analogue_Vin3_L0+0 
	MOVF        R1, 0 
	MOVWF       read_analogue_Vin3_L0+1 
	MOVLW       0
	MOVWF       read_analogue_Vin3_L0+2 
	MOVWF       read_analogue_Vin3_L0+3 
;read_analogue2.c,22 :: 		sensor_output3 = (Vin3 * 5000)>>10;
	MOVF        read_analogue_Vin3_L0+0, 0 
	MOVWF       R0 
	MOVF        read_analogue_Vin3_L0+1, 0 
	MOVWF       R1 
	MOVF        read_analogue_Vin3_L0+2, 0 
	MOVWF       R2 
	MOVF        read_analogue_Vin3_L0+3, 0 
	MOVWF       R3 
	MOVLW       136
	MOVWF       R4 
	MOVLW       19
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVF        R0, 0 
	MOVWF       _sensor_output3+0 
	MOVF        R1, 0 
	MOVWF       _sensor_output3+1 
	MOVF        R2, 0 
	MOVWF       _sensor_output3+2 
	MOVF        R3, 0 
	MOVWF       _sensor_output3+3 
	MOVF        R4, 0 
L__read_analogue5:
	BZ          L__read_analogue6
	RRCF        _sensor_output3+3, 1 
	RRCF        _sensor_output3+2, 1 
	RRCF        _sensor_output3+1, 1 
	RRCF        _sensor_output3+0, 1 
	BCF         _sensor_output3+3, 7 
	ADDLW       255
	GOTO        L__read_analogue5
L__read_analogue6:
;read_analogue2.c,24 :: 		Vin4 = ADC_Read(3); // read ADC3 for mass flow sensor 2
	MOVLW       3
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       read_analogue_Vin4_L0+0 
	MOVF        R1, 0 
	MOVWF       read_analogue_Vin4_L0+1 
	MOVLW       0
	MOVWF       read_analogue_Vin4_L0+2 
	MOVWF       read_analogue_Vin4_L0+3 
;read_analogue2.c,25 :: 		sensor_output4 = (Vin4 * 5000)>>10;
	MOVF        read_analogue_Vin4_L0+0, 0 
	MOVWF       R0 
	MOVF        read_analogue_Vin4_L0+1, 0 
	MOVWF       R1 
	MOVF        read_analogue_Vin4_L0+2, 0 
	MOVWF       R2 
	MOVF        read_analogue_Vin4_L0+3, 0 
	MOVWF       R3 
	MOVLW       136
	MOVWF       R4 
	MOVLW       19
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVF        R0, 0 
	MOVWF       _sensor_output4+0 
	MOVF        R1, 0 
	MOVWF       _sensor_output4+1 
	MOVF        R2, 0 
	MOVWF       _sensor_output4+2 
	MOVF        R3, 0 
	MOVWF       _sensor_output4+3 
	MOVF        R4, 0 
L__read_analogue7:
	BZ          L__read_analogue8
	RRCF        _sensor_output4+3, 1 
	RRCF        _sensor_output4+2, 1 
	RRCF        _sensor_output4+1, 1 
	RRCF        _sensor_output4+0, 1 
	BCF         _sensor_output4+3, 7 
	ADDLW       255
	GOTO        L__read_analogue7
L__read_analogue8:
;read_analogue2.c,26 :: 		return;
;read_analogue2.c,27 :: 		}
L_end_read_analogue:
	RETURN      0
; end of _read_analogue
