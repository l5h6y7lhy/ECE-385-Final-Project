//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Hongyi Li, Qianwei Li                                            --
//      Spring 2017                                                      --
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				output logic ledl, ledr, ledu, ledd
                    );
    
    logic Reset_h, Clk;
	 logic [1:0] counterc;  //Count how many chances the Pacmann has left
	 logic over,overr,overg,overp;  //Variable indicating whether game is finished
	 logic ghost_clock,ghost_clockp;
	 logic [3:0] sum;  //Used to record score
	 logic [23:0] total, eaten,tenth,oneth;
    logic [15:0] keycode;
	 logic [9:0] DrawX, DrawY;  //The coordinates of the current drawing pixel
	 logic [10:0] BallX, BallY, BallS;  //These three represent the coordinates and the size of the ball, respectively.
	 logic [10:0] GhostX, GhostY;  //These record the positions of the red ghost
	 logic [10:0] GhostXg, GhostYg;  //These record the positions of the green ghost
	 logic [10:0] GhostXp, GhostYp;  //These record the positions of the pink ghost
	 logic [10:0] xmotion,ymotion;
	 logic Reset1,blue;  //This acts as the reset of the ball position
    
    assign Clk = CLOCK_50;
    assign {Reset_h} = ~(KEY[0]);  // The push buttons are active low
	 assign {Reset1} = ~(KEY[1]);  // The push buttons are active low
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w,hpi_cs;
	 logic wall;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)   
                            //.OTG_INT(OTG_INT)
    );
     
     //The connections for nios_system might be named different depending on how you set up Qsys
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(KEY[0]),   
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w)
    );
    
    //Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
												.Clk(Clk),
												.Reset(Reset_h),
												.VGA_HS(VGA_HS),
												.VGA_VS(VGA_VS),
												.VGA_CLK(VGA_CLK),
												.VGA_BLANK_N(VGA_BLANK_N),
												.VGA_SYNC_N(VGA_SYNC_N),
												.DrawX(DrawX),
												.DrawY(DrawY)
	 );
   
    ball ball_instance(
							.Reset(Reset1),
							.frame_clk(VGA_VS),//VGA_VS
							.BallX(BallX),
							.BallY(BallY),
							.BallS(BallS),
							.keycode(keycode),
							.ledd(ledd),
							.ledu(ledu),
							.ledl(ledl),
							.ledr(ledr),
							.xmotion(xmotion),
							.ymotion(ymotion),
							.over(over)
	 );
	 
	 ghost ghost_instance(
							.Reset(Reset1),
							.frame_clk(ghost_clock),//VGA_VS
							.BallX(BallX),
							.BallY(BallY),
							.GhostX(GhostX),
							.GhostY(GhostY),
							.xmotion(xmotion),
							.ymotion(ymotion),
							.over(over),
							.overr(overr),
							.blue(blue)
	 );
	 
	 ghostg ghost_instance0(
							.Reset(Reset1),
							.frame_clk(ghost_clock),//VGA_VS
							.BallX(BallX),
							.BallY(BallY),
							.GhostX(GhostXg),
							.GhostY(GhostYg),
							.xmotion(xmotion),
							.ymotion(ymotion),
							.over(over),
							.overg(overg),
							.blue(blue)
	 );
	 
	 ghostp ghost_instance1(
							.Reset(Reset1),
							.frame_clk(ghost_clock),//VGA_VS
							.BallX(BallX),
							.BallY(BallY),
							.GhostX(GhostXp),
							.GhostY(GhostYp),
							.xmotion(xmotion),
							.ymotion(ymotion),
							.over(over),
							.overp(overp),
							.blue(blue)
	 );
	 
	 gameover gameover1(
							.sum(sum),
							.over(over),//VGA_VS
							.BallX(BallX),
							.BallY(BallY),
							.GhostX(GhostX),
							.GhostY(GhostY),
							.GhostXg(GhostXg),
							.GhostYg(GhostYg),
							.GhostXp(GhostXp),
							.GhostYp(GhostYp),
							.blue(blue)
	 );
	 
	 ghostover gameover2(
							.blue(blue),
							.overr(overr),
							.overg(overg),
							.overp(overp),
							.BallX(BallX),
							.BallY(BallY),
							.GhostX(GhostX),
							.GhostY(GhostY),
							.GhostXg(GhostXg),
							.GhostYg(GhostYg),
							.GhostXp(GhostXp),
							.GhostYp(GhostYp)
	 );
	 
	 eatghost gameover3(
							.Reset(Reset1),
							.over(over),
							.Ghostrx(GhostX),
							.Ghostry(GhostY),
							.Ghostgx(GhostXg),
							.Ghostgy(GhostYg),
							.Ghostpx(GhostXp),
							.Ghostpy(GhostYp),
							.eaten(eaten),
							.blue(blue),
							.BallX(BallX),
							.BallY(BallY),
							.frame_clk(VGA_VS)
	 );
	 
    color_mapper color_instance(
							.BallX(BallX),
							.BallY(BallY),
							.BallS(BallS),
							.DrawX(DrawX),
							.DrawY(DrawY),
							.VGA_R(VGA_R),
							.VGA_G(VGA_G),
							.VGA_B(VGA_B),
							.frame_clk(VGA_VS),
							.Reset(Reset1),
							.sum(sum),
							.clk(Clk),
							.xmotion(xmotion),
							.ymotion(ymotion),
							.GhostX(GhostX),
							.GhostY(GhostY),
							.over(over),
							.GhostXg(GhostXg),
							.GhostYg(GhostYg),
							.GhostXp(GhostXp),
							.GhostYp(GhostYp),
							.blue(blue),
							.tenth(tenth),
							.oneth(oneth)
	 );
	 assign total=eaten+sum;  //This is the final total score
	 assign tenth=total/10;  //Record the second digit of the total score
	 assign oneth=total%10;  //Record the lower digit of the total score
	 
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
	 HexDriver hex_inst_2 (total[3:0], HEX2);
	 HexDriver hex_inst_3 (total[7:4], HEX3);
	 HexDriver hex_inst_4 (total[11:8], HEX4);
	 HexDriver hex_inst_5 (total[15:12], HEX5);
	 HexDriver hex_inst_6 (total[19:16], HEX6);
	 HexDriver hex_inst_7 (total[23:20], HEX7);
	 
	 always_ff @ (posedge VGA_VS)
    begin
       ghost_clock=~ghost_clockp;  //Flip the clock signal
    end
	 assign ghost_clockp=ghost_clock;
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
	 
endmodule
