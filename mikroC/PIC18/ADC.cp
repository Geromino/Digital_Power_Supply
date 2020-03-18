#line 1 "C:/Users/electronics/Desktop/test/source/mikroC/DPS_v2.x/DPS_v2.3/ADC.c"
#line 1 "c:/users/electronics/desktop/test/source/mikroc/dps_v2.x/dps_v2.3/adc.h"





extern void ADC_Init();
extern unsigned int ADC_Read(unsigned char channel);
#line 4 "C:/Users/electronics/Desktop/test/source/mikroC/DPS_v2.x/DPS_v2.3/ADC.c"
void ADC_Init()
{
 ADCON0 = 0x81;
 ADCON1 = 0xC5;


}

unsigned int ADC_Read(unsigned char channel)
{
 if(channel > 7)
 return 0;

 ADCON0 &= 0xC5;
 ADCON0 |= channel<<3;
 Delay_ms(2);
 GO_DONE_bit = 1;
 while(GO_DONE_bit);
 return ((ADRESH<<8)+ADRESL);
}
