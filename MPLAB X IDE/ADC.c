
#include <xc.h>
#include "config.h"
#include "ADC.h"

void ADC_Init(void)
{
  ADCON0 = 0x41; //ADC Module Turned ON and Clock is selected
  ADCON1 = 0xC5; //RA0_&_RA1 are analog input, all other pins as digital i/o
                 //With VREF+ exsternal reference to pin RA3
  CMCON = 0x07;  // comperator disable
}

unsigned int ADC_Read(unsigned char channel)
{
  if(channel > 7) //If Invalid channel selected
    return 0;     //Return 0

  ADCON0 &= 0xC5;         //Clearing the Channel Selection Bits
  ADCON0 |= channel<<3;   //Setting the required Bits
  __delay_ms(2);          //Acquisition time to charge hold capacitor
  GO_nDONE = 1;           //Initializes A/D Conversion
  while(GO_nDONE);        //Wait for A/D Conversion to complete
  return ((ADRESH<<8)+ADRESL); //Returns Result
}