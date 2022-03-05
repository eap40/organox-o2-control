
_Average:

;Average.c,3 :: 		unsigned long Average(unsigned long Data, unsigned long Array[])
;Average.c,4 :: 		{ if (Array[1] == 0) Array[1] = 2;
	MOVLW       4
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R0 
	XORWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Average3
	MOVF        R0, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Average3
	MOVF        R0, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Average3
	MOVF        R1, 0 
	XORLW       0
L__Average3:
	BTFSS       STATUS+0, 2 
	GOTO        L_Average0
	MOVLW       4
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR1H 
	MOVLW       2
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
L_Average0:
;Average.c,5 :: 		Array[0] += Data;
	MOVFF       FARG_Average_Array+0, FSR0
	MOVFF       FARG_Average_Array+1, FSR0H
	MOVFF       FARG_Average_Array+0, FSR1
	MOVFF       FARG_Average_Array+1, FSR1H
	MOVF        FARG_Average_Data+0, 0 
	ADDWF       POSTINC1+0, 1 
	MOVF        FARG_Average_Data+1, 0 
	ADDWFC      POSTINC1+0, 1 
	MOVF        FARG_Average_Data+2, 0 
	ADDWFC      POSTINC1+0, 1 
	MOVF        FARG_Average_Data+3, 0 
	ADDWFC      POSTINC1+0, 1 
;Average.c,6 :: 		Array[0] -= Array[Array[1]];
	MOVLW       4
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR2 
	MOVF        R1, 0 
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR2H 
	MOVFF       FARG_Average_Array+0, FSR0
	MOVFF       FARG_Average_Array+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC2+0, 0 
	SUBWF       R0, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      R1, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      R2, 1 
	MOVF        POSTINC2+0, 0 
	SUBWFB      R3, 1 
	MOVFF       FARG_Average_Array+0, FSR1
	MOVFF       FARG_Average_Array+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;Average.c,7 :: 		Array[Array[1]] = Data;
	MOVLW       4
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR1 
	MOVF        R1, 0 
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_Average_Data+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_Average_Data+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_Average_Data+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        FARG_Average_Data+3, 0 
	MOVWF       POSTINC1+0 
;Average.c,8 :: 		Array[1]++;
	MOVLW       4
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       R4 
	MOVLW       0
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       R5 
	MOVFF       R4, FSR0
	MOVFF       R5, FSR0H
	MOVLW       1
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      POSTINC0+0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      POSTINC0+0, 0 
	MOVWF       R3 
	MOVFF       R4, FSR1
	MOVFF       R5, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;Average.c,9 :: 		if (Array[1] > 127) Array[1] = 2;
	MOVLW       4
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVF        R4, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Average4
	MOVF        R3, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Average4
	MOVF        R2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Average4
	MOVF        R1, 0 
	SUBLW       127
L__Average4:
	BTFSC       STATUS+0, 0 
	GOTO        L_Average1
	MOVLW       4
	ADDWF       FARG_Average_Array+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_Average_Array+1, 0 
	MOVWF       FSR1H 
	MOVLW       2
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
	MOVWF       POSTINC1+0 
L_Average1:
;Average.c,10 :: 		return (Array[0]/126);
	MOVFF       FARG_Average_Array+0, FSR0
	MOVFF       FARG_Average_Array+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       126
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
;Average.c,11 :: 		}
L_end_Average:
	RETURN      0
; end of _Average
