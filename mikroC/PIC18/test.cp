#line 1 "C:/Users/electronics/Desktop/test/source/mikroC/DPS_v2.x/DPS_v2.3/test.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/math.h"





double fabs(double d);
double floor(double x);
double ceil(double x);
double frexp(double value, int * eptr);
double ldexp(double value, int newexp);
double modf(double val, double * iptr);
double sqrt(double x);
double atan(double f);
double asin(double x);
double acos(double x);
double atan2(double y,double x);
double sin(double f);
double cos(double f);
double tan(double x);
double exp(double x);
double log(double x);
double log10(double x);
double pow(double x, double y);
double sinh(double x);
double cosh(double x);
double tanh(double x);
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdio.h"
#line 1 "c:/users/electronics/desktop/test/source/mikroc/dps_v2.x/dps_v2.3/lcd.h"






extern void lcd_puts(char row, char column, const char *s);

extern void lcd_putch(char row, char column, char out_char);

extern void lcd_decimal(char row, char column, unsigned int num);
extern void lcd_clear();
extern void UpArrow(char pos_row, char pos_char);
extern void DownArrow(char pos_row, char pos_char);
extern void numToLcd(char row, char column, unsigned char num);
#line 1 "c:/users/electronics/desktop/test/source/mikroc/dps_v2.x/dps_v2.3/adc.h"





extern void ADC_Init();
extern unsigned int ADC_Read(unsigned char channel);
#line 19 "C:/Users/electronics/Desktop/test/source/mikroC/DPS_v2.x/DPS_v2.3/test.c"
sbit _OnOffLED at RA5_bit;
sbit _rotarySW at RB6_bit;
sbit _swichOnOff at RA4_bit;
#line 29 "C:/Users/electronics/Desktop/test/source/mikroC/DPS_v2.x/DPS_v2.3/test.c"
signed int count=0;
char temp[15];
unsigned char i;
bit FOutOnOff;
#line 39 "C:/Users/electronics/Desktop/test/source/mikroC/DPS_v2.x/DPS_v2.3/test.c"
void reverse(char* str, int len);
int intToStr(int x, char str[], int d);
void ftoa(float n, char* res, int afterpoint);
void r_init(void);
void pbchange(void );

void main()
{
 char *voltage = "00.0";
 char *current = "0.00";
 char *_prevVoltage = "00.0";
 char *_prevCurrent = "0.00";
 float currentLimit = 0.00;
 float voltageLimit = 15.2;



 unsigned int a, b;
 signed int adc_count;
 float current_res;
 float voltage_res;
 float result;
 float OldResult;

 TRISA = 0x1B;
 TRISB = 0xF0;
 TRISC = 0x00;
 TRISD = 0x00;

 PORTB = 0x00;
 PORTC = 0x00;
 PORTD = 0x00;





 lcd_init();
 Lcd_Cmd(_LCD_CURSOR_OFF);

 r_init();
 ADC_Init();

 while(1)
 {
 if (!_swichOnOff)
 {
 while(!_swichOnOff);
 _OnOffLED^=1;
 FOutOnOff ^=1;

 }

 if(adc_count >= 4095) adc_count = 0;
 if(adc_count <= 0) adc_count = 4095;


 PORTD = adc_count;
 PORTC = (adc_count>>8)&0x0F;
#line 112 "C:/Users/electronics/Desktop/test/source/mikroC/DPS_v2.x/DPS_v2.3/test.c"
 a = ADC_Read(1);
 current_res = a* 0.0048875 ;
 ftoa(current_res*10,temp,2);
 Lcd_Out(2,1,temp);

 lcd_puts(2, 6, "[A]");
 ftoa(currentLimit,temp,2);
 lcd_puts(2, 10, "[");
 Lcd_Out(2, 11, temp);
 lcd_puts(2, 15, "]");

 b = ADC_Read(0);
 voltage_res = b* 0.029768 ;
 ftoa(voltage_res-current_res,temp,1);
 Lcd_Out(1,1,temp);

 lcd_puts(1, 5, "[V]");
 ftoa(voltageLimit,temp,1);
 lcd_puts(1, 10, "[");
 Lcd_Out(1, 11, temp);
 lcd_puts(1, 15, "]");

 if(FOutOnOff)
 {
 if(!RB4_bit)
 {

 voltageLimit += 0.1;






 Delay_ms(50);
 }
 else if(!RB5_bit)
 {
 voltageLimit -= 0.1;
 Delay_ms(50);
 }
 adc_count = (int)(((voltageLimit*4095)/30.5)+a);
 if(voltageLimit>=30.5) voltageLimit=30.5;
 if(voltageLimit<=0) voltageLimit=00.0;





 }
 else adc_count = 0;

 }
}



void reverse(char* str, int len)
{
 int i = 0, j = len - 1, temp;
 while (i < j) {
 temp = str[i];
 str[i] = str[j];
 str[j] = temp;
 i++;
 j--;
 }
}




int intToStr(int x, char str[], int d)
{
 int i = 0;
 while (x) {
 str[i++] = (x % 10) + '0';
 x = x / 10;
 }



 while (i < d)
 str[i++] = '0';

 reverse(str, i);
 str[i] = '\0';
 return i;
}

void ftoa(float n, char* res, int afterpoint)
{

 int ipart = (int)n;


 float fpart = n - (float)ipart;


 int i = intToStr(ipart, res, 1);


 if (afterpoint != 0) {
 res[i] = '.';




 fpart = fpart * pow(10, afterpoint);

 intToStr((int)fpart, res + i + 1, afterpoint);
 }
}




void r_init(void)
{
 TRISB.B4=1;
 TRISB.B5=1;



 INTCON2.RBPU =0;
 INTCON2.RBIP =0;
 INTCON.RBIF = 0;
 INTCON.RBIE = 1;
 INTCON.GIE = 1;
 RCON.IPEN = 0;




}



void pbchange(void)
{
 unsigned char state;
 static unsigned char oldstate;
 delay_ms(1);
 state= ( PORTB.B5 <<1 |  PORTB.B4 );
 if(oldstate==0x0)
 {
 if( state ==0x1)
 {
 count--;
 }
 else if( state == 0x2)
 {
 count++;
 }
 }
 oldstate = state;

 PORTB = PORTB;
 INTCON.RBIF = 0;
}



void interrupt(void)
{
 if(INTCON.RBIF==1)
 {
 pbchange();
 }
}
