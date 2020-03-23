/* 
 * File: power_supply_control
 * Author: zachar papkov
 * Comments:
 * Revision history: 1.0
 */

// This is a guard condition so that contents of this file are not included
// more than once.  
#ifndef POWER_SUPPLY_CONTROL_H_
#define POWER_SUPPLY_CONTROL_H_

#include <xc.h> // include processor files - each processor file is guarded.  
#include "config.h"


#define VREF               5      // refernce voltage [V]
#define ADC_RES            1024   // 12 BIT ADC
#define ADC_ARRAY_SIZE     4      //

#define KI  0.0048875      // current factor
#define KV  0.029768       // voltage factor


/**************************************************************************
* Function Name        : TBD
* Description          : TBD
* Input                : TBD
* Output               : None
* Return               : None
* Attention            : None
* Remarks              : None 
***************************************************************************/
 void ADC_Init(void);
 unsigned int ADC_Read(unsigned char channel);
#ifdef	__cplusplus
extern "C" {
#endif /* __cplusplus */

    // TODO If C++ is being used, regular C code needs function names to have C 
    // linkage so the functions can be used by the c code. 

#ifdef	__cplusplus
}
#endif /* __cplusplus */

#endif /* POWER_SUPPLY_CONTROL_H_ */

