

#include "lcd.h"


#define Encoder_SW  RA5_bit
#define Encoder_DT  RC6_bit
#define Encoder_CLK RC7_bit


#define VREF               5      // refernce voltage [V]
#define ADC_RES            1024   // 12 BIT ADC
#define ADC_ARRAY_SIZE     4      //
/*
 * Program flow related functions
 */
unsigned char counter;    // It will hold the count of rotary encoder.
int position;   // It will store the rotary encoder position.
void sw_delayms(unsigned int d);
int value[7];

/*
 * Functions
 */
void system_init ();
char encoder(char last, char pols);
void ADC_Init();
unsigned int ADC_Read(unsigned char channel);



typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;

bit Fup, Fdown;


const unsigned char  sinewave[256] = //256 values
{
0x80,0x83,0x86,0x89,0x8c,0x8f,0x92,0x95,0x98,0x9c,0x9f,0xa2,0xa5,0xa8,0xab,0xae,
0xb0,0xb3,0xb6,0xb9,0xbc,0xbf,0xc1,0xc4,0xc7,0xc9,0xcc,0xce,0xd1,0xd3,0xd5,0xd8,
0xda,0xdc,0xde,0xe0,0xe2,0xe4,0xe6,0xe8,0xea,0xec,0xed,0xef,0xf0,0xf2,0xf3,0xf5,
0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfc,0xfd,0xfe,0xfe,0xff,0xff,0xff,0xff,0xff,
0xff,0xff,0xff,0xff,0xff,0xff,0xfe,0xfe,0xfd,0xfc,0xfc,0xfb,0xfa,0xf9,0xf8,0xf7,
0xf6,0xf5,0xf3,0xf2,0xf0,0xef,0xed,0xec,0xea,0xe8,0xe6,0xe4,0xe2,0xe0,0xde,0xdc,
0xda,0xd8,0xd5,0xd3,0xd1,0xce,0xcc,0xc9,0xc7,0xc4,0xc1,0xbf,0xbc,0xb9,0xb6,0xb3,
0xb0,0xae,0xab,0xa8,0xa5,0xa2,0x9f,0x9c,0x98,0x95,0x92,0x8f,0x8c,0x89,0x86,0x83,
0x80,0x7c,0x79,0x76,0x73,0x70,0x6d,0x6a,0x67,0x63,0x60,0x5d,0x5a,0x57,0x54,0x51,
0x4f,0x4c,0x49,0x46,0x43,0x40,0x3e,0x3b,0x38,0x36,0x33,0x31,0x2e,0x2c,0x2a,0x27,
0x25,0x23,0x21,0x1f,0x1d,0x1b,0x19,0x17,0x15,0x13,0x12,0x10,0x0f,0x0d,0x0c,0x0a,
0x09,0x08,0x07,0x06,0x05,0x04,0x03,0x03,0x02,0x01,0x01,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x01,0x02,0x03,0x03,0x04,0x05,0x06,0x07,0x08,
0x09,0x0a,0x0c,0x0d,0x0f,0x10,0x12,0x13,0x15,0x17,0x19,0x1b,0x1d,0x1f,0x21,0x23,
0x25,0x27,0x2a,0x2c,0x2e,0x31,0x33,0x36,0x38,0x3b,0x3e,0x40,0x43,0x46,0x49,0x4c,
0x4f,0x51,0x54,0x57,0x5a,0x5d,0x60,0x63,0x67,0x6a,0x6d,0x70,0x73,0x76,0x79,0x7c
};


void main()
{
     char display[ADC_ARRAY_SIZE];
     char *voltage = "00.0";
     char *current = "0.00";
     unsigned char i;
     unsigned int a, b, result;
     //float result;

     TRISA = 0xFF;      // all input
     TRISB = 0x00;      // all output
     TRISC = 0xC0;      // RC6 & RC7 asinput
     
     PORTB = 0x00;
     PORTC = 0x00;
     
     ADCON1 = 0xC0;
     ADCON0 = 0x41;     // RA0 & RA1 as analog input, RA3 as VREF+, all other as digital i/o
     CMCON = 0x07;      // comperator disable

     lcd_init();
     Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

     lcd_puts(1, 1,  "Zchar Paparov");

    system_init();
    ADC_Init();      //Initializes ADC Module
    //lcd_puts(2, 1, "Circuit Digest");
    counter = 0;
    result = 0;
    Fup = 0;
    Fdown = 0;
    
    for(i=0;i<ADC_ARRAY_SIZE;i++) display[i]=0;

    while(1)
     {
          /*
          if (Encoder_SW == 0)
          {
             //sw_delayms(20);
             if (Encoder_SW == 0)
             {
                lcd_puts (2,1,"switch pressed");
                counter =100;
             }
          }

           if (Encoder_CLK != position)
           {
              if (Encoder_DT != position)
              {
                 counter++;
                 lcd_puts(2, 1, "                ");
                 lcd_bcd(2,1,1,counter);
              }
              else
              {
                  counter--;
                  lcd_puts(2,1,"                ");
                  lcd_bcd(2,1,1,counter);
              }
           }
           position = Encoder_CLK;
           */
           

           //PORTB = encoder(0,PORTC&0xC0);
           if(!RC6_bit) Fup=1;
           if(Fup)
           {
               counter++;
               Fup=0;
           }
           if(!RC7_bit) Fdown=1;
           if(Fdown)
           {
               counter--;
               Fdown=0;
           }
           PORTB = counter;
           
           Delay_ms(50);
           //lcd_puts(2, 1, "                ");
           //numToLcd(2,1,PORTB);
           
           a = ADC_Read(1); //Reading Analog Channel 1
           result = 5*a;
           Delay_ms(100);   //Delay
           current[0]= result/1000+48;
           current[2]= (result/100)%10+48;
           current[3]= (result/10)%10+48;
           //current[4]= (result/10)%10+48;
           Lcd_Out(2,10,current);
           
           a = ADC_Read(0); //Reading Analog Channel 0
           result = 3*a;
           //result = (VREF/ADC_RES)*a;
           //PORTB = a;       //Lower 8 bits to PORTB
           //PORTC = a>>8;    //Higher 2 bits to PORTC
           Delay_ms(100);   //Delay
           voltage[0]= result/1000+48;
           voltage[1]= (result/100)%10+48;
           voltage[3]= (result/10)%10+48;
           //current[4]= (result/10)%10+48;
           Lcd_Out(2,1,voltage);
           
           Delay_ms(50);
           
           //lcd_putch(row,col+4,'V');
           //do
           //{
                //RC3_bit =1;
                //PORTB = i++;
                //PORTB = i;
                //PORTB =  sinewave[i++];
                //Delay_ms(1500);
                //if(!i) RC3_bit = 0;
                //else RC3_bit = 1;
                //RC3_bit =0;
                //Delay_ms(1500);
           //}while(i<250);
     }
}

void ADC_Init()
{
  ADCON0 = 0x41; //ADC Module Turned ON and Clock is selected
  ADCON1 = 0xC5; //RA0_&_RA1 are analog input, all other pins as digital i/o
                 //With VREF+ exsternal reference to pin RA3
}

unsigned int ADC_Read(unsigned char channel)
{
  if(channel > 7) //If Invalid channel selected
    return 0;     //Return 0

  ADCON0 &= 0xC5;       //Clearing the Channel Selection Bits
  ADCON0 |= channel<<3; //Setting the required Bits
  Delay_ms(2);          //Acquisition time to charge hold capacitor
  GO_DONE_bit = 1;      //Initializes A/D Conversion
  while(GO_DONE_bit);   //Wait for A/D Conversion to complete
  return ((ADRESH<<8)+ADRESL); //Returns Result
}

char encoder(char last, char pols)
{
  char count = last;
  char temp = pols;
  
  switch(pols)
  {
      case 0x00: if(temp==0x80) //CW
                    count++;
                 if(temp==0x40) //CCW
                    count--;
           break;
      case 0x80: if(temp==0xC0) //CW
                    count++;
                 if(temp==0x00) //CCW
                    count--;
           break;
      case 0xC0: if(temp==0x40) //CW
                    count++;
                 if(temp==0x80) //CCW
                    count--;
           break;
      case 0x40: if(temp==0x00) //CW
                    count++;
                 if(temp==0xC0) //CCW
                    count--;
           break;
  }
  
  return count;
}
void sw_delayms(unsigned int d)
{
    int x, y;
    for(x=0;x<d;x++)
    for(y=0;y<=1275;y++);
}

void system_init()
{
    //TRISB = 0x00; // PORT B as output, This port is used for LCD
    TRISA.B4 = 1;
    TRISC.B6 = 1;
    TRISC.B7 = 1;
    //lcd_init(); // This will Initialize the LCD
    position = Encoder_CLK;// Sotred the CLK position on system init, before the while loop start.
}