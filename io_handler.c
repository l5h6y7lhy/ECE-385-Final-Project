//io_handler.c
#include "io_handler.h"
#include <stdio.h>
#include "alt_types.h"
#include "system.h"

#define otg_hpi_address		(volatile int*) 	0x00000060
#define otg_hpi_data		(volatile int*)	    0x00000050
#define otg_hpi_r			(volatile char*)	0x00000040
#define otg_hpi_cs			(volatile char*)	0x00000070 //FOR SOME REASON CS BASE BEHAVES WEIRDLY MIGHT HAVE TO SET MANUALLY
#define otg_hpi_w			(volatile char*)	0x00000030


void IO_init(void)
{
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
	*otg_hpi_cs = 0;
	*otg_hpi_address=Address;  //Write into the address register
	*otg_hpi_data=Data;  //Write into the data register
	*otg_hpi_w = 0;  //Enable the chip writing here
	*otg_hpi_w = 1;  //Disable writing after finishing
	*otg_hpi_cs = 1;   //Turn off the chip

}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
	*otg_hpi_cs = 0;
	*otg_hpi_address=Address;  //Write into the address register
	*otg_hpi_r = 0;  //Enable the chip reading here
	temp=*otg_hpi_data;  //Read from the data register
	*otg_hpi_r = 1;  //Disable reading after finishing
	*otg_hpi_cs = 1;   //Turn off the chip
	return temp;

}
