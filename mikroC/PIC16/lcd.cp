#line 1 "G:/Projects/PowerSupply_Co_Yishay/mikroC/test_01.03.20/lcd.c"
#line 8 "G:/Projects/PowerSupply_Co_Yishay/mikroC/test_01.03.20/lcd.c"
sbit LCD_RS at RC4_bit;
sbit LCD_EN at RC5_bit;
sbit LCD_D4 at RC0_bit;
sbit LCD_D5 at RC1_bit;
sbit LCD_D6 at RC2_bit;
sbit LCD_D7 at RC3_bit;

sbit LCD_RS_Direction at TRISC4_bit;
sbit LCD_EN_Direction at TRISC5_bit;
sbit LCD_D4_Direction at TRISC0_bit;
sbit LCD_D5_Direction at TRISC1_bit;
sbit LCD_D6_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISC3_bit;
#line 27 "G:/Projects/PowerSupply_Co_Yishay/mikroC/test_01.03.20/lcd.c"
void
lcd_puts(char row, char column, const char *s)
{
 char cnt;
 switch(row){
 case 1: Lcd_Cmd(_LCD_FIRST_ROW);
 break;
 case 2: Lcd_Cmd(_LCD_SECOND_ROW);
 break;
 case 3: Lcd_Cmd(_LCD_THIRD_ROW);
 break;
 case 4: Lcd_Cmd(_LCD_FOURTH_ROW);
 break;
 }
 for(cnt=1;cnt<column;cnt++)Lcd_Cmd(_LCD_MOVE_CURSOR_RIGHT);
 while(*s)Lcd_Chr_Cp(*s++);
}
#line 53 "G:/Projects/PowerSupply_Co_Yishay/mikroC/test_01.03.20/lcd.c"
void
lcd_putch(char row, char column, const char ch)
{
 Lcd_Chr(row, column, ch);
}
#line 66 "G:/Projects/PowerSupply_Co_Yishay/mikroC/test_01.03.20/lcd.c"
void lcd_clear(){
 Lcd_Cmd(_LCD_CLEAR);
}
#line 83 "G:/Projects/PowerSupply_Co_Yishay/mikroC/test_01.03.20/lcd.c"
void
lcd_decimal(char row, char column, char digit ,unsigned int num)
{

}
void UpArrow(char pos_row, char pos_char) {
 const char uparrow[] = {4,14,14,21,4,4,4,4};
 char ii;
 LCD_Cmd(64);
 for (ii = 0; ii<=7; ii++) LCD_Chr_Cp(uparrow[ii]);
 LCD_Cmd(_LCD_RETURN_HOME);
 LCD_Chr(pos_row, pos_char, 0);
}

void DownArrow(char pos_row, char pos_char) {
 const char downarrow[] = {4,4,4,4,21,14,14,4};
 char ii;
 LCD_Cmd(72);
 for (ii = 0; ii<=7; ii++) LCD_Chr_Cp(downarrow[ii]);
 LCD_Cmd(_LCD_RETURN_HOME);
 LCD_Chr(pos_row, pos_char, 1);
}

void numToLcd(char row, char column, unsigned char num)
{
 lcd_putch(row,column,(num/100)+0x30);
 lcd_putch(row,column+1,((num/10)%10)+0x30);
 lcd_putch(row,column+2,(num%10)+0x30);

}
