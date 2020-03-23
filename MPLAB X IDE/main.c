#include <stdio.h>
#include <string.h>
#include "config.h"
#include "lcd.h"
#include "pin_manager.h"
#include "lcd_string.h"
#include "power_supply_control.h"

void main(void)
{
    char lcd_float_buffer[5];
    char lcd_float_result[5];
      PIN_MANAGER_Initialize();
      lcd_init();
      lcd_clear();
      strcpy(lcd_float_result,ftoa(5.25,lcd_float_buffer,LEVEL_ACCURECTY_FLOAT_TO_STRING));
      lcd_goto(0x40);
      lcd_puts(lcd_float_result); 

      

    while(1)
    {
           lcd_puts(lcd_float_result); 
           __delay_ms(1000);
        
    }

}
