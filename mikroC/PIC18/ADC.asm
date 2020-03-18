
_ADC_Init:

;ADC.c,4 :: 		void ADC_Init()
;ADC.c,6 :: 		ADCON0 = 0x81; //ADC Module Turned ON and Clock is selected
	MOVLW       129
	MOVWF       ADCON0+0 
;ADC.c,7 :: 		ADCON1 = 0xC5; //RA0_&_RA1 are analog input, all other pins as digital i/o
	MOVLW       197
	MOVWF       ADCON1+0 
;ADC.c,10 :: 		}
L_end_ADC_Init:
	RETURN      0
; end of _ADC_Init

_ADC_Read:

;ADC.c,12 :: 		unsigned int ADC_Read(unsigned char channel)
;ADC.c,14 :: 		if(channel > 7) //If Invalid channel selected
	MOVF        FARG_ADC_Read_channel+0, 0 
	SUBLW       7
	BTFSC       STATUS+0, 0 
	GOTO        L_ADC_Read0
;ADC.c,15 :: 		return 0;     //Return 0
	CLRF        R0 
	CLRF        R1 
	GOTO        L_end_ADC_Read
L_ADC_Read0:
;ADC.c,17 :: 		ADCON0 &= 0xC5;       //Clearing the Channel Selection Bits
	MOVLW       197
	ANDWF       ADCON0+0, 1 
;ADC.c,18 :: 		ADCON0 |= channel<<3; //Setting the required Bits
	MOVF        FARG_ADC_Read_channel+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	IORWF       ADCON0+0, 1 
;ADC.c,19 :: 		Delay_ms(2);          //Acquisition time to charge hold capacitor
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_ADC_Read1:
	DECFSZ      R13, 1, 1
	BRA         L_ADC_Read1
	DECFSZ      R12, 1, 1
	BRA         L_ADC_Read1
	NOP
	NOP
;ADC.c,20 :: 		GO_DONE_bit = 1;      //Initializes A/D Conversion
	BSF         GO_DONE_bit+0, BitPos(GO_DONE_bit+0) 
;ADC.c,21 :: 		while(GO_DONE_bit);   //Wait for A/D Conversion to complete
L_ADC_Read2:
	BTFSS       GO_DONE_bit+0, BitPos(GO_DONE_bit+0) 
	GOTO        L_ADC_Read3
	GOTO        L_ADC_Read2
L_ADC_Read3:
;ADC.c,22 :: 		return ((ADRESH<<8)+ADRESL); //Returns Result
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
;ADC.c,23 :: 		}
L_end_ADC_Read:
	RETURN      0
; end of _ADC_Read
