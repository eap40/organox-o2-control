
_GPIO:

;GPIO.c,20 :: 		void GPIO() {
;GPIO.c,24 :: 		strncpy(buf2,&usermsg[0],3);
	MOVLW       GPIO_buf2_L0+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(GPIO_buf2_L0+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _usermsg+0
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_usermsg+0)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
;GPIO.c,25 :: 		buf2[4] = 0;
	CLRF        GPIO_buf2_L0+4 
;GPIO.c,26 :: 		valve_duty = (short)atoi(buf2);
	MOVLW       GPIO_buf2_L0+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(GPIO_buf2_L0+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _valve_duty+0 
	MOVLW       0
	BTFSC       R0, 7 
	MOVLW       255
	MOVWF       _valve_duty+1 
;GPIO.c,29 :: 		strncpy(buf2,&usermsg[3],3);
	MOVLW       GPIO_buf2_L0+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(GPIO_buf2_L0+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _usermsg+3
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_usermsg+3)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
;GPIO.c,30 :: 		buf2[4] = 0;
	CLRF        GPIO_buf2_L0+4 
;GPIO.c,31 :: 		pump_duty = (short)atoi(buf2);
	MOVLW       GPIO_buf2_L0+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(GPIO_buf2_L0+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _pump_duty+0 
;GPIO.c,36 :: 		PWM2_Set_Duty(pump_duty);        // Set current duty for PWM2 // set air pump pwm
	MOVF        R0, 0 
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;GPIO.c,37 :: 		if (valve_duty>255) valve_duty=255; //impose limits
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _valve_duty+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GPIO27
	MOVF        _valve_duty+0, 0 
	SUBLW       255
L__GPIO27:
	BTFSC       STATUS+0, 0 
	GOTO        L_GPIO0
	MOVLW       255
	MOVWF       _valve_duty+0 
	MOVLW       0
	MOVWF       _valve_duty+1 
L_GPIO0:
;GPIO.c,38 :: 		if (valve_duty<0) valve_duty=0;
	MOVLW       128
	XORWF       _valve_duty+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GPIO28
	MOVLW       0
	SUBWF       _valve_duty+0, 0 
L__GPIO28:
	BTFSC       STATUS+0, 0 
	GOTO        L_GPIO1
	CLRF        _valve_duty+0 
	CLRF        _valve_duty+1 
L_GPIO1:
;GPIO.c,39 :: 		PWM1_Set_Duty(valve_duty);        // Set current duty for PWM1 // set O2 pwm
	MOVF        _valve_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;GPIO.c,42 :: 		return;
;GPIO.c,43 :: 		}
L_end_GPIO:
	RETURN      0
; end of _GPIO

_air_controller:

;GPIO.c,45 :: 		void air_controller(){//function to adjust the air pump pwm in response to user input
;GPIO.c,48 :: 		double diff = 0.0;
	CLRF        air_controller_diff_L0+0 
	CLRF        air_controller_diff_L0+1 
	CLRF        air_controller_diff_L0+2 
	CLRF        air_controller_diff_L0+3 
	MOVLW       0
	MOVWF       air_controller_k_p_L0+0 
	MOVLW       0
	MOVWF       air_controller_k_p_L0+1 
	MOVLW       0
	MOVWF       air_controller_k_p_L0+2 
	MOVLW       126
	MOVWF       air_controller_k_p_L0+3 
	MOVLW       10
	MOVWF       air_controller_k_i_L0+0 
	MOVLW       215
	MOVWF       air_controller_k_i_L0+1 
	MOVLW       35
	MOVWF       air_controller_k_i_L0+2 
	MOVLW       119
	MOVWF       air_controller_k_i_L0+3 
	MOVLW       10
	MOVWF       air_controller_k_d_L0+0 
	MOVLW       215
	MOVWF       air_controller_k_d_L0+1 
	MOVLW       35
	MOVWF       air_controller_k_d_L0+2 
	MOVLW       119
	MOVWF       air_controller_k_d_L0+3 
;GPIO.c,55 :: 		strncpy(buf2,&usermsg[0],3);
	MOVLW       air_controller_buf2_L0+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(air_controller_buf2_L0+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _usermsg+0
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_usermsg+0)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
;GPIO.c,56 :: 		buf2[4] = 0;
	CLRF        air_controller_buf2_L0+4 
;GPIO.c,57 :: 		control_state = (short)atoi(buf2);//this code for user input to toggle controller
	MOVLW       air_controller_buf2_L0+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(air_controller_buf2_L0+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _control_state+0 
	MOVLW       0
	BTFSC       R0, 7 
	MOVLW       255
	MOVWF       _control_state+1 
;GPIO.c,59 :: 		if (control_state==0) return;
	MOVLW       0
	XORWF       _control_state+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__air_controller30
	MOVLW       0
	XORWF       _control_state+0, 0 
L__air_controller30:
	BTFSS       STATUS+0, 2 
	GOTO        L_air_controller2
	GOTO        L_end_air_controller
L_air_controller2:
;GPIO.c,64 :: 		error = set_flow - AirValue;
	MOVF        _AirValue+0, 0 
	MOVWF       R4 
	MOVF        _AirValue+1, 0 
	MOVWF       R5 
	MOVF        _AirValue+2, 0 
	MOVWF       R6 
	MOVF        _AirValue+3, 0 
	MOVWF       R7 
	MOVF        _set_flow+0, 0 
	MOVWF       R0 
	MOVF        _set_flow+1, 0 
	MOVWF       R1 
	MOVF        _set_flow+2, 0 
	MOVWF       R2 
	MOVF        _set_flow+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__air_controller+0 
	MOVF        R1, 0 
	MOVWF       FLOC__air_controller+1 
	MOVF        R2, 0 
	MOVWF       FLOC__air_controller+2 
	MOVF        R3, 0 
	MOVWF       FLOC__air_controller+3 
	MOVF        FLOC__air_controller+0, 0 
	MOVWF       air_controller_error_L0+0 
	MOVF        FLOC__air_controller+1, 0 
	MOVWF       air_controller_error_L0+1 
	MOVF        FLOC__air_controller+2, 0 
	MOVWF       air_controller_error_L0+2 
	MOVF        FLOC__air_controller+3, 0 
	MOVWF       air_controller_error_L0+3 
;GPIO.c,65 :: 		diff = error - last_error;
	MOVF        air_controller_last_error_L0+0, 0 
	MOVWF       R4 
	MOVF        air_controller_last_error_L0+1, 0 
	MOVWF       R5 
	MOVF        air_controller_last_error_L0+2, 0 
	MOVWF       R6 
	MOVF        air_controller_last_error_L0+3, 0 
	MOVWF       R7 
	MOVF        FLOC__air_controller+0, 0 
	MOVWF       R0 
	MOVF        FLOC__air_controller+1, 0 
	MOVWF       R1 
	MOVF        FLOC__air_controller+2, 0 
	MOVWF       R2 
	MOVF        FLOC__air_controller+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       air_controller_diff_L0+0 
	MOVF        R1, 0 
	MOVWF       air_controller_diff_L0+1 
	MOVF        R2, 0 
	MOVWF       air_controller_diff_L0+2 
	MOVF        R3, 0 
	MOVWF       air_controller_diff_L0+3 
;GPIO.c,66 :: 		if (fabs(error) < 100.0) integral += error;
	MOVF        FLOC__air_controller+0, 0 
	MOVWF       FARG_fabs_d+0 
	MOVF        FLOC__air_controller+1, 0 
	MOVWF       FARG_fabs_d+1 
	MOVF        FLOC__air_controller+2, 0 
	MOVWF       FARG_fabs_d+2 
	MOVF        FLOC__air_controller+3, 0 
	MOVWF       FARG_fabs_d+3 
	CALL        _fabs+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_air_controller3
	MOVF        air_controller_integral_L0+0, 0 
	MOVWF       R0 
	MOVF        air_controller_integral_L0+1, 0 
	MOVWF       R1 
	MOVF        air_controller_integral_L0+2, 0 
	MOVWF       R2 
	MOVF        air_controller_integral_L0+3, 0 
	MOVWF       R3 
	MOVF        air_controller_error_L0+0, 0 
	MOVWF       R4 
	MOVF        air_controller_error_L0+1, 0 
	MOVWF       R5 
	MOVF        air_controller_error_L0+2, 0 
	MOVWF       R6 
	MOVF        air_controller_error_L0+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       air_controller_integral_L0+0 
	MOVF        R1, 0 
	MOVWF       air_controller_integral_L0+1 
	MOVF        R2, 0 
	MOVWF       air_controller_integral_L0+2 
	MOVF        R3, 0 
	MOVWF       air_controller_integral_L0+3 
L_air_controller3:
;GPIO.c,67 :: 		pump_duty = (int)floor((k_p * error) + (k_i * integral) + (k_d * diff) + 0.5) +55; //air pump response starts at 55
	MOVF        air_controller_k_p_L0+0, 0 
	MOVWF       R0 
	MOVF        air_controller_k_p_L0+1, 0 
	MOVWF       R1 
	MOVF        air_controller_k_p_L0+2, 0 
	MOVWF       R2 
	MOVF        air_controller_k_p_L0+3, 0 
	MOVWF       R3 
	MOVF        air_controller_error_L0+0, 0 
	MOVWF       R4 
	MOVF        air_controller_error_L0+1, 0 
	MOVWF       R5 
	MOVF        air_controller_error_L0+2, 0 
	MOVWF       R6 
	MOVF        air_controller_error_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__air_controller+0 
	MOVF        R1, 0 
	MOVWF       FLOC__air_controller+1 
	MOVF        R2, 0 
	MOVWF       FLOC__air_controller+2 
	MOVF        R3, 0 
	MOVWF       FLOC__air_controller+3 
	MOVF        air_controller_k_i_L0+0, 0 
	MOVWF       R0 
	MOVF        air_controller_k_i_L0+1, 0 
	MOVWF       R1 
	MOVF        air_controller_k_i_L0+2, 0 
	MOVWF       R2 
	MOVF        air_controller_k_i_L0+3, 0 
	MOVWF       R3 
	MOVF        air_controller_integral_L0+0, 0 
	MOVWF       R4 
	MOVF        air_controller_integral_L0+1, 0 
	MOVWF       R5 
	MOVF        air_controller_integral_L0+2, 0 
	MOVWF       R6 
	MOVF        air_controller_integral_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__air_controller+0, 0 
	MOVWF       R4 
	MOVF        FLOC__air_controller+1, 0 
	MOVWF       R5 
	MOVF        FLOC__air_controller+2, 0 
	MOVWF       R6 
	MOVF        FLOC__air_controller+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__air_controller+0 
	MOVF        R1, 0 
	MOVWF       FLOC__air_controller+1 
	MOVF        R2, 0 
	MOVWF       FLOC__air_controller+2 
	MOVF        R3, 0 
	MOVWF       FLOC__air_controller+3 
	MOVF        air_controller_k_d_L0+0, 0 
	MOVWF       R0 
	MOVF        air_controller_k_d_L0+1, 0 
	MOVWF       R1 
	MOVF        air_controller_k_d_L0+2, 0 
	MOVWF       R2 
	MOVF        air_controller_k_d_L0+3, 0 
	MOVWF       R3 
	MOVF        air_controller_diff_L0+0, 0 
	MOVWF       R4 
	MOVF        air_controller_diff_L0+1, 0 
	MOVWF       R5 
	MOVF        air_controller_diff_L0+2, 0 
	MOVWF       R6 
	MOVF        air_controller_diff_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__air_controller+0, 0 
	MOVWF       R4 
	MOVF        FLOC__air_controller+1, 0 
	MOVWF       R5 
	MOVF        FLOC__air_controller+2, 0 
	MOVWF       R6 
	MOVF        FLOC__air_controller+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_floor_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_floor_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_floor_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_floor_x+3 
	CALL        _floor+0, 0
	CALL        _double2int+0, 0
	MOVLW       55
	ADDWF       R0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       _pump_duty+0 
;GPIO.c,68 :: 		if (pump_duty < 0) pump_duty=0; //limit pump duty
	MOVLW       0
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_air_controller4
	CLRF        _pump_duty+0 
L_air_controller4:
;GPIO.c,69 :: 		if (pump_duty >255) pump_duty=255;
	MOVF        _pump_duty+0, 0 
	SUBLW       255
	BTFSC       STATUS+0, 0 
	GOTO        L_air_controller5
	MOVLW       255
	MOVWF       _pump_duty+0 
L_air_controller5:
;GPIO.c,70 :: 		PWM2_Set_Duty(pump_duty);
	MOVF        _pump_duty+0, 0 
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;GPIO.c,71 :: 		return;
;GPIO.c,72 :: 		}
L_end_air_controller:
	RETURN      0
; end of _air_controller

_O2_controller:

;GPIO.c,74 :: 		void O2_controller(){//function to adjust valve PWM duty in response to user set flow
;GPIO.c,77 :: 		float k_p = 8.0;
	MOVLW       0
	MOVWF       O2_controller_k_p_L0+0 
	MOVLW       0
	MOVWF       O2_controller_k_p_L0+1 
	MOVLW       0
	MOVWF       O2_controller_k_p_L0+2 
	MOVLW       130
	MOVWF       O2_controller_k_p_L0+3 
	MOVLW       205
	MOVWF       O2_controller_k_i_L0+0 
	MOVLW       204
	MOVWF       O2_controller_k_i_L0+1 
	MOVLW       76
	MOVWF       O2_controller_k_i_L0+2 
	MOVLW       123
	MOVWF       O2_controller_k_i_L0+3 
	MOVLW       0
	MOVWF       O2_controller_k_d_L0+0 
	MOVLW       0
	MOVWF       O2_controller_k_d_L0+1 
	MOVLW       112
	MOVWF       O2_controller_k_d_L0+2 
	MOVLW       130
	MOVWF       O2_controller_k_d_L0+3 
	CLRF        O2_controller_diff_L0+0 
	CLRF        O2_controller_diff_L0+1 
	CLRF        O2_controller_diff_L0+2 
	CLRF        O2_controller_diff_L0+3 
;GPIO.c,87 :: 		strncpy(buf2,&usermsg[0],3);
	MOVLW       O2_controller_buf2_L0+0
	MOVWF       FARG_strncpy_to+0 
	MOVLW       hi_addr(O2_controller_buf2_L0+0)
	MOVWF       FARG_strncpy_to+1 
	MOVLW       _usermsg+0
	MOVWF       FARG_strncpy_from+0 
	MOVLW       hi_addr(_usermsg+0)
	MOVWF       FARG_strncpy_from+1 
	MOVLW       3
	MOVWF       FARG_strncpy_size+0 
	MOVLW       0
	MOVWF       FARG_strncpy_size+1 
	CALL        _strncpy+0, 0
;GPIO.c,88 :: 		buf2[4] = 0;
	CLRF        O2_controller_buf2_L0+4 
;GPIO.c,89 :: 		control_state = (short)atoi(buf2);//this code for user input to toggle controller
	MOVLW       O2_controller_buf2_L0+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(O2_controller_buf2_L0+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       _control_state+0 
	MOVLW       0
	BTFSC       R0, 7 
	MOVLW       255
	MOVWF       _control_state+1 
;GPIO.c,91 :: 		if (control_state==0) return;
	MOVLW       0
	XORWF       _control_state+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__O2_controller32
	MOVLW       0
	XORWF       _control_state+0, 0 
L__O2_controller32:
	BTFSS       STATUS+0, 2 
	GOTO        L_O2_controller6
	GOTO        L_end_O2_controller
L_O2_controller6:
;GPIO.c,100 :: 		error = set_flow - FlowValue;
	MOVF        _FlowValue+0, 0 
	MOVWF       R4 
	MOVF        _FlowValue+1, 0 
	MOVWF       R5 
	MOVF        _FlowValue+2, 0 
	MOVWF       R6 
	MOVF        _FlowValue+3, 0 
	MOVWF       R7 
	MOVF        _set_flow+0, 0 
	MOVWF       R0 
	MOVF        _set_flow+1, 0 
	MOVWF       R1 
	MOVF        _set_flow+2, 0 
	MOVWF       R2 
	MOVF        _set_flow+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__O2_controller+0 
	MOVF        R1, 0 
	MOVWF       FLOC__O2_controller+1 
	MOVF        R2, 0 
	MOVWF       FLOC__O2_controller+2 
	MOVF        R3, 0 
	MOVWF       FLOC__O2_controller+3 
	MOVF        FLOC__O2_controller+0, 0 
	MOVWF       O2_controller_error_L0+0 
	MOVF        FLOC__O2_controller+1, 0 
	MOVWF       O2_controller_error_L0+1 
	MOVF        FLOC__O2_controller+2, 0 
	MOVWF       O2_controller_error_L0+2 
	MOVF        FLOC__O2_controller+3, 0 
	MOVWF       O2_controller_error_L0+3 
;GPIO.c,101 :: 		diff = error - last_error;
	MOVF        O2_controller_last_error_L0+0, 0 
	MOVWF       R4 
	MOVF        O2_controller_last_error_L0+1, 0 
	MOVWF       R5 
	MOVF        O2_controller_last_error_L0+2, 0 
	MOVWF       R6 
	MOVF        O2_controller_last_error_L0+3, 0 
	MOVWF       R7 
	MOVF        FLOC__O2_controller+0, 0 
	MOVWF       R0 
	MOVF        FLOC__O2_controller+1, 0 
	MOVWF       R1 
	MOVF        FLOC__O2_controller+2, 0 
	MOVWF       R2 
	MOVF        FLOC__O2_controller+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       O2_controller_diff_L0+0 
	MOVF        R1, 0 
	MOVWF       O2_controller_diff_L0+1 
	MOVF        R2, 0 
	MOVWF       O2_controller_diff_L0+2 
	MOVF        R3, 0 
	MOVWF       O2_controller_diff_L0+3 
;GPIO.c,102 :: 		if (fabs(error)<20.0) integral += error;//avoid adding large values when controller initialises
	MOVF        FLOC__O2_controller+0, 0 
	MOVWF       FARG_fabs_d+0 
	MOVF        FLOC__O2_controller+1, 0 
	MOVWF       FARG_fabs_d+1 
	MOVF        FLOC__O2_controller+2, 0 
	MOVWF       FARG_fabs_d+2 
	MOVF        FLOC__O2_controller+3, 0 
	MOVWF       FARG_fabs_d+3 
	CALL        _fabs+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_O2_controller7
	MOVF        O2_controller_integral_L0+0, 0 
	MOVWF       R0 
	MOVF        O2_controller_integral_L0+1, 0 
	MOVWF       R1 
	MOVF        O2_controller_integral_L0+2, 0 
	MOVWF       R2 
	MOVF        O2_controller_integral_L0+3, 0 
	MOVWF       R3 
	MOVF        O2_controller_error_L0+0, 0 
	MOVWF       R4 
	MOVF        O2_controller_error_L0+1, 0 
	MOVWF       R5 
	MOVF        O2_controller_error_L0+2, 0 
	MOVWF       R6 
	MOVF        O2_controller_error_L0+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       O2_controller_integral_L0+0 
	MOVF        R1, 0 
	MOVWF       O2_controller_integral_L0+1 
	MOVF        R2, 0 
	MOVWF       O2_controller_integral_L0+2 
	MOVF        R3, 0 
	MOVWF       O2_controller_integral_L0+3 
L_O2_controller7:
;GPIO.c,103 :: 		valve_duty = (int)floor((k_p * error) + (k_i * integral) + (k_d * diff) + 0.5) +88;//add minimum PWM value from mvo test here
	MOVF        O2_controller_k_p_L0+0, 0 
	MOVWF       R0 
	MOVF        O2_controller_k_p_L0+1, 0 
	MOVWF       R1 
	MOVF        O2_controller_k_p_L0+2, 0 
	MOVWF       R2 
	MOVF        O2_controller_k_p_L0+3, 0 
	MOVWF       R3 
	MOVF        O2_controller_error_L0+0, 0 
	MOVWF       R4 
	MOVF        O2_controller_error_L0+1, 0 
	MOVWF       R5 
	MOVF        O2_controller_error_L0+2, 0 
	MOVWF       R6 
	MOVF        O2_controller_error_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__O2_controller+0 
	MOVF        R1, 0 
	MOVWF       FLOC__O2_controller+1 
	MOVF        R2, 0 
	MOVWF       FLOC__O2_controller+2 
	MOVF        R3, 0 
	MOVWF       FLOC__O2_controller+3 
	MOVF        O2_controller_k_i_L0+0, 0 
	MOVWF       R0 
	MOVF        O2_controller_k_i_L0+1, 0 
	MOVWF       R1 
	MOVF        O2_controller_k_i_L0+2, 0 
	MOVWF       R2 
	MOVF        O2_controller_k_i_L0+3, 0 
	MOVWF       R3 
	MOVF        O2_controller_integral_L0+0, 0 
	MOVWF       R4 
	MOVF        O2_controller_integral_L0+1, 0 
	MOVWF       R5 
	MOVF        O2_controller_integral_L0+2, 0 
	MOVWF       R6 
	MOVF        O2_controller_integral_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__O2_controller+0, 0 
	MOVWF       R4 
	MOVF        FLOC__O2_controller+1, 0 
	MOVWF       R5 
	MOVF        FLOC__O2_controller+2, 0 
	MOVWF       R6 
	MOVF        FLOC__O2_controller+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__O2_controller+0 
	MOVF        R1, 0 
	MOVWF       FLOC__O2_controller+1 
	MOVF        R2, 0 
	MOVWF       FLOC__O2_controller+2 
	MOVF        R3, 0 
	MOVWF       FLOC__O2_controller+3 
	MOVF        O2_controller_k_d_L0+0, 0 
	MOVWF       R0 
	MOVF        O2_controller_k_d_L0+1, 0 
	MOVWF       R1 
	MOVF        O2_controller_k_d_L0+2, 0 
	MOVWF       R2 
	MOVF        O2_controller_k_d_L0+3, 0 
	MOVWF       R3 
	MOVF        O2_controller_diff_L0+0, 0 
	MOVWF       R4 
	MOVF        O2_controller_diff_L0+1, 0 
	MOVWF       R5 
	MOVF        O2_controller_diff_L0+2, 0 
	MOVWF       R6 
	MOVF        O2_controller_diff_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__O2_controller+0, 0 
	MOVWF       R4 
	MOVF        FLOC__O2_controller+1, 0 
	MOVWF       R5 
	MOVF        FLOC__O2_controller+2, 0 
	MOVWF       R6 
	MOVF        FLOC__O2_controller+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_floor_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_floor_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_floor_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_floor_x+3 
	CALL        _floor+0, 0
	CALL        _double2int+0, 0
	MOVLW       88
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       _valve_duty+0 
	MOVF        R3, 0 
	MOVWF       _valve_duty+1 
;GPIO.c,104 :: 		if (valve_duty < 0) valve_duty=0;
	MOVLW       128
	XORWF       R3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__O2_controller33
	MOVLW       0
	SUBWF       R2, 0 
L__O2_controller33:
	BTFSC       STATUS+0, 0 
	GOTO        L_O2_controller8
	CLRF        _valve_duty+0 
	CLRF        _valve_duty+1 
L_O2_controller8:
;GPIO.c,105 :: 		if (valve_duty >255) valve_duty=255;
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _valve_duty+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__O2_controller34
	MOVF        _valve_duty+0, 0 
	SUBLW       255
L__O2_controller34:
	BTFSC       STATUS+0, 0 
	GOTO        L_O2_controller9
	MOVLW       255
	MOVWF       _valve_duty+0 
	MOVLW       0
	MOVWF       _valve_duty+1 
L_O2_controller9:
;GPIO.c,106 :: 		PWM1_Set_Duty(valve_duty);
	MOVF        _valve_duty+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;GPIO.c,108 :: 		last_error = error;
	MOVF        O2_controller_error_L0+0, 0 
	MOVWF       O2_controller_last_error_L0+0 
	MOVF        O2_controller_error_L0+1, 0 
	MOVWF       O2_controller_last_error_L0+1 
	MOVF        O2_controller_error_L0+2, 0 
	MOVWF       O2_controller_last_error_L0+2 
	MOVF        O2_controller_error_L0+3, 0 
	MOVWF       O2_controller_last_error_L0+3 
;GPIO.c,109 :: 		return;
;GPIO.c,110 :: 		}
L_end_O2_controller:
	RETURN      0
; end of _O2_controller

_pressure_controller:

;GPIO.c,112 :: 		void pressure_controller(){//function to regulate pressure in secondary bottle
;GPIO.c,117 :: 		float p_min = 20.0;
	MOVLW       ?ICSpressure_controller_p_min_L0+0
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(?ICSpressure_controller_p_min_L0+0)
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(?ICSpressure_controller_p_min_L0+0)
	MOVWF       TBLPTRU 
	MOVLW       pressure_controller_p_min_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(pressure_controller_p_min_L0+0)
	MOVWF       FSR1H 
	MOVLW       16
	MOVWF       R0 
	MOVLW       1
	MOVWF       R1 
	CALL        ___CC2DW+0, 0
;GPIO.c,137 :: 		difference = PressureValue0 - PressureValue1;
	MOVF        _PressureValue1+0, 0 
	MOVWF       R4 
	MOVF        _PressureValue1+1, 0 
	MOVWF       R5 
	MOVF        _PressureValue1+2, 0 
	MOVWF       R6 
	MOVF        _PressureValue1+3, 0 
	MOVWF       R7 
	MOVF        _PressureValue0+0, 0 
	MOVWF       R0 
	MOVF        _PressureValue0+1, 0 
	MOVWF       R1 
	MOVF        _PressureValue0+2, 0 
	MOVWF       R2 
	MOVF        _PressureValue0+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       pressure_controller_difference_L0+0 
	MOVF        R1, 0 
	MOVWF       pressure_controller_difference_L0+1 
	MOVF        R2, 0 
	MOVWF       pressure_controller_difference_L0+2 
	MOVF        R3, 0 
	MOVWF       pressure_controller_difference_L0+3 
;GPIO.c,138 :: 		if (PressureValue1 > p_max && valve_state==1){
	MOVF        _PressureValue1+0, 0 
	MOVWF       R4 
	MOVF        _PressureValue1+1, 0 
	MOVWF       R5 
	MOVF        _PressureValue1+2, 0 
	MOVWF       R6 
	MOVF        _PressureValue1+3, 0 
	MOVWF       R7 
	MOVF        pressure_controller_p_max_L0+0, 0 
	MOVWF       R0 
	MOVF        pressure_controller_p_max_L0+1, 0 
	MOVWF       R1 
	MOVF        pressure_controller_p_max_L0+2, 0 
	MOVWF       R2 
	MOVF        pressure_controller_p_max_L0+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pressure_controller12
	MOVLW       0
	XORWF       pressure_controller_valve_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pressure_controller36
	MOVLW       1
	XORWF       pressure_controller_valve_state_L0+0, 0 
L__pressure_controller36:
	BTFSS       STATUS+0, 2 
	GOTO        L_pressure_controller12
L__pressure_controller25:
;GPIO.c,139 :: 		pump_duty = 0;
	CLRF        _pump_duty+0 
;GPIO.c,140 :: 		valve_state=0;
	CLRF        pressure_controller_valve_state_L0+0 
	CLRF        pressure_controller_valve_state_L0+1 
;GPIO.c,141 :: 		PORTC.B3 = 0;
	BCF         PORTC+0, 3 
;GPIO.c,142 :: 		PWM2_Set_Duty(pump_duty);
	CLRF        FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;GPIO.c,143 :: 		return;
	GOTO        L_end_pressure_controller
;GPIO.c,144 :: 		}
L_pressure_controller12:
;GPIO.c,145 :: 		else if (PressureValue1 < p_min){
	MOVF        pressure_controller_p_min_L0+0, 0 
	MOVWF       R4 
	MOVF        pressure_controller_p_min_L0+1, 0 
	MOVWF       R5 
	MOVF        pressure_controller_p_min_L0+2, 0 
	MOVWF       R6 
	MOVF        pressure_controller_p_min_L0+3, 0 
	MOVWF       R7 
	MOVF        _PressureValue1+0, 0 
	MOVWF       R0 
	MOVF        _PressureValue1+1, 0 
	MOVWF       R1 
	MOVF        _PressureValue1+2, 0 
	MOVWF       R2 
	MOVF        _PressureValue1+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pressure_controller14
;GPIO.c,146 :: 		pump_duty=200;
	MOVLW       200
	MOVWF       _pump_duty+0 
;GPIO.c,147 :: 		valve_state=1;
	MOVLW       1
	MOVWF       pressure_controller_valve_state_L0+0 
	MOVLW       0
	MOVWF       pressure_controller_valve_state_L0+1 
;GPIO.c,148 :: 		PORTC.B3=1;
	BSF         PORTC+0, 3 
;GPIO.c,149 :: 		PWM2_Set_Duty(pump_duty);
	MOVLW       200
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;GPIO.c,150 :: 		return;
	GOTO        L_end_pressure_controller
;GPIO.c,151 :: 		}
L_pressure_controller14:
;GPIO.c,153 :: 		else if (PressureValue1 < p_max && difference > d_max && valve_state==0){
	MOVF        pressure_controller_p_max_L0+0, 0 
	MOVWF       R4 
	MOVF        pressure_controller_p_max_L0+1, 0 
	MOVWF       R5 
	MOVF        pressure_controller_p_max_L0+2, 0 
	MOVWF       R6 
	MOVF        pressure_controller_p_max_L0+3, 0 
	MOVWF       R7 
	MOVF        _PressureValue1+0, 0 
	MOVWF       R0 
	MOVF        _PressureValue1+1, 0 
	MOVWF       R1 
	MOVF        _PressureValue1+2, 0 
	MOVWF       R2 
	MOVF        _PressureValue1+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pressure_controller18
	MOVF        pressure_controller_difference_L0+0, 0 
	MOVWF       R4 
	MOVF        pressure_controller_difference_L0+1, 0 
	MOVWF       R5 
	MOVF        pressure_controller_difference_L0+2, 0 
	MOVWF       R6 
	MOVF        pressure_controller_difference_L0+3, 0 
	MOVWF       R7 
	MOVF        pressure_controller_d_max_L0+0, 0 
	MOVWF       R0 
	MOVF        pressure_controller_d_max_L0+1, 0 
	MOVWF       R1 
	MOVF        pressure_controller_d_max_L0+2, 0 
	MOVWF       R2 
	MOVF        pressure_controller_d_max_L0+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pressure_controller18
	MOVLW       0
	XORWF       pressure_controller_valve_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pressure_controller37
	MOVLW       0
	XORWF       pressure_controller_valve_state_L0+0, 0 
L__pressure_controller37:
	BTFSS       STATUS+0, 2 
	GOTO        L_pressure_controller18
L__pressure_controller24:
;GPIO.c,154 :: 		pump_duty=200;
	MOVLW       200
	MOVWF       _pump_duty+0 
;GPIO.c,155 :: 		valve_state=1;
	MOVLW       1
	MOVWF       pressure_controller_valve_state_L0+0 
	MOVLW       0
	MOVWF       pressure_controller_valve_state_L0+1 
;GPIO.c,156 :: 		PORTC.B3=1;
	BSF         PORTC+0, 3 
;GPIO.c,157 :: 		PWM2_Set_Duty(pump_duty);
	MOVLW       200
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;GPIO.c,158 :: 		return;
	GOTO        L_end_pressure_controller
;GPIO.c,159 :: 		}
L_pressure_controller18:
;GPIO.c,161 :: 		else if (difference < d_min && valve_state==1){
	MOVF        pressure_controller_d_min_L0+0, 0 
	MOVWF       R4 
	MOVF        pressure_controller_d_min_L0+1, 0 
	MOVWF       R5 
	MOVF        pressure_controller_d_min_L0+2, 0 
	MOVWF       R6 
	MOVF        pressure_controller_d_min_L0+3, 0 
	MOVWF       R7 
	MOVF        pressure_controller_difference_L0+0, 0 
	MOVWF       R0 
	MOVF        pressure_controller_difference_L0+1, 0 
	MOVWF       R1 
	MOVF        pressure_controller_difference_L0+2, 0 
	MOVWF       R2 
	MOVF        pressure_controller_difference_L0+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pressure_controller22
	MOVLW       0
	XORWF       pressure_controller_valve_state_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__pressure_controller38
	MOVLW       1
	XORWF       pressure_controller_valve_state_L0+0, 0 
L__pressure_controller38:
	BTFSS       STATUS+0, 2 
	GOTO        L_pressure_controller22
L__pressure_controller23:
;GPIO.c,162 :: 		pump_duty=0;
	CLRF        _pump_duty+0 
;GPIO.c,163 :: 		valve_state=0;
	CLRF        pressure_controller_valve_state_L0+0 
	CLRF        pressure_controller_valve_state_L0+1 
;GPIO.c,164 :: 		PORTC.B3=0;
	BCF         PORTC+0, 3 
;GPIO.c,165 :: 		PWM2_Set_Duty(pump_duty);
	CLRF        FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;GPIO.c,166 :: 		return;
	GOTO        L_end_pressure_controller
;GPIO.c,167 :: 		}
L_pressure_controller22:
;GPIO.c,168 :: 		return;
;GPIO.c,169 :: 		}
L_end_pressure_controller:
	RETURN      0
; end of _pressure_controller
