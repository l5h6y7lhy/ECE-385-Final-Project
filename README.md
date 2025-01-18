# ECE-385-Final-Project
We design a Pacman game by using FPGA and SoCs. In addition to hardware-software interfaces, we also design and include the AI for ghost motions. As a result, users can use keyboards to control the motion of Pacman, while the three ghosts can intelligently chase the Pacman. There are also additional features like life keeping and score recordings on the screen.

Here are the file descriptions:

**1111.txt, 2222.txt, 3333.txt, 4444.txt, 5555.txt:** The hex values for the sprites of the Pacman, with a closed mouth or an open mouth to the up, down, left or right direction. These values are stored in the on-chip memory.

**Color_Mapper.sv:** This module is used to determine which object each pixel belongs to and assign corresponding colors to each pixel on the screen.

**ECE385 Final Project Report.pdf:** This report contains the design details and testing statistics.

**HexDriver.sv:** This module converts hex values to the decimal digits on the FPGA board displays. This is related to our score keeping mechanisms.

**VGA_controller.sv:** This module transfers the data from the SoC to the screen. In this way, every frame of the Pacman game can be shown on the screen.

**ball.sv:** This module implements the motion logic of the Pacman, including its response to pressed keys.

**blue.sv:** This module implements the motion logic of the ghosts, when the Pacman eats the special bean and thus all three ghosts become blue.

**compare.sv:** This module compares the distances between the Pacman and each of the three ghosts. It determines which ghost is the closest to the Pacman.

**distance.sv:** This module computes the distances between the Pacman and each of the three ghosts.

**eatghost.sv:** This module implements the logic by which the Pacman eats the ghosts, after the Pacman eats the special bean and becomes able to attack any ghost.

**font_rom.sv:** This module reads the sprites of the decimal fonts from the on-chip memory of the FPGA board.

**frameRAM1.sv:** This module implements the logic by which the current frame replaces the previous one and the next frame is computed.

**gameover.sv:** This module detects when the game is over. The game should be over when the Pacman has eaten all beans, or has used up all life chances.

**ghost.sv:** This module implements the motion logic of the red ghost.

**ghostg.sv:** This module implements the motion logic of the green ghost.

**ghostp.sv:** This module implements the motion logic of the pink ghost.

**hpi_io_intf.sv:** This module will assign data to and from the USB chip accordingly.

**io_handler.c:** This file contains the functions to handle inputs and outputs with the USB ports.

**io_handler.h:** This is the header file for functions to handle inputs and outputs with the USB ports.

**lab8.sv:** This module is the top-level controller of the whole Pacman game.

**usb.c:** This file contains the functions to handle data packets from the USB ports.

**usb.h:** This is the header file for functions to handle data packets from the USB ports.

**walldecider.sv:** This module detects if there are any walls around the Pacman.
