
_main:

;test.c,45 :: 		void main()
;test.c,47 :: 		char *voltage = "00.0";
;test.c,48 :: 		char *current = "0.00";
;test.c,49 :: 		char *_prevVoltage = "00.0";
;test.c,50 :: 		char *_prevCurrent = "0.00";
;test.c,51 :: 		float currentLimit = 0.00;
	CLRF        main_currentLimit_L0+0 
	CLRF        main_currentLimit_L0+1 
	CLRF        main_currentLimit_L0+2 
	CLRF        main_currentLimit_L0+3 
	MOVLW       51
	MOVWF       main_voltageLimit_L0+0 
	MOVLW       51
	MOVWF       main_voltageLimit_L0+1 
	MOVLW       115
	MOVWF       main_voltageLimit_L0+2 
	MOVLW       130
	MOVWF       main_voltageLimit_L0+3 
;test.c,63 :: 		TRISA = 0x1B;      // RA2 & RA5 as output
	MOVLW       27
	MOVWF       TRISA+0 
;test.c,64 :: 		TRISB = 0xF0;      // RB0~RB3 as output
	MOVLW       240
	MOVWF       TRISB+0 
;test.c,65 :: 		TRISC = 0x00;      // all output
	CLRF        TRISC+0 
;test.c,66 :: 		TRISD = 0x00;      // all output
	CLRF        TRISD+0 
;test.c,68 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;test.c,69 :: 		PORTC = 0x00;
	CLRF        PORTC+0 
;test.c,70 :: 		PORTD = 0x00;
	CLRF        PORTD+0 
;test.c,76 :: 		lcd_init();
	CALL        _Lcd_Init+0, 0
;test.c,77 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;test.c,79 :: 		r_init();
	CALL        _r_init+0, 0
;test.c,80 :: 		ADC_Init();      //Initializes ADC Module
	CALL        _ADC_Init+0, 0
;test.c,82 :: 		while(1)
L_main0:
;test.c,84 :: 		if (!_swichOnOff)
	BTFSC       RA4_bit+0, BitPos(RA4_bit+0) 
	GOTO        L_main2
;test.c,86 :: 		while(!_swichOnOff);
L_main3:
	BTFSC       RA4_bit+0, BitPos(RA4_bit+0) 
	GOTO        L_main4
	GOTO        L_main3
L_main4:
;test.c,87 :: 		_OnOffLED^=1;
	BTG         RA5_bit+0, BitPos(RA5_bit+0) 
;test.c,88 :: 		FOutOnOff ^=1;
	BTG         _FOutOnOff+0, BitPos(_FOutOnOff+0) 
;test.c,90 :: 		}
L_main2:
;test.c,92 :: 		if(adc_count >= 4095) adc_count = 0;
	MOVLW       128
	XORWF       main_adc_count_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       15
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main30
	MOVLW       255
	SUBWF       main_adc_count_L0+0, 0 
L__main30:
	BTFSS       STATUS+0, 0 
	GOTO        L_main5
	CLRF        main_adc_count_L0+0 
	CLRF        main_adc_count_L0+1 
L_main5:
;test.c,93 :: 		if(adc_count <= 0) adc_count = 4095;
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       main_adc_count_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main31
	MOVF        main_adc_count_L0+0, 0 
	SUBLW       0
L__main31:
	BTFSS       STATUS+0, 0 
	GOTO        L_main6
	MOVLW       255
	MOVWF       main_adc_count_L0+0 
	MOVLW       15
	MOVWF       main_adc_count_L0+1 
L_main6:
;test.c,96 :: 		PORTD = adc_count;
	MOVF        main_adc_count_L0+0, 0 
	MOVWF       PORTD+0 
;test.c,97 :: 		PORTC = (adc_count>>8)&0x0F;
	MOVF        main_adc_count_L0+1, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       main_adc_count_L0+1, 7 
	MOVLW       255
	MOVWF       R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       PORTC+0 
;test.c,112 :: 		a = ADC_Read(1); //Reading Analog Channel 1
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_a_L0+0 
	MOVF        R1, 0 
	MOVWF       main_a_L0+1 
;test.c,113 :: 		current_res = a*KI;
	CALL        _word2double+0, 0
	MOVLW       82
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       119
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       main_current_res_L0+0 
	MOVF        R1, 0 
	MOVWF       main_current_res_L0+1 
	MOVF        R2, 0 
	MOVWF       main_current_res_L0+2 
	MOVF        R3, 0 
	MOVWF       main_current_res_L0+3 
;test.c,114 :: 		ftoa(current_res*10,temp,2);    //ftoa(a*0.048875,temp,2); //ftoa(a*0.0049,temp,2);
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_ftoa_n+0 
	MOVF        R1, 0 
	MOVWF       FARG_ftoa_n+1 
	MOVF        R2, 0 
	MOVWF       FARG_ftoa_n+2 
	MOVF        R3, 0 
	MOVWF       FARG_ftoa_n+3 
	MOVLW       _temp+0
	MOVWF       FARG_ftoa_res+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_ftoa_res+1 
	MOVLW       2
	MOVWF       FARG_ftoa_afterpoint+0 
	MOVLW       0
	MOVWF       FARG_ftoa_afterpoint+1 
	CALL        _ftoa+0, 0
;test.c,115 :: 		Lcd_Out(2,1,temp);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _temp+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;test.c,117 :: 		lcd_puts(2, 6, "[A]");
	MOVLW       2
	MOVWF       FARG_lcd_puts_row+0 
	MOVLW       6
	MOVWF       FARG_lcd_puts_column+0 
	MOVLW       ?lstr_5_test+0
	MOVWF       FARG_lcd_puts_s+0 
	MOVLW       hi_addr(?lstr_5_test+0)
	MOVWF       FARG_lcd_puts_s+1 
	MOVLW       higher_addr(?lstr_5_test+0)
	MOVWF       FARG_lcd_puts_s+2 
	CALL        _lcd_puts+0, 0
;test.c,118 :: 		ftoa(currentLimit,temp,2);
	MOVF        main_currentLimit_L0+0, 0 
	MOVWF       FARG_ftoa_n+0 
	MOVF        main_currentLimit_L0+1, 0 
	MOVWF       FARG_ftoa_n+1 
	MOVF        main_currentLimit_L0+2, 0 
	MOVWF       FARG_ftoa_n+2 
	MOVF        main_currentLimit_L0+3, 0 
	MOVWF       FARG_ftoa_n+3 
	MOVLW       _temp+0
	MOVWF       FARG_ftoa_res+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_ftoa_res+1 
	MOVLW       2
	MOVWF       FARG_ftoa_afterpoint+0 
	MOVLW       0
	MOVWF       FARG_ftoa_afterpoint+1 
	CALL        _ftoa+0, 0
;test.c,119 :: 		lcd_puts(2, 10, "[");
	MOVLW       2
	MOVWF       FARG_lcd_puts_row+0 
	MOVLW       10
	MOVWF       FARG_lcd_puts_column+0 
	MOVLW       ?lstr_6_test+0
	MOVWF       FARG_lcd_puts_s+0 
	MOVLW       hi_addr(?lstr_6_test+0)
	MOVWF       FARG_lcd_puts_s+1 
	MOVLW       higher_addr(?lstr_6_test+0)
	MOVWF       FARG_lcd_puts_s+2 
	CALL        _lcd_puts+0, 0
;test.c,120 :: 		Lcd_Out(2, 11, temp);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _temp+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;test.c,121 :: 		lcd_puts(2, 15, "]");
	MOVLW       2
	MOVWF       FARG_lcd_puts_row+0 
	MOVLW       15
	MOVWF       FARG_lcd_puts_column+0 
	MOVLW       ?lstr_7_test+0
	MOVWF       FARG_lcd_puts_s+0 
	MOVLW       hi_addr(?lstr_7_test+0)
	MOVWF       FARG_lcd_puts_s+1 
	MOVLW       higher_addr(?lstr_7_test+0)
	MOVWF       FARG_lcd_puts_s+2 
	CALL        _lcd_puts+0, 0
;test.c,123 :: 		b = ADC_Read(0); //Reading Analog Channel 0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;test.c,124 :: 		voltage_res = b*KV;
	CALL        _word2double+0, 0
	MOVLW       5
	MOVWF       R4 
	MOVLW       220
	MOVWF       R5 
	MOVLW       115
	MOVWF       R6 
	MOVLW       121
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
;test.c,125 :: 		ftoa(voltage_res-current_res,temp,1);    //ftoa(b*0.029768-a*0.0048875,temp,2); //ftoa((b*0.03-a*0.0049),temp,2);
	MOVF        main_current_res_L0+0, 0 
	MOVWF       R4 
	MOVF        main_current_res_L0+1, 0 
	MOVWF       R5 
	MOVF        main_current_res_L0+2, 0 
	MOVWF       R6 
	MOVF        main_current_res_L0+3, 0 
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_ftoa_n+0 
	MOVF        R1, 0 
	MOVWF       FARG_ftoa_n+1 
	MOVF        R2, 0 
	MOVWF       FARG_ftoa_n+2 
	MOVF        R3, 0 
	MOVWF       FARG_ftoa_n+3 
	MOVLW       _temp+0
	MOVWF       FARG_ftoa_res+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_ftoa_res+1 
	MOVLW       1
	MOVWF       FARG_ftoa_afterpoint+0 
	MOVLW       0
	MOVWF       FARG_ftoa_afterpoint+1 
	CALL        _ftoa+0, 0
;test.c,126 :: 		Lcd_Out(1,1,temp);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _temp+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;test.c,128 :: 		lcd_puts(1, 5, "[V]");
	MOVLW       1
	MOVWF       FARG_lcd_puts_row+0 
	MOVLW       5
	MOVWF       FARG_lcd_puts_column+0 
	MOVLW       ?lstr_8_test+0
	MOVWF       FARG_lcd_puts_s+0 
	MOVLW       hi_addr(?lstr_8_test+0)
	MOVWF       FARG_lcd_puts_s+1 
	MOVLW       higher_addr(?lstr_8_test+0)
	MOVWF       FARG_lcd_puts_s+2 
	CALL        _lcd_puts+0, 0
;test.c,129 :: 		ftoa(voltageLimit,temp,1);
	MOVF        main_voltageLimit_L0+0, 0 
	MOVWF       FARG_ftoa_n+0 
	MOVF        main_voltageLimit_L0+1, 0 
	MOVWF       FARG_ftoa_n+1 
	MOVF        main_voltageLimit_L0+2, 0 
	MOVWF       FARG_ftoa_n+2 
	MOVF        main_voltageLimit_L0+3, 0 
	MOVWF       FARG_ftoa_n+3 
	MOVLW       _temp+0
	MOVWF       FARG_ftoa_res+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_ftoa_res+1 
	MOVLW       1
	MOVWF       FARG_ftoa_afterpoint+0 
	MOVLW       0
	MOVWF       FARG_ftoa_afterpoint+1 
	CALL        _ftoa+0, 0
;test.c,130 :: 		lcd_puts(1, 10, "[");
	MOVLW       1
	MOVWF       FARG_lcd_puts_row+0 
	MOVLW       10
	MOVWF       FARG_lcd_puts_column+0 
	MOVLW       ?lstr_9_test+0
	MOVWF       FARG_lcd_puts_s+0 
	MOVLW       hi_addr(?lstr_9_test+0)
	MOVWF       FARG_lcd_puts_s+1 
	MOVLW       higher_addr(?lstr_9_test+0)
	MOVWF       FARG_lcd_puts_s+2 
	CALL        _lcd_puts+0, 0
;test.c,131 :: 		Lcd_Out(1, 11, temp);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _temp+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_temp+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;test.c,132 :: 		lcd_puts(1, 15, "]");
	MOVLW       1
	MOVWF       FARG_lcd_puts_row+0 
	MOVLW       15
	MOVWF       FARG_lcd_puts_column+0 
	MOVLW       ?lstr_10_test+0
	MOVWF       FARG_lcd_puts_s+0 
	MOVLW       hi_addr(?lstr_10_test+0)
	MOVWF       FARG_lcd_puts_s+1 
	MOVLW       higher_addr(?lstr_10_test+0)
	MOVWF       FARG_lcd_puts_s+2 
	CALL        _lcd_puts+0, 0
;test.c,134 :: 		if(FOutOnOff)
	BTFSS       _FOutOnOff+0, BitPos(_FOutOnOff+0) 
	GOTO        L_main7
;test.c,136 :: 		if(!RB4_bit)
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_main8
;test.c,139 :: 		voltageLimit += 0.1;
	MOVF        main_voltageLimit_L0+0, 0 
	MOVWF       R0 
	MOVF        main_voltageLimit_L0+1, 0 
	MOVWF       R1 
	MOVF        main_voltageLimit_L0+2, 0 
	MOVWF       R2 
	MOVF        main_voltageLimit_L0+3, 0 
	MOVWF       R3 
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       main_voltageLimit_L0+0 
	MOVF        R1, 0 
	MOVWF       main_voltageLimit_L0+1 
	MOVF        R2, 0 
	MOVWF       main_voltageLimit_L0+2 
	MOVF        R3, 0 
	MOVWF       main_voltageLimit_L0+3 
;test.c,146 :: 		Delay_ms(50);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	DECFSZ      R11, 1, 1
	BRA         L_main9
	NOP
	NOP
;test.c,147 :: 		}
	GOTO        L_main10
L_main8:
;test.c,148 :: 		else if(!RB5_bit)
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_main11
;test.c,150 :: 		voltageLimit -= 0.1;
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	MOVF        main_voltageLimit_L0+0, 0 
	MOVWF       R0 
	MOVF        main_voltageLimit_L0+1, 0 
	MOVWF       R1 
	MOVF        main_voltageLimit_L0+2, 0 
	MOVWF       R2 
	MOVF        main_voltageLimit_L0+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       main_voltageLimit_L0+0 
	MOVF        R1, 0 
	MOVWF       main_voltageLimit_L0+1 
	MOVF        R2, 0 
	MOVWF       main_voltageLimit_L0+2 
	MOVF        R3, 0 
	MOVWF       main_voltageLimit_L0+3 
;test.c,151 :: 		Delay_ms(50);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	DECFSZ      R12, 1, 1
	BRA         L_main12
	DECFSZ      R11, 1, 1
	BRA         L_main12
	NOP
	NOP
;test.c,152 :: 		}
L_main11:
L_main10:
;test.c,153 :: 		adc_count = (int)(((voltageLimit*4095)/30.5)+a);    // count = (int)(((voltageLimit*4095)/30.5)+a);
	MOVF        main_voltageLimit_L0+0, 0 
	MOVWF       R0 
	MOVF        main_voltageLimit_L0+1, 0 
	MOVWF       R1 
	MOVF        main_voltageLimit_L0+2, 0 
	MOVWF       R2 
	MOVF        main_voltageLimit_L0+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       240
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       138
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       116
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVF        main_a_L0+0, 0 
	MOVWF       R0 
	MOVF        main_a_L0+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVF        FLOC__main+0, 0 
	MOVWF       R4 
	MOVF        FLOC__main+1, 0 
	MOVWF       R5 
	MOVF        FLOC__main+2, 0 
	MOVWF       R6 
	MOVF        FLOC__main+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       main_adc_count_L0+0 
	MOVF        R1, 0 
	MOVWF       main_adc_count_L0+1 
;test.c,154 :: 		if(voltageLimit>=30.5) voltageLimit=30.5;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       116
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	MOVF        main_voltageLimit_L0+0, 0 
	MOVWF       R0 
	MOVF        main_voltageLimit_L0+1, 0 
	MOVWF       R1 
	MOVF        main_voltageLimit_L0+2, 0 
	MOVWF       R2 
	MOVF        main_voltageLimit_L0+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVLW       0
	MOVWF       main_voltageLimit_L0+0 
	MOVLW       0
	MOVWF       main_voltageLimit_L0+1 
	MOVLW       116
	MOVWF       main_voltageLimit_L0+2 
	MOVLW       131
	MOVWF       main_voltageLimit_L0+3 
L_main13:
;test.c,155 :: 		if(voltageLimit<=0) voltageLimit=00.0;
	MOVF        main_voltageLimit_L0+0, 0 
	MOVWF       R4 
	MOVF        main_voltageLimit_L0+1, 0 
	MOVWF       R5 
	MOVF        main_voltageLimit_L0+2, 0 
	MOVWF       R6 
	MOVF        main_voltageLimit_L0+3, 0 
	MOVWF       R7 
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
	CLRF        main_voltageLimit_L0+0 
	CLRF        main_voltageLimit_L0+1 
	CLRF        main_voltageLimit_L0+2 
	CLRF        main_voltageLimit_L0+3 
L_main14:
;test.c,161 :: 		}
	GOTO        L_main15
L_main7:
;test.c,162 :: 		else adc_count = 0;
	CLRF        main_adc_count_L0+0 
	CLRF        main_adc_count_L0+1 
L_main15:
;test.c,164 :: 		}
	GOTO        L_main0
;test.c,165 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_reverse:

;test.c,169 :: 		void reverse(char* str, int len)
;test.c,171 :: 		int i = 0, j = len - 1, temp;
	CLRF        reverse_i_L0+0 
	CLRF        reverse_i_L0+1 
	MOVLW       1
	SUBWF       FARG_reverse_len+0, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWFB      FARG_reverse_len+1, 0 
	MOVWF       R3 
;test.c,172 :: 		while (i < j) {
L_reverse16:
	MOVLW       128
	XORWF       reverse_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__reverse33
	MOVF        R2, 0 
	SUBWF       reverse_i_L0+0, 0 
L__reverse33:
	BTFSC       STATUS+0, 0 
	GOTO        L_reverse17
;test.c,173 :: 		temp = str[i];
	MOVF        reverse_i_L0+0, 0 
	ADDWF       FARG_reverse_str+0, 0 
	MOVWF       R0 
	MOVF        reverse_i_L0+1, 0 
	ADDWFC      FARG_reverse_str+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R5 
;test.c,174 :: 		str[i] = str[j];
	MOVF        R2, 0 
	ADDWF       FARG_reverse_str+0, 0 
	MOVWF       FSR0L+0 
	MOVF        R3, 0 
	ADDWFC      FARG_reverse_str+1, 0 
	MOVWF       FSR0L+1 
	MOVFF       R0, FSR1L+0
	MOVFF       R1, FSR1H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;test.c,175 :: 		str[j] = temp;
	MOVF        R2, 0 
	ADDWF       FARG_reverse_str+0, 0 
	MOVWF       FSR1L+0 
	MOVF        R3, 0 
	ADDWFC      FARG_reverse_str+1, 0 
	MOVWF       FSR1L+1 
	MOVF        R4, 0 
	MOVWF       POSTINC1+0 
;test.c,176 :: 		i++;
	INFSNZ      reverse_i_L0+0, 1 
	INCF        reverse_i_L0+1, 1 
;test.c,177 :: 		j--;
	MOVLW       1
	SUBWF       R2, 1 
	MOVLW       0
	SUBWFB      R3, 1 
;test.c,178 :: 		}
	GOTO        L_reverse16
L_reverse17:
;test.c,179 :: 		}
L_end_reverse:
	RETURN      0
; end of _reverse

_intToStr:

;test.c,184 :: 		int intToStr(int x, char str[], int d)
;test.c,186 :: 		int i = 0;
	CLRF        intToStr_i_L0+0 
	CLRF        intToStr_i_L0+1 
;test.c,187 :: 		while (x) {
L_intToStr18:
	MOVF        FARG_intToStr_x+0, 0 
	IORWF       FARG_intToStr_x+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_intToStr19
;test.c,188 :: 		str[i++] = (x % 10) + '0';
	MOVF        intToStr_i_L0+0, 0 
	ADDWF       FARG_intToStr_str+0, 0 
	MOVWF       FLOC__intToStr+0 
	MOVF        intToStr_i_L0+1, 0 
	ADDWFC      FARG_intToStr_str+1, 0 
	MOVWF       FLOC__intToStr+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_intToStr_x+0, 0 
	MOVWF       R0 
	MOVF        FARG_intToStr_x+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__intToStr+0, FSR1L+0
	MOVFF       FLOC__intToStr+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      intToStr_i_L0+0, 1 
	INCF        intToStr_i_L0+1, 1 
;test.c,189 :: 		x = x / 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_intToStr_x+0, 0 
	MOVWF       R0 
	MOVF        FARG_intToStr_x+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_intToStr_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_intToStr_x+1 
;test.c,190 :: 		}
	GOTO        L_intToStr18
L_intToStr19:
;test.c,194 :: 		while (i < d)
L_intToStr20:
	MOVLW       128
	XORWF       intToStr_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_intToStr_d+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__intToStr35
	MOVF        FARG_intToStr_d+0, 0 
	SUBWF       intToStr_i_L0+0, 0 
L__intToStr35:
	BTFSC       STATUS+0, 0 
	GOTO        L_intToStr21
;test.c,195 :: 		str[i++] = '0';
	MOVF        intToStr_i_L0+0, 0 
	ADDWF       FARG_intToStr_str+0, 0 
	MOVWF       FSR1L+0 
	MOVF        intToStr_i_L0+1, 0 
	ADDWFC      FARG_intToStr_str+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       48
	MOVWF       POSTINC1+0 
	INFSNZ      intToStr_i_L0+0, 1 
	INCF        intToStr_i_L0+1, 1 
	GOTO        L_intToStr20
L_intToStr21:
;test.c,197 :: 		reverse(str, i);
	MOVF        FARG_intToStr_str+0, 0 
	MOVWF       FARG_reverse_str+0 
	MOVF        FARG_intToStr_str+1, 0 
	MOVWF       FARG_reverse_str+1 
	MOVF        intToStr_i_L0+0, 0 
	MOVWF       FARG_reverse_len+0 
	MOVF        intToStr_i_L0+1, 0 
	MOVWF       FARG_reverse_len+1 
	CALL        _reverse+0, 0
;test.c,198 :: 		str[i] = '\0';
	MOVF        intToStr_i_L0+0, 0 
	ADDWF       FARG_intToStr_str+0, 0 
	MOVWF       FSR1L+0 
	MOVF        intToStr_i_L0+1, 0 
	ADDWFC      FARG_intToStr_str+1, 0 
	MOVWF       FSR1L+1 
	CLRF        POSTINC1+0 
;test.c,199 :: 		return i;
	MOVF        intToStr_i_L0+0, 0 
	MOVWF       R0 
	MOVF        intToStr_i_L0+1, 0 
	MOVWF       R1 
;test.c,200 :: 		}
L_end_intToStr:
	RETURN      0
; end of _intToStr

_ftoa:

;test.c,202 :: 		void ftoa(float n, char* res, int afterpoint)
;test.c,205 :: 		int ipart = (int)n;
	MOVF        FARG_ftoa_n+0, 0 
	MOVWF       R0 
	MOVF        FARG_ftoa_n+1, 0 
	MOVWF       R1 
	MOVF        FARG_ftoa_n+2, 0 
	MOVWF       R2 
	MOVF        FARG_ftoa_n+3, 0 
	MOVWF       R3 
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__ftoa+0 
	MOVF        R1, 0 
	MOVWF       FLOC__ftoa+1 
	MOVF        FLOC__ftoa+0, 0 
	MOVWF       R0 
	MOVF        FLOC__ftoa+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
;test.c,208 :: 		float fpart = n - (float)ipart;
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FARG_ftoa_n+0, 0 
	MOVWF       R0 
	MOVF        FARG_ftoa_n+1, 0 
	MOVWF       R1 
	MOVF        FARG_ftoa_n+2, 0 
	MOVWF       R2 
	MOVF        FARG_ftoa_n+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       ftoa_fpart_L0+0 
	MOVF        R1, 0 
	MOVWF       ftoa_fpart_L0+1 
	MOVF        R2, 0 
	MOVWF       ftoa_fpart_L0+2 
	MOVF        R3, 0 
	MOVWF       ftoa_fpart_L0+3 
;test.c,211 :: 		int i = intToStr(ipart, res, 1);
	MOVF        FLOC__ftoa+0, 0 
	MOVWF       FARG_intToStr_x+0 
	MOVF        FLOC__ftoa+1, 0 
	MOVWF       FARG_intToStr_x+1 
	MOVF        FARG_ftoa_res+0, 0 
	MOVWF       FARG_intToStr_str+0 
	MOVF        FARG_ftoa_res+1, 0 
	MOVWF       FARG_intToStr_str+1 
	MOVLW       1
	MOVWF       FARG_intToStr_d+0 
	MOVLW       0
	MOVWF       FARG_intToStr_d+1 
	CALL        _intToStr+0, 0
	MOVF        R0, 0 
	MOVWF       ftoa_i_L0+0 
	MOVF        R1, 0 
	MOVWF       ftoa_i_L0+1 
;test.c,214 :: 		if (afterpoint != 0) {
	MOVLW       0
	XORWF       FARG_ftoa_afterpoint+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ftoa37
	MOVLW       0
	XORWF       FARG_ftoa_afterpoint+0, 0 
L__ftoa37:
	BTFSC       STATUS+0, 2 
	GOTO        L_ftoa22
;test.c,215 :: 		res[i] = '.'; // add dot
	MOVF        ftoa_i_L0+0, 0 
	ADDWF       FARG_ftoa_res+0, 0 
	MOVWF       FSR1L+0 
	MOVF        ftoa_i_L0+1, 0 
	ADDWFC      FARG_ftoa_res+1, 0 
	MOVWF       FSR1L+1 
	MOVLW       46
	MOVWF       POSTINC1+0 
;test.c,220 :: 		fpart = fpart * pow(10, afterpoint);
	MOVLW       0
	MOVWF       FARG_pow_x+0 
	MOVLW       0
	MOVWF       FARG_pow_x+1 
	MOVLW       32
	MOVWF       FARG_pow_x+2 
	MOVLW       130
	MOVWF       FARG_pow_x+3 
	MOVF        FARG_ftoa_afterpoint+0, 0 
	MOVWF       R0 
	MOVF        FARG_ftoa_afterpoint+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_pow_y+0 
	MOVF        R1, 0 
	MOVWF       FARG_pow_y+1 
	MOVF        R2, 0 
	MOVWF       FARG_pow_y+2 
	MOVF        R3, 0 
	MOVWF       FARG_pow_y+3 
	CALL        _pow+0, 0
	MOVF        ftoa_fpart_L0+0, 0 
	MOVWF       R4 
	MOVF        ftoa_fpart_L0+1, 0 
	MOVWF       R5 
	MOVF        ftoa_fpart_L0+2, 0 
	MOVWF       R6 
	MOVF        ftoa_fpart_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       ftoa_fpart_L0+0 
	MOVF        R1, 0 
	MOVWF       ftoa_fpart_L0+1 
	MOVF        R2, 0 
	MOVWF       ftoa_fpart_L0+2 
	MOVF        R3, 0 
	MOVWF       ftoa_fpart_L0+3 
;test.c,222 :: 		intToStr((int)fpart, res + i + 1, afterpoint);
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_intToStr_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_intToStr_x+1 
	MOVF        ftoa_i_L0+0, 0 
	ADDWF       FARG_ftoa_res+0, 0 
	MOVWF       FARG_intToStr_str+0 
	MOVF        ftoa_i_L0+1, 0 
	ADDWFC      FARG_ftoa_res+1, 0 
	MOVWF       FARG_intToStr_str+1 
	INFSNZ      FARG_intToStr_str+0, 1 
	INCF        FARG_intToStr_str+1, 1 
	MOVF        FARG_ftoa_afterpoint+0, 0 
	MOVWF       FARG_intToStr_d+0 
	MOVF        FARG_ftoa_afterpoint+1, 0 
	MOVWF       FARG_intToStr_d+1 
	CALL        _intToStr+0, 0
;test.c,223 :: 		}
L_ftoa22:
;test.c,224 :: 		}
L_end_ftoa:
	RETURN      0
; end of _ftoa

_r_init:

;test.c,229 :: 		void r_init(void)
;test.c,231 :: 		TRISB.B4=1; // set rotary encoder pins to input
	BSF         TRISB+0, 4 
;test.c,232 :: 		TRISB.B5=1;
	BSF         TRISB+0, 5 
;test.c,236 :: 		INTCON2.RBPU =0; // enable pullups
	BCF         INTCON2+0, 7 
;test.c,237 :: 		INTCON2.RBIP =0; // RB Port Change Interrupt - high priority
	BCF         INTCON2+0, 0 
;test.c,238 :: 		INTCON.RBIF = 0; // clear the interrupt flag
	BCF         INTCON+0, 0 
;test.c,239 :: 		INTCON.RBIE = 1; // enable PORTB change interrupt
	BSF         INTCON+0, 3 
;test.c,240 :: 		INTCON.GIE = 1;  // enable the global interrupt
	BSF         INTCON+0, 7 
;test.c,241 :: 		RCON.IPEN = 0;   // Disable priority levels on interrupts (16CXXX Compatibility mode)
	BCF         RCON+0, 7 
;test.c,246 :: 		}
L_end_r_init:
	RETURN      0
; end of _r_init

_pbchange:

;test.c,250 :: 		void pbchange(void)
;test.c,254 :: 		delay_ms(1); // delay for 1ms here for debounce
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_pbchange23:
	DECFSZ      R13, 1, 1
	BRA         L_pbchange23
	DECFSZ      R12, 1, 1
	BRA         L_pbchange23
;test.c,255 :: 		state= (REB<<1 | REA); // combine the pin status and assign to state variable
	MOVLW       0
	BTFSC       PORTB+0, 5 
	MOVLW       1
	MOVWF       R1 
	RLCF        R1, 1 
	BCF         R1, 0 
	CLRF        R0 
	BTFSC       PORTB+0, 4 
	INCF        R0, 1 
	MOVF        R0, 0 
	IORWF       R1, 1 
;test.c,256 :: 		if(oldstate==0x0)
	MOVF        pbchange_oldstate_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_pbchange24
;test.c,258 :: 		if( state ==0x1)
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_pbchange25
;test.c,260 :: 		count--; //decrement the count
	MOVLW       1
	SUBWF       _count+0, 1 
	MOVLW       0
	SUBWFB      _count+1, 1 
;test.c,261 :: 		}
	GOTO        L_pbchange26
L_pbchange25:
;test.c,262 :: 		else if( state == 0x2)
	MOVF        R1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_pbchange27
;test.c,264 :: 		count++; //decrement the count
	INFSNZ      _count+0, 1 
	INCF        _count+1, 1 
;test.c,265 :: 		}
L_pbchange27:
L_pbchange26:
;test.c,266 :: 		}
L_pbchange24:
;test.c,267 :: 		oldstate = state; // store the current state value to oldstate value this value will be used in next call
	MOVF        R1, 0 
	MOVWF       pbchange_oldstate_L0+0 
;test.c,269 :: 		PORTB = PORTB;    // read or Any read or write of PORTB,This will end the mismatch condition
;test.c,270 :: 		INTCON.RBIF = 0;  // clear the porb change intrrupt flag
	BCF         INTCON+0, 0 
;test.c,271 :: 		}
L_end_pbchange:
	RETURN      0
; end of _pbchange

_interrupt:

;test.c,275 :: 		void interrupt(void)
;test.c,277 :: 		if(INTCON.RBIF==1) //check for PortB change interrupt
	BTFSS       INTCON+0, 0 
	GOTO        L_interrupt28
;test.c,279 :: 		pbchange();    //call the routine
	CALL        _pbchange+0, 0
;test.c,280 :: 		}
L_interrupt28:
;test.c,281 :: 		}
L_end_interrupt:
L__interrupt41:
	RETFIE      1
; end of _interrupt
