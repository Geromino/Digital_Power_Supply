
_lcd_puts:

;lcd.c,27 :: 		void lcd_puts(char row, char column, const char *s)
;lcd.c,30 :: 		switch(row){
	GOTO        L_lcd_puts0
;lcd.c,31 :: 		case 1: Lcd_Cmd(_LCD_FIRST_ROW);
L_lcd_puts2:
	MOVLW       128
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,32 :: 		break;
	GOTO        L_lcd_puts1
;lcd.c,33 :: 		case 2: Lcd_Cmd(_LCD_SECOND_ROW);
L_lcd_puts3:
	MOVLW       192
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,34 :: 		break;
	GOTO        L_lcd_puts1
;lcd.c,35 :: 		case 3: Lcd_Cmd(_LCD_THIRD_ROW);
L_lcd_puts4:
	MOVLW       148
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,36 :: 		break;
	GOTO        L_lcd_puts1
;lcd.c,37 :: 		case 4: Lcd_Cmd(_LCD_FOURTH_ROW);
L_lcd_puts5:
	MOVLW       212
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,38 :: 		break;
	GOTO        L_lcd_puts1
;lcd.c,39 :: 		}
L_lcd_puts0:
	MOVF        FARG_lcd_puts_row+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_puts2
	MOVF        FARG_lcd_puts_row+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_puts3
	MOVF        FARG_lcd_puts_row+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_puts4
	MOVF        FARG_lcd_puts_row+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_puts5
L_lcd_puts1:
;lcd.c,40 :: 		for(cnt=1;cnt<column;cnt++)
	MOVLW       1
	MOVWF       lcd_puts_cnt_L0+0 
L_lcd_puts6:
	MOVF        FARG_lcd_puts_column+0, 0 
	SUBWF       lcd_puts_cnt_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_lcd_puts7
;lcd.c,42 :: 		Lcd_Cmd(_LCD_MOVE_CURSOR_RIGHT);
	MOVLW       20
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,40 :: 		for(cnt=1;cnt<column;cnt++)
	INCF        lcd_puts_cnt_L0+0, 1 
;lcd.c,43 :: 		}
	GOTO        L_lcd_puts6
L_lcd_puts7:
;lcd.c,44 :: 		while(*s)Lcd_Chr_Cp(*s++);
L_lcd_puts9:
	MOVF        FARG_lcd_puts_s+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_lcd_puts_s+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_lcd_puts_s+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_puts10
	MOVF        FARG_lcd_puts_s+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_lcd_puts_s+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_lcd_puts_s+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Lcd_Chr_CP_out_char+0
	CALL        _Lcd_Chr_CP+0, 0
	MOVLW       1
	ADDWF       FARG_lcd_puts_s+0, 1 
	MOVLW       0
	ADDWFC      FARG_lcd_puts_s+1, 1 
	ADDWFC      FARG_lcd_puts_s+2, 1 
	GOTO        L_lcd_puts9
L_lcd_puts10:
;lcd.c,45 :: 		}//End of lcd_puts function
L_end_lcd_puts:
	RETURN      0
; end of _lcd_puts

_lcd_putch:

;lcd.c,55 :: 		void lcd_putch(char row, char column, const char ch)
;lcd.c,57 :: 		Lcd_Chr(row, column, ch);
	MOVF        FARG_lcd_putch_row+0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_lcd_putch_column+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        FARG_lcd_putch_ch+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,58 :: 		}//End pf lcd_putch function
L_end_lcd_putch:
	RETURN      0
; end of _lcd_putch

_lcd_clear:

;lcd.c,67 :: 		void lcd_clear()
;lcd.c,69 :: 		Lcd_Cmd(_LCD_CLEAR);  //Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,70 :: 		}
L_end_lcd_clear:
	RETURN      0
; end of _lcd_clear

_lcd_decimal:

;lcd.c,85 :: 		void lcd_decimal(char row, char column, char digit ,unsigned int num)
;lcd.c,88 :: 		}
L_end_lcd_decimal:
	RETURN      0
; end of _lcd_decimal

_UpArrow:

;lcd.c,89 :: 		void UpArrow(char pos_row, char pos_char)
;lcd.c,93 :: 		LCD_Cmd(64);
	MOVLW       64
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,94 :: 		for (ii = 0; ii<=7; ii++) LCD_Chr_Cp(uparrow[ii]);
	CLRF        UpArrow_ii_L0+0 
L_UpArrow11:
	MOVF        UpArrow_ii_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_UpArrow12
	MOVLW       UpArrow_uparrow_L0+0
	ADDWF       UpArrow_ii_L0+0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       hi_addr(UpArrow_uparrow_L0+0)
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      TBLPTR+1, 1 
	MOVLW       higher_addr(UpArrow_uparrow_L0+0)
	MOVWF       TBLPTR+2 
	MOVLW       0
	ADDWFC      TBLPTR+2, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Lcd_Chr_CP_out_char+0
	CALL        _Lcd_Chr_CP+0, 0
	INCF        UpArrow_ii_L0+0, 1 
	GOTO        L_UpArrow11
L_UpArrow12:
;lcd.c,95 :: 		LCD_Cmd(_LCD_RETURN_HOME);
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,96 :: 		LCD_Chr(pos_row, pos_char, 0);
	MOVF        FARG_UpArrow_pos_row+0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_UpArrow_pos_char+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	CLRF        FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,97 :: 		}
L_end_UpArrow:
	RETURN      0
; end of _UpArrow

_DownArrow:

;lcd.c,99 :: 		void DownArrow(char pos_row, char pos_char) {
;lcd.c,102 :: 		LCD_Cmd(72);
	MOVLW       72
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,103 :: 		for (ii = 0; ii<=7; ii++) LCD_Chr_Cp(downarrow[ii]);
	CLRF        DownArrow_ii_L0+0 
L_DownArrow14:
	MOVF        DownArrow_ii_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_DownArrow15
	MOVLW       DownArrow_downarrow_L0+0
	ADDWF       DownArrow_ii_L0+0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       hi_addr(DownArrow_downarrow_L0+0)
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      TBLPTR+1, 1 
	MOVLW       higher_addr(DownArrow_downarrow_L0+0)
	MOVWF       TBLPTR+2 
	MOVLW       0
	ADDWFC      TBLPTR+2, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Lcd_Chr_CP_out_char+0
	CALL        _Lcd_Chr_CP+0, 0
	INCF        DownArrow_ii_L0+0, 1 
	GOTO        L_DownArrow14
L_DownArrow15:
;lcd.c,104 :: 		LCD_Cmd(_LCD_RETURN_HOME);
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lcd.c,105 :: 		LCD_Chr(pos_row, pos_char, 1);
	MOVF        FARG_DownArrow_pos_row+0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_DownArrow_pos_char+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;lcd.c,106 :: 		}
L_end_DownArrow:
	RETURN      0
; end of _DownArrow

_numToLcd:

;lcd.c,108 :: 		void numToLcd(char row, char column, unsigned char num)
;lcd.c,110 :: 		lcd_putch(row,column,(num/100)+0x30);
	MOVF        FARG_numToLcd_row+0, 0 
	MOVWF       FARG_lcd_putch_row+0 
	MOVF        FARG_numToLcd_column+0, 0 
	MOVWF       FARG_lcd_putch_column+0 
	MOVLW       100
	MOVWF       R4 
	MOVF        FARG_numToLcd_num+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_lcd_putch_ch+0 
	CALL        _lcd_putch+0, 0
;lcd.c,111 :: 		lcd_putch(row,column+1,((num/10)%10)+0x30);
	MOVF        FARG_numToLcd_row+0, 0 
	MOVWF       FARG_lcd_putch_row+0 
	MOVF        FARG_numToLcd_column+0, 0 
	ADDLW       1
	MOVWF       FARG_lcd_putch_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVF        FARG_numToLcd_num+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_lcd_putch_ch+0 
	CALL        _lcd_putch+0, 0
;lcd.c,112 :: 		lcd_putch(row,column+2,(num%10)+0x30);
	MOVF        FARG_numToLcd_row+0, 0 
	MOVWF       FARG_lcd_putch_row+0 
	MOVLW       2
	ADDWF       FARG_numToLcd_column+0, 0 
	MOVWF       FARG_lcd_putch_column+0 
	MOVLW       10
	MOVWF       R4 
	MOVF        FARG_numToLcd_num+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_lcd_putch_ch+0 
	CALL        _lcd_putch+0, 0
;lcd.c,114 :: 		}
L_end_numToLcd:
	RETURN      0
; end of _numToLcd
