
_main:

;test.c,57 :: 		void main()
;test.c,60 :: 		char *voltage = "00.0";
	MOVLW      ?lstr1_test+0
	MOVWF      main_voltage_L0+0
	MOVLW      ?lstr2_test+0
	MOVWF      main_current_L0+0
;test.c,66 :: 		TRISA = 0xFF;      // all input
	MOVLW      255
	MOVWF      TRISA+0
;test.c,67 :: 		TRISB = 0x00;      // all output
	CLRF       TRISB+0
;test.c,68 :: 		TRISC = 0xC0;      // RC6 & RC7 asinput
	MOVLW      192
	MOVWF      TRISC+0
;test.c,70 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;test.c,71 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;test.c,73 :: 		ADCON1 = 0xC0;
	MOVLW      192
	MOVWF      ADCON1+0
;test.c,74 :: 		ADCON0 = 0x41;     // RA0 & RA1 as analog input, RA3 as VREF+, all other as digital i/o
	MOVLW      65
	MOVWF      ADCON0+0
;test.c,75 :: 		CMCON = 0x07;      // comperator disable
	MOVLW      7
	MOVWF      CMCON+0
;test.c,77 :: 		lcd_init();
	CALL       _Lcd_Init+0
;test.c,78 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;test.c,80 :: 		lcd_puts(1, 1,  "Zchar Paparov");
	MOVLW      1
	MOVWF      FARG_lcd_puts_row+0
	MOVLW      1
	MOVWF      FARG_lcd_puts_column+0
	MOVLW      ?lstr_3_test+0
	MOVWF      FARG_lcd_puts_s+0
	MOVLW      hi_addr(?lstr_3_test+0)
	MOVWF      FARG_lcd_puts_s+1
	CALL       _lcd_puts+0
;test.c,82 :: 		system_init();
	CALL       _system_init+0
;test.c,83 :: 		ADC_Init();      //Initializes ADC Module
	CALL       _ADC_Init+0
;test.c,85 :: 		counter = 0;
	CLRF       _counter+0
;test.c,86 :: 		result = 0;
	CLRF       main_result_L0+0
	CLRF       main_result_L0+1
;test.c,88 :: 		for(i=0;i<ADC_ARRAY_SIZE;i++) display[i]=0;
	CLRF       main_i_L0+0
L_main0:
	MOVLW      4
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main1
	MOVF       main_i_L0+0, 0
	ADDLW      main_display_L0+0
	MOVWF      FSR
	CLRF       INDF+0
	INCF       main_i_L0+0, 1
	GOTO       L_main0
L_main1:
;test.c,90 :: 		while(1)
L_main3:
;test.c,123 :: 		if(!RC6_bit) counter++;
	BTFSC      RC6_bit+0, BitPos(RC6_bit+0)
	GOTO       L_main5
	INCF       _counter+0, 1
L_main5:
;test.c,124 :: 		if(!RC7_bit) counter--;
	BTFSC      RC7_bit+0, BitPos(RC7_bit+0)
	GOTO       L_main6
	DECF       _counter+0, 1
L_main6:
;test.c,125 :: 		PORTB = counter;
	MOVF       _counter+0, 0
	MOVWF      PORTB+0
;test.c,127 :: 		Delay_ms(50);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
;test.c,131 :: 		a = ADC_Read(0); //Reading Analog Channel 0
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
;test.c,132 :: 		result = 3*a;
	MOVLW      3
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      main_result_L0+0
	MOVF       R0+1, 0
	MOVWF      main_result_L0+1
;test.c,136 :: 		Delay_ms(100);   //Delay
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
;test.c,137 :: 		voltage[0]= result/1000+48;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       main_result_L0+0, 0
	MOVWF      R0+0
	MOVF       main_result_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       main_voltage_L0+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;test.c,138 :: 		voltage[1]= (result/100)%10+48;
	INCF       main_voltage_L0+0, 0
	MOVWF      FLOC__main+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       main_result_L0+0, 0
	MOVWF      R0+0
	MOVF       main_result_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;test.c,139 :: 		voltage[3]= (result/10)%10+48;
	MOVLW      3
	ADDWF      main_voltage_L0+0, 0
	MOVWF      FLOC__main+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       main_result_L0+0, 0
	MOVWF      R0+0
	MOVF       main_result_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;test.c,140 :: 		Lcd_Out(2,1,voltage);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       main_voltage_L0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;test.c,142 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
;test.c,144 :: 		a = ADC_Read(1); //Reading Analog Channel 0
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
;test.c,145 :: 		result = 5*a;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      main_result_L0+0
	MOVF       R0+1, 0
	MOVWF      main_result_L0+1
;test.c,149 :: 		Delay_ms(100);   //Delay
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
;test.c,150 :: 		current[0]= result/1000+48;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       main_result_L0+0, 0
	MOVWF      R0+0
	MOVF       main_result_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       main_current_L0+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;test.c,151 :: 		current[2]= (result/100)%10+48;
	MOVLW      2
	ADDWF      main_current_L0+0, 0
	MOVWF      FLOC__main+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       main_result_L0+0, 0
	MOVWF      R0+0
	MOVF       main_result_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;test.c,152 :: 		current[3]= (result/10)%10+48;
	MOVLW      3
	ADDWF      main_current_L0+0, 0
	MOVWF      FLOC__main+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       main_result_L0+0, 0
	MOVWF      R0+0
	MOVF       main_result_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;test.c,154 :: 		Lcd_Out(2,10,current);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       main_current_L0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;test.c,169 :: 		}
	GOTO       L_main3
;test.c,170 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ADC_Init:

;test.c,172 :: 		void ADC_Init()
;test.c,174 :: 		ADCON0 = 0x41; //ADC Module Turned ON and Clock is selected
	MOVLW      65
	MOVWF      ADCON0+0
;test.c,175 :: 		ADCON1 = 0xC5; //RA0_&_RA1 are analog input, all other pins as digital i/o
	MOVLW      197
	MOVWF      ADCON1+0
;test.c,177 :: 		}
L_end_ADC_Init:
	RETURN
; end of _ADC_Init

_ADC_Read:

;test.c,179 :: 		unsigned int ADC_Read(unsigned char channel)
;test.c,181 :: 		if(channel > 7) //If Invalid channel selected
	MOVF       FARG_ADC_Read_channel+0, 0
	SUBLW      7
	BTFSC      STATUS+0, 0
	GOTO       L_ADC_Read11
;test.c,182 :: 		return 0;     //Return 0
	CLRF       R0+0
	CLRF       R0+1
	GOTO       L_end_ADC_Read
L_ADC_Read11:
;test.c,184 :: 		ADCON0 &= 0xC5;       //Clearing the Channel Selection Bits
	MOVLW      197
	ANDWF      ADCON0+0, 1
;test.c,185 :: 		ADCON0 |= channel<<3; //Setting the required Bits
	MOVF       FARG_ADC_Read_channel+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      ADCON0+0, 1
;test.c,186 :: 		Delay_ms(2);          //Acquisition time to charge hold capacitor
	MOVLW      11
	MOVWF      R12+0
	MOVLW      98
	MOVWF      R13+0
L_ADC_Read12:
	DECFSZ     R13+0, 1
	GOTO       L_ADC_Read12
	DECFSZ     R12+0, 1
	GOTO       L_ADC_Read12
	NOP
;test.c,187 :: 		GO_DONE_bit = 1;      //Initializes A/D Conversion
	BSF        GO_DONE_bit+0, BitPos(GO_DONE_bit+0)
;test.c,188 :: 		while(GO_DONE_bit);   //Wait for A/D Conversion to complete
L_ADC_Read13:
	BTFSS      GO_DONE_bit+0, BitPos(GO_DONE_bit+0)
	GOTO       L_ADC_Read14
	GOTO       L_ADC_Read13
L_ADC_Read14:
;test.c,189 :: 		return ((ADRESH<<8)+ADRESL); //Returns Result
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;test.c,190 :: 		}
L_end_ADC_Read:
	RETURN
; end of _ADC_Read

_encoder:

;test.c,192 :: 		char encoder(char last, char pols)
;test.c,194 :: 		char count = last;
	MOVF       FARG_encoder_last+0, 0
	MOVWF      R1+0
;test.c,195 :: 		char temp = pols;
	MOVF       FARG_encoder_pols+0, 0
	MOVWF      R2+0
;test.c,197 :: 		switch(pols)
	GOTO       L_encoder15
;test.c,199 :: 		case 0x00: if(temp==0x80) //CW
L_encoder17:
	MOVF       R2+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_encoder18
;test.c,200 :: 		count++;
	INCF       R1+0, 1
L_encoder18:
;test.c,201 :: 		if(temp==0x40) //CCW
	MOVF       R2+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_encoder19
;test.c,202 :: 		count--;
	DECF       R1+0, 1
L_encoder19:
;test.c,203 :: 		break;
	GOTO       L_encoder16
;test.c,204 :: 		case 0x80: if(temp==0xC0) //CW
L_encoder20:
	MOVF       R2+0, 0
	XORLW      192
	BTFSS      STATUS+0, 2
	GOTO       L_encoder21
;test.c,205 :: 		count++;
	INCF       R1+0, 1
L_encoder21:
;test.c,206 :: 		if(temp==0x00) //CCW
	MOVF       R2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_encoder22
;test.c,207 :: 		count--;
	DECF       R1+0, 1
L_encoder22:
;test.c,208 :: 		break;
	GOTO       L_encoder16
;test.c,209 :: 		case 0xC0: if(temp==0x40) //CW
L_encoder23:
	MOVF       R2+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_encoder24
;test.c,210 :: 		count++;
	INCF       R1+0, 1
L_encoder24:
;test.c,211 :: 		if(temp==0x80) //CCW
	MOVF       R2+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_encoder25
;test.c,212 :: 		count--;
	DECF       R1+0, 1
L_encoder25:
;test.c,213 :: 		break;
	GOTO       L_encoder16
;test.c,214 :: 		case 0x40: if(temp==0x00) //CW
L_encoder26:
	MOVF       R2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_encoder27
;test.c,215 :: 		count++;
	INCF       R1+0, 1
L_encoder27:
;test.c,216 :: 		if(temp==0xC0) //CCW
	MOVF       R2+0, 0
	XORLW      192
	BTFSS      STATUS+0, 2
	GOTO       L_encoder28
;test.c,217 :: 		count--;
	DECF       R1+0, 1
L_encoder28:
;test.c,218 :: 		break;
	GOTO       L_encoder16
;test.c,219 :: 		}
L_encoder15:
	MOVF       FARG_encoder_pols+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_encoder17
	MOVF       FARG_encoder_pols+0, 0
	XORLW      128
	BTFSC      STATUS+0, 2
	GOTO       L_encoder20
	MOVF       FARG_encoder_pols+0, 0
	XORLW      192
	BTFSC      STATUS+0, 2
	GOTO       L_encoder23
	MOVF       FARG_encoder_pols+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L_encoder26
L_encoder16:
;test.c,221 :: 		return count;
	MOVF       R1+0, 0
	MOVWF      R0+0
;test.c,222 :: 		}
L_end_encoder:
	RETURN
; end of _encoder

_sw_delayms:

;test.c,223 :: 		void sw_delayms(unsigned int d)
;test.c,226 :: 		for(x=0;x<d;x++)
	CLRF       R1+0
	CLRF       R1+1
L_sw_delayms29:
	MOVF       FARG_sw_delayms_d+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sw_delayms40
	MOVF       FARG_sw_delayms_d+0, 0
	SUBWF      R1+0, 0
L__sw_delayms40:
	BTFSC      STATUS+0, 0
	GOTO       L_sw_delayms30
;test.c,227 :: 		for(y=0;y<=1275;y++);
	CLRF       R3+0
	CLRF       R3+1
L_sw_delayms32:
	MOVLW      128
	XORLW      4
	MOVWF      R0+0
	MOVLW      128
	XORWF      R3+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sw_delayms41
	MOVF       R3+0, 0
	SUBLW      251
L__sw_delayms41:
	BTFSS      STATUS+0, 0
	GOTO       L_sw_delayms33
	INCF       R3+0, 1
	BTFSC      STATUS+0, 2
	INCF       R3+1, 1
	GOTO       L_sw_delayms32
L_sw_delayms33:
;test.c,226 :: 		for(x=0;x<d;x++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;test.c,227 :: 		for(y=0;y<=1275;y++);
	GOTO       L_sw_delayms29
L_sw_delayms30:
;test.c,228 :: 		}
L_end_sw_delayms:
	RETURN
; end of _sw_delayms

_system_init:

;test.c,230 :: 		void system_init()
;test.c,233 :: 		TRISA.B4 = 1;
	BSF        TRISA+0, 4
;test.c,234 :: 		TRISC.B6 = 1;
	BSF        TRISC+0, 6
;test.c,235 :: 		TRISC.B7 = 1;
	BSF        TRISC+0, 7
;test.c,237 :: 		position = Encoder_CLK;// Sotred the CLK position on system init, before the while loop start.
	MOVLW      0
	BTFSC      RC7_bit+0, BitPos(RC7_bit+0)
	MOVLW      1
	MOVWF      _position+0
	CLRF       _position+1
;test.c,238 :: 		}
L_end_system_init:
	RETURN
; end of _system_init
