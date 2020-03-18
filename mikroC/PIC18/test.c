
#include <math.h>
#include <stdio.h>
#include "lcd.h"
#include "ADC.h"


#define VREF               5      // refernce voltage [V]
#define ADC_RES            1024   // 12 BIT ADC
#define ADC_ARRAY_SIZE     4      //

#define KI  0.0048875      // current factor
#define KV  0.029768       // voltage factor

//#define KI  0.0049      // current factor
//#define KV  0.03        // voltage factor

//sbit _rotoryCW   at RB0_bit;
sbit _OnOffLED   at RA5_bit;
sbit _rotarySW   at RB6_bit;
sbit _swichOnOff at RA4_bit;

#define REA PORTB.B4 // Rotary encoder pin definition
#define REB PORTB.B5 //

/*
 * Program flow related functions
 */
signed int count=0; //this variable will incremented or decremented on encoder rotation
char temp[15];
unsigned char i;
bit FOutOnOff;

/*
 * Functions
 */
//void system_init ();

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
     
     //char temp[15];
     
     unsigned int a, b;
     signed int adc_count;
     float current_res;
     float voltage_res;
     float result;
     float OldResult;

    TRISA = 0x1B;      // RA2 & RA5 as output
    TRISB = 0xF0;      // RB0~RB3 as output
    TRISC = 0x00;      // all output
    TRISD = 0x00;      // all output
     
    PORTB = 0x00;
    PORTC = 0x00;
    PORTD = 0x00;
     
    //ADCON1 = 0xC5;
    //ADCON0 = 0x41;     // RA0 & RA1 as analog input, RA3 as VREF+, all other as digital i/o
    //CMCON = 0x07;      // comperator disable

    lcd_init();
    Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
    
    r_init();
    ADC_Init();      //Initializes ADC Module
    
    while(1)
     {
         if (!_swichOnOff) 
         {
            while(!_swichOnOff);
            _OnOffLED^=1;
            FOutOnOff ^=1;
            //lcd_clear();
         }

         if(adc_count >= 4095) adc_count = 0;
         if(adc_count <= 0) adc_count = 4095;
         //if (_OnOffLED)
         //{
            PORTD = adc_count;
            PORTC = (adc_count>>8)&0x0F;
           //PORTD = count;
           //PORTC = (count>>8)&0x0F;

         //}
         /*else
         {
           PORTD = 0;
           PORTC.B0 = 0;
           PORTC.B1 = 0;
           PORTC.B2 = 0;
           PORTC.B3 = 0;
         }*/
         //Delay_ms(10);

         a = ADC_Read(1); //Reading Analog Channel 1
         current_res = a*KI;
         ftoa(current_res*10,temp,2);    //ftoa(a*0.048875,temp,2); //ftoa(a*0.0049,temp,2);
         Lcd_Out(2,1,temp);
         //Lcd_Out(2,2,current);
         lcd_puts(2, 6, "[A]");
         ftoa(currentLimit,temp,2);
         lcd_puts(2, 10, "[");
         Lcd_Out(2, 11, temp);
         lcd_puts(2, 15, "]");

         b = ADC_Read(0); //Reading Analog Channel 0
         voltage_res = b*KV;
         ftoa(voltage_res-current_res,temp,1);    //ftoa(b*0.029768-a*0.0048875,temp,2); //ftoa((b*0.03-a*0.0049),temp,2);
         Lcd_Out(1,1,temp);
         //Lcd_Out(1,2,voltage);
         lcd_puts(1, 5, "[V]");
         ftoa(voltageLimit,temp,1);
         lcd_puts(1, 10, "[");
         Lcd_Out(1, 11, temp);
         lcd_puts(1, 15, "]");
         
         if(FOutOnOff)
        {
            if(!RB4_bit)
            {
                //voltageLimit += 0.01;
                voltageLimit += 0.1;
                //result =(((voltageLimit*4095)/30.5)+a);
                //count = (int)result;
                //adc_count = (int)(((voltageLimit*4095)/30.5)+a);    // count = (int)(((voltageLimit*4095)/30.5)+a);
                //OldResult = result*10;
                //if(((int)OldResult%10) >= 5) count++;
                //else count--;
                Delay_ms(50);
            }
            else if(!RB5_bit)
            {
                voltageLimit -= 0.1;
                Delay_ms(50);
            }
            adc_count = (int)(((voltageLimit*4095)/30.5)+a);    // count = (int)(((voltageLimit*4095)/30.5)+a);
            if(voltageLimit>=30.5) voltageLimit=30.5;
            if(voltageLimit<=0) voltageLimit=00.0;

            //if(current_res <= currentLimit)
            //{
            //    count = (int)(voltageLimit*4095)/30.5;
            //}
        }
        else adc_count = 0;
         
     }
}


// Reverses a string 'str' of length 'len'
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
// Converts a given integer x to string str[].
// d is the number of digits required in the output.
// If d is more than the number of digits in x,
// then 0s are added at the beginning.
int intToStr(int x, char str[], int d)
{
    int i = 0;
    while (x) {
        str[i++] = (x % 10) + '0';
        x = x / 10;
    }

    // If number of digits required is more, then
    // add 0s at the beginning
    while (i < d)
        str[i++] = '0';

    reverse(str, i);
    str[i] = '\0';
    return i;
}
// Converts a floating-point/double number to a string.
void ftoa(float n, char* res, int afterpoint)
{
    // Extract integer part
    int ipart = (int)n;

    // Extract floating part
    float fpart = n - (float)ipart;

    // convert integer part to string
    int i = intToStr(ipart, res, 1);

    // check for display option after point
    if (afterpoint != 0) {
        res[i] = '.'; // add dot

        // Get the value of fraction part upto given no.
        // of points after dot. The third parameter
        // is needed to handle cases like 233.007
        fpart = fpart * pow(10, afterpoint);

        intToStr((int)fpart, res + i + 1, afterpoint);
    }
}

//
//**
//
void r_init(void)
{
    TRISB.B4=1; // set rotary encoder pins to input
    TRISB.B5=1;

    //Delay_ms(100); // Wait for UART module to stabilize

    INTCON2.RBPU =0; // enable pullups
    INTCON2.RBIP =0; // RB Port Change Interrupt - high priority
    INTCON.RBIF = 0; // clear the interrupt flag
    INTCON.RBIE = 1; // enable PORTB change interrupt
    INTCON.GIE = 1;  // enable the global interrupt
    RCON.IPEN = 0;   // Disable priority levels on interrupts (16CXXX Compatibility mode)

    //count=0;

    //IntToStr(count, text);
}
//
// **
//
void pbchange(void)
{
     unsigned char state;
     static unsigned char oldstate; // this variable need to be static as it has to retain the value between calls
     delay_ms(1); // delay for 1ms here for debounce
     state= (REB<<1 | REA); // combine the pin status and assign to state variable
     if(oldstate==0x0)
     {
         if( state ==0x1)
         {
             count--; //decrement the count
         }
         else if( state == 0x2)
         {
             count++; //decrement the count
         }
     }
     oldstate = state; // store the current state value to oldstate value this value will be used in next call

     PORTB = PORTB;    // read or Any read or write of PORTB,This will end the mismatch condition
     INTCON.RBIF = 0;  // clear the porb change intrrupt flag
}
//
//**
//
void interrupt(void)
{
     if(INTCON.RBIF==1) //check for PortB change interrupt
     {
         pbchange();    //call the routine
     }
}