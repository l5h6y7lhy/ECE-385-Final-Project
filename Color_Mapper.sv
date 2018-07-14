//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  03-03-2017                               --
//                                                                       --
//    Spring 2017 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [10:0] BallX, BallY,       // Ball coordinates
                                          BallS,              // Ball size (defined in ball.sv)
                                          DrawX, DrawY,       // Coordinates of current drawing pixel
														GhostX, GhostY,    //The position of the red ghost
														GhostXg, GhostYg,    //The position of the green ghost
														GhostXp, GhostYp,    //The position of the green ghost
								input [10:0]  xmotion,ymotion,
								input [23:0] tenth,oneth,
							  input logic frame_clk, Reset, clk, over,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output
							  output logic [3:0] sum,
							  output logic blue  //This is to indicate when ghosts should become blue
                     );
    
    
    logic ball_on, wall_on, ghost_on, ghost_ong, ghost_onp;
	 logic son,con,oon,ron,eon,mon,tenthon,onethon,lon,ion,fon,e1on,m1on,life1on,life2on;
	 logic bean1on,bean2on,bean3on,bean4on,bean5on,bean6on,bean7on,bean8on,bean9on,bean10on;
	 logic Bean11on;  //These variables indicate whether beans are on or not
	 logic b1,b2,b3,b4,b5,b6,b7,b8,b9,b10;
	 logic [1:0] b11;  //These variables are used to keep scores
    logic [7:0] Red, Green, Blue,fontdata;
	 logic [18:0] address,address_ghost;
	 logic [23:0] color,color2,color3,color4,color5,color_ghost;
	 logic [5:0] counter, counter_in;
	 logic [10:0] romaddress;
	 logic [3:0] counterg,counterg_in; //count how many chances the ghost has left
	 logic [32:0] number,stay;
     
 /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
    the single line is quite powerful descriptively, it causes the synthesis tool to use up three
    of the 12 available multipliers on the chip! Since the multiplicants are required to be signed,
    we have to first cast them from logic to int (signed by default) before they are multiplied. */
      
    int Distg1,Distg2;
	 assign Distg1 = DrawX - GhostX;
    assign Distg2 = DrawY - GhostY;
	 int DistX, DistY, Size;
	 int DistX1,DistY1;
	 assign DistX1=DrawX-10'd11;
	 assign DistY1=DrawY-10'd467;
	 int DistX2,DistY2;
	 assign DistX2=DrawX-10'd27;
	 assign DistY2=DrawY-10'd219;
	 int DistX3,DistY3;
	 assign DistX3=DrawX-10'd67;
	 assign DistY3=DrawY-10'd107;
	 int DistX4,DistY4;
	 assign DistX4=DrawX-10'd131;
	 assign DistY4=DrawY-10'd227;
	 int DistX5,DistY5;
	 assign DistX5=DrawX-10'd179;
	 assign DistY5=DrawY-10'd11;
	 int DistX6,DistY6;
	 assign DistX6=DrawX-10'd275;
	 assign DistY6=DrawY-10'd467;
	 int DistX7,DistY7;
	 assign DistX7=DrawX-10'd339;
	 assign DistY7=DrawY-10'd211;
	 int DistX8,DistY8;
	 assign DistX8=DrawX-10'd419;
	 assign DistY8=DrawY-10'd11;
	 int DistX9,DistY9;
	 assign DistX9=DrawX-10'd555;
	 assign DistY9=DrawY-10'd451;
	 int DistX10,DistY10;
	 assign DistX10=DrawX-10'd627;
	 assign DistY10=DrawY-10'd163;
	 int DistX11,DistY11;
	 assign DistX11=DrawX-10'd99;
	 assign DistY11=DrawY-10'd107;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = BallS;
	 int distx1, disty1;
	 assign distx1=BallX-10'd11;
	 assign disty1=BallY-10'd467;
	 int distx2, disty2;
	 assign distx2=BallX-10'd27;
	 assign disty2=BallY-10'd219;
	 int distx3, disty3;
	 assign distx3=BallX-10'd67;
	 assign disty3=BallY-10'd107;
	 int distx4, disty4;
	 assign distx4=BallX-10'd131;
	 assign disty4=BallY-10'd227;
	 int distx5, disty5;
	 assign distx5=BallX-10'd179;
	 assign disty5=BallY-10'd11;
	 int distx6, disty6;
	 assign distx6=BallX-10'd275;
	 assign disty6=BallY-10'd467;
	 int distx7, disty7;
	 assign distx7=BallX-10'd339;
	 assign disty7=BallY-10'd211;
	 int distx8, disty8;
	 assign distx8=BallX-10'd419;
	 assign disty8=BallY-10'd11;
	 int distx9, disty9;
	 assign distx9=BallX-10'd555;
	 assign disty9=BallY-10'd451;
	 int distx10, disty10;
	 assign distx10=BallX-10'd627;
	 assign disty10=BallY-10'd163;
	 int distx11, disty11;
	 assign distx11=BallX-10'd99;
	 assign disty11=BallY-10'd107;
	 assign sum=b1+b2+b3+b4+b5+b6+b7+b8+b9+b10+b11;
    
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 assign address=(DrawY-BallY+10'd3)*8+DrawX-BallX+10'd3;
	 
	 always_comb begin
		if(son==1'b1) begin romaddress=11'd1328+DrawY-11'd24; end
		else if(con==1'b1) begin romaddress=11'd1584+DrawY-11'd24; end
		else if(oon==1'b1) begin romaddress=11'd1776+DrawY-11'd24; end
		else if(ron==1'b1) begin romaddress=11'd1824+DrawY-11'd24; end
		else if(eon==1'b1) begin romaddress=11'd1616+DrawY-11'd24; end
		else if(mon==1'b1) begin romaddress=11'd928+DrawY-11'd24; end
		else if(tenthon==1'b1) begin romaddress=(11'd48+tenth)*16+DrawY-11'd48; end
		else if(onethon==1'b1) begin romaddress=(11'd48+oneth)*16+DrawY-11'd48; end
		else if(lon==1'b1) begin romaddress=11'd1216+DrawY-11'd152; end
		else if(ion==1'b1) begin romaddress=11'd1680+DrawY-11'd152; end
		else if(fon==1'b1) begin romaddress=11'd1632+DrawY-11'd152; end
		else if(e1on==1'b1) begin romaddress=11'd1616+DrawY-11'd152; end
		else if(m1on==1'b1) begin romaddress=11'd928+DrawY-11'd152; end
		else if(life1on==1'b1||life2on==1'b1) begin romaddress=11'd48+DrawY-11'd176; end
		else begin romaddress=11'b00000;  end
	 end
	 
	 always_comb begin
		if(ghost_on==1'b1) begin address_ghost=(DrawY-GhostY+10'd3)*8+DrawX-GhostX+10'd3; end
		else if(ghost_ong==1'b1) begin address_ghost=(DrawY-GhostYg+10'd3)*8+DrawX-GhostXg+10'd3; end
		else if(ghost_onp==1'b1) begin address_ghost=(DrawY-GhostYp+10'd3)*8+DrawX-GhostXp+10'd3; end
		else begin address_ghost=(DrawY-GhostY+10'd3)*8+DrawX-GhostX+10'd3; end
	 end
    
    // Compute whether the pixel corresponds to ball or background
    always_comb
    begin : Ball_on_proc
        if ((DrawX>(BallX-10'd4))&&(DrawY>(BallY-10'd4))&&(DrawX<=(BallX+10'd4))&&(DrawY<=(BallY+10'd4))) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
    end
	 
	 always_comb begin
		if((DrawX>(GhostX-10'd4))&&(DrawY>(GhostY-10'd4))&&(DrawX<=(GhostX+10'd4))&&(DrawY<=(GhostY+10'd4))) begin
			ghost_on=1'b1;
		end
		else begin ghost_on=1'b0; end
	 end
	 
	 always_comb begin
		if((DrawX>(GhostXg-10'd4))&&(DrawY>(GhostYg-10'd4))&&(DrawX<=(GhostXg+10'd4))&&(DrawY<=(GhostYg+10'd4))) begin
			ghost_ong=1'b1;
		end
		else begin ghost_ong=1'b0; end
	 end
	 
	 always_comb begin
		if((DrawX>(GhostXp-10'd4))&&(DrawY>(GhostYp-10'd4))&&(DrawX<=(GhostXp+10'd4))&&(DrawY<=(GhostYp+10'd4))) begin
			ghost_onp=1'b1;
		end
		else begin ghost_onp=1'b0; end
	 end
	 
	 //Check if the pixel is in a bean
	 always_comb
    begin 
        if ( ( (DistX1)*(DistX1) + (DistY1)*(DistY1)) <=10'd4  ) 
            bean1on = 1'b1;
        else 
            bean1on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX2)*(DistX2) + (DistY2)*(DistY2)) <=10'd4  ) 
            bean2on = 1'b1;
        else 
            bean2on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX3)*(DistX3) + (DistY3)*(DistY3)) <=10'd4 ) 
            bean3on = 1'b1;
        else 
            bean3on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX4)*(DistX4) + (DistY4)*(DistY4)) <=10'd4 ) 
            bean4on = 1'b1;
        else 
            bean4on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX5)*(DistX5) + (DistY5)*(DistY5)) <=10'd4 ) 
            bean5on = 1'b1;
        else 
            bean5on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX6)*(DistX6) + (DistY6)*(DistY6)) <=10'd4 ) 
            bean6on = 1'b1;
        else 
            bean6on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX7)*(DistX7) + (DistY7)*(DistY7)) <=10'd4 ) 
            bean7on = 1'b1;
        else 
            bean7on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX8)*(DistX8) + (DistY8)*(DistY8)) <=10'd4 ) 
            bean8on = 1'b1;
        else 
            bean8on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX9)*(DistX9) + (DistY9)*(DistY9)) <=10'd4 ) 
            bean9on = 1'b1;
        else 
            bean9on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX10)*(DistX10) + (DistY10)*(DistY10)) <=10'd4 ) 
            bean10on = 1'b1;
        else 
            bean10on = 1'b0;
    end
	 
	 always_comb
    begin 
        if ( ( (DistX11)*(DistX11) + (DistY11)*(DistY11)) <=10'd9 ) 
            Bean11on = 1'b1;
        else 
            Bean11on = 1'b0;
    end
	 
	 always_comb begin
		if(DrawX>11'd183&&DrawX<11'd192&&DrawY>11'd23&&DrawY<11'd40) begin son=1'b1; end
		else begin son=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd191&&DrawX<11'd200&&DrawY>11'd23&&DrawY<11'd40) begin con=1'b1; end
		else begin con=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd199&&DrawX<11'd208&&DrawY>11'd23&&DrawY<11'd40) begin oon=1'b1; end
		else begin oon=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd207&&DrawX<11'd216&&DrawY>11'd23&&DrawY<11'd40) begin ron=1'b1; end
		else begin ron=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd215&&DrawX<11'd224&&DrawY>11'd23&&DrawY<11'd40) begin eon=1'b1; end
		else begin eon=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd223&&DrawX<11'd232&&DrawY>11'd23&&DrawY<11'd40) begin mon=1'b1; end
		else begin mon=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd183&&DrawX<11'd192&&DrawY>11'd47&&DrawY<11'd64) begin tenthon=1'b1; end
		else begin tenthon=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd191&&DrawX<11'd200&&DrawY>11'd47&&DrawY<11'd64) begin onethon=1'b1; end
		else begin onethon=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd183&&DrawX<11'd192&&DrawY>11'd151&&DrawY<11'd168) begin lon=1'b1; end
		else begin lon=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd191&&DrawX<11'd200&&DrawY>11'd151&&DrawY<11'd168) begin ion=1'b1; end
		else begin ion=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd199&&DrawX<11'd208&&DrawY>11'd151&&DrawY<11'd168) begin fon=1'b1; end
		else begin fon=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd207&&DrawX<11'd216&&DrawY>11'd151&&DrawY<11'd168) begin e1on=1'b1; end
		else begin e1on=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd215&&DrawX<11'd224&&DrawY>11'd151&&DrawY<11'd168) begin m1on=1'b1; end
		else begin m1on=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd183&&DrawX<11'd192&&DrawY>11'd175&&DrawY<11'd192&&counterg<4'd2) begin life1on=1'b1; end
		else begin life1on=1'b0; end
	 end
	 
	 always_comb begin
		if(DrawX>11'd191&&DrawX<11'd200&&DrawY>11'd175&&DrawY<11'd192&&counterg<4'd1) begin life2on=1'b1; end
		else begin life2on=1'b0; end
	 end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b1<=1'b0;
        end
		  else if(Reset)
		  begin
            b1<=1'b0;
        end
        else 
        begin
            if(( (distx1)*(distx1) + (disty1)*(disty1)) <=10'd16) begin  b1<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b2<=1'b0;
        end
		  else if(Reset)
		  begin
            b2<=1'b0;
        end
        else 
        begin
            if(( (distx2)*(distx2) + (disty2)*(disty2)) <=10'd16) begin  b2<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b3<=1'b0;
        end
		  else if(Reset)
		  begin
            b3<=1'b0;
        end
        else 
        begin
            if(( (distx3)*(distx3) + (disty3)*(disty3)) <=10'd16) begin  b3<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b4<=1'b0;
        end
		  else if(Reset)
		  begin
            b4<=1'b0;
        end
        else 
        begin
            if(( (distx4)*(distx4) + (disty4)*(disty4)) <=10'd16) begin  b4<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b5<=1'b0;
        end
		  else if(Reset)
		  begin
            b5<=1'b0;
        end
        else 
        begin
            if(( (distx5)*(distx5) + (disty5)*(disty5)) <=10'd16) begin  b5<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b6<=1'b0;
        end
		  else if(Reset)
		  begin
            b6<=1'b0;
        end
        else 
        begin
            if(( (distx6)*(distx6) + (disty6)*(disty6)) <=10'd16) begin  b6<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b7<=1'b0;
        end
		  else if(Reset)
		  begin
            b7<=1'b0;
        end
        else 
        begin
            if(( (distx7)*(distx7) + (disty7)*(disty7)) <=10'd16) begin  b7<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b8<=1'b0;
        end
		  else if(Reset)
		  begin
            b8<=1'b0;
        end
        else 
        begin
            if(( (distx8)*(distx8) + (disty8)*(disty8)) <=10'd16) begin  b8<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b9<=1'b0;
        end
		  else if(Reset)
		  begin
            b9<=1'b0;
        end
        else 
        begin
            if(( (distx9)*(distx9) + (disty9)*(disty9)) <=10'd16) begin  b9<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b10<=1'b0;
        end
		  else if(Reset)
		  begin
            b10<=1'b0;
        end
        else 
        begin
            if(( (distx10)*(distx10) + (disty10)*(disty10)) <=10'd16) begin  b10<=1'b1;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            b11<=1'b0;
        end
		  else if(Reset)
		  begin
            b11<=1'b0;
        end
        else 
        begin
            if(( (distx11)*(distx11) + (disty11)*(disty11)) <=10'd16) begin  b11<=2'd3;  end  
        end
    end
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            counter<=1'b0;
        end
		  else if (Reset)
        begin
            counter<=1'b0;
        end
        else 
        begin
            counter<=counter_in;  
        end
    end
	 assign counter_in=counter+1'b1;  //Set up a counter to make Pacmann open and close mouth
	 
	 always_ff @ (posedge frame_clk)
    begin
        if (Reset)
        begin
            counterg<=4'b0000;
        end
        else 
        begin
            counterg<=counterg_in;  
        end
    end
	 
	 always_comb begin
		if(blue==1'b0&&((GhostX==11'd11&&GhostY==11'd11)&&(GhostXg==11'd587&&GhostYg==11'd11)&&(GhostXp==11'd27&&GhostYp==11'd331))&&BallX==11'd627&&BallY==11'd467&&number>=33'd300&&stay==33'd1) begin
			counterg_in=counterg+4'b0001;
		end
		else begin counterg_in=counterg; end
	 end
	 
	 always_ff @ (posedge frame_clk)
    begin
        if (Reset)
        begin
            number<=33'd0;
        end
        else 
        begin
            number<=number+33'd1;  
        end
    end
	 
	 always_ff @ (posedge frame_clk)
    begin
        if (Reset)
        begin
            stay<=33'd0;
        end
        else if(BallX==11'd627&&BallY==11'd467)
        begin
            stay<=stay+33'd1;  
        end
		  else begin
				stay<=33'd0;
		  end
    end
	 
	 // Check if the pixel is in the wall
	 always_comb
	 begin
		if(DrawY < 10'd8) begin wall_on = 1'b1; end
		else if (DrawX < 10'd8) begin wall_on = 1'b1; end
		else if (DrawY > 10'd471) begin wall_on = 1'b1; end
		else if (DrawX > 10'd631) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd40 && DrawY>10'd15 && DrawY<10'd112) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd40 && DrawY>10'd119 && DrawY<10'd152) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd24 && DrawY>10'd151 && DrawY<10'd224) begin wall_on = 1'b1; end
		else if (DrawX>10'd31 && DrawX<10'd40 && DrawY>10'd159 && DrawY<10'd224) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd40 && DrawY>10'd223 && DrawY<10'd232) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd40 && DrawY>10'd239 && DrawY<10'd256) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd24 && DrawY>10'd255 && DrawY<10'd392) begin wall_on = 1'b1; end
		else if (DrawX>10'd31 && DrawX<10'd40 && DrawY>10'd263 && DrawY<10'd384) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd40 && DrawY>10'd391 && DrawY<10'd400) begin wall_on = 1'b1; end
		else if (DrawX>10'd15 && DrawX<10'd40 && DrawY>10'd407 && DrawY<10'd472) begin wall_on = 1'b1; end
		else if (DrawX>10'd47 && DrawX<10'd96 && DrawY>10'd15 && DrawY<10'd104) begin wall_on = 1'b1; end
		else if (DrawX>10'd47 && DrawX<10'd96 && DrawY>10'd111 && DrawY<10'd216) begin wall_on = 1'b1; end
		else if (DrawX>10'd47 && DrawX<10'd96 && DrawY>10'd223 && DrawY<10'd320) begin wall_on = 1'b1; end
		else if (DrawX>10'd47 && DrawX<10'd96 && DrawY>10'd327 && DrawY<10'd392) begin wall_on = 1'b1; end
		else if (DrawX>10'd47 && DrawX<10'd96 && DrawY>10'd399 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd103 && DrawX<10'd160 && DrawY>10'd15 && DrawY<10'd112) begin wall_on = 1'b1; end
		else if (DrawX>10'd103 && DrawX<10'd160 && DrawY>10'd119 && DrawY<10'd224) begin wall_on = 1'b1; end
		else if (DrawX>10'd103 && DrawX<10'd160 && DrawY>10'd231 && DrawY<10'd328) begin wall_on = 1'b1; end
		else if (DrawX>10'd103 && DrawX<10'd160 && DrawY>10'd335 && DrawY<10'd400) begin wall_on = 1'b1; end
		else if (DrawX>10'd103 && DrawX<10'd160 && DrawY>10'd407 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd167 && DrawX<10'd256 && DrawY>10'd15 && DrawY<10'd128) begin wall_on = 1'b1; end
		else if (DrawX>10'd167 && DrawX<10'd256 && DrawY>10'd135 && DrawY<10'd264) begin wall_on = 1'b1; end
		else if (DrawX>10'd167 && DrawX<10'd256 && DrawY>10'd271 && DrawY<10'd376) begin wall_on = 1'b1; end
		else if (DrawX>10'd167 && DrawX<10'd256 && DrawY>10'd383 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd263 && DrawX<10'd320 && DrawY>10'd15 && DrawY<10'd128) begin wall_on = 1'b1; end
		else if (DrawX>10'd263 && DrawX<10'd320 && DrawY>10'd135 && DrawY<10'd248) begin wall_on = 1'b1; end
		else if (DrawX>10'd263 && DrawX<10'd320 && DrawY>10'd255 && DrawY<10'd384) begin wall_on = 1'b1; end
		else if (DrawX>10'd263 && DrawX<10'd320 && DrawY>10'd391 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd327 && DrawX<10'd376 && DrawY>10'd15 && DrawY<10'd104) begin wall_on = 1'b1; end
		else if (DrawX>10'd327 && DrawX<10'd376 && DrawY>10'd111 && DrawY<10'd208) begin wall_on = 1'b1; end
		else if (DrawX>10'd327 && DrawX<10'd376 && DrawY>10'd215 && DrawY<10'd320) begin wall_on = 1'b1; end
		else if (DrawX>10'd327 && DrawX<10'd376 && DrawY>10'd327 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd383 && DrawX<10'd424 && DrawY>10'd15 && DrawY<10'd128) begin wall_on = 1'b1; end
		else if (DrawX>10'd383 && DrawX<10'd424 && DrawY>10'd135 && DrawY<10'd208) begin wall_on = 1'b1; end
		else if (DrawX>10'd383 && DrawX<10'd424 && DrawY>10'd215 && DrawY<10'd288) begin wall_on = 1'b1; end
		else if (DrawX>10'd383 && DrawX<10'd424 && DrawY>10'd295 && DrawY<10'd416) begin wall_on = 1'b1; end
		else if (DrawX>10'd383 && DrawX<10'd424 && DrawY>10'd423 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd431 && DrawX<10'd480 && DrawY>10'd15 && DrawY<10'd120) begin wall_on = 1'b1; end
		else if (DrawX>10'd431 && DrawX<10'd480 && DrawY>10'd127 && DrawY<10'd240) begin wall_on = 1'b1; end
		else if (DrawX>10'd431 && DrawX<10'd480 && DrawY>10'd247 && DrawY<10'd368) begin wall_on = 1'b1; end
		else if (DrawX>10'd431 && DrawX<10'd480 && DrawY>10'd375 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd487 && DrawX<10'd528 && DrawY>10'd7 && DrawY<10'd112) begin wall_on = 1'b1; end
		else if (DrawX>10'd487 && DrawX<10'd528 && DrawY>10'd119 && DrawY<10'd216) begin wall_on = 1'b1; end
		else if (DrawX>10'd487 && DrawX<10'd528 && DrawY>10'd223 && DrawY<10'd344) begin wall_on = 1'b1; end
		else if (DrawX>10'd487 && DrawX<10'd552 && DrawY>10'd351 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd535 && DrawX<10'd584 && DrawY>10'd15 && DrawY<10'd128) begin wall_on = 1'b1; end
		else if (DrawX>10'd535 && DrawX<10'd584 && DrawY>10'd135 && DrawY<10'd232) begin wall_on = 1'b1; end
		else if (DrawX>10'd535 && DrawX<10'd584 && DrawY>10'd239 && DrawY<10'd344) begin wall_on = 1'b1; end
		else if (DrawX>10'd559 && DrawX<10'd584  && DrawY>10'd351 && DrawY<10'd464) begin wall_on = 1'b1; end
		else if (DrawX>10'd591 && DrawX<10'd632  && DrawY>10'd15 && DrawY<10'd104) begin wall_on = 1'b1; end
		else if (DrawX>10'd591 && DrawX<10'd624  && DrawY>10'd111 && DrawY<10'd224) begin wall_on = 1'b1; end
		else if (DrawX>10'd591 && DrawX<10'd632  && DrawY>10'd231 && DrawY<10'd344) begin wall_on = 1'b1; end
		else if (DrawX>10'd591 && DrawX<10'd624  && DrawY>10'd351 && DrawY<10'd464) begin wall_on = 1'b1; end
		else begin wall_on = 1'b0;  end
	 end
    
    // Assign color based on ball_on signal
    always_comb
    begin : RGB_Display
        if ((ball_on == 1'b1)) 
        begin
		   if(counter[5]==1'b0) begin
            Red = color5[23:16];
           Green = color5[15:8];
           Blue = color5[7:0];    
				end
			else if(ymotion>11'd10) begin
           Red = color[23:16];
           Green = color[15:8];
           Blue = color[7:0];     
			end	
		  else if (ymotion==11'd1)   begin
				Red = color2[23:16];
            Green = color2[15:8];
             Blue = color2[7:0]; 
        end	
		  else if (xmotion>11'd10)   begin
				Red = color3[23:16];
            Green = color3[15:8];
             Blue = color3[7:0]; 
        end	
		  else if (xmotion==11'd1)   begin
				Red = color4[23:16];
            Green = color4[15:8];
             Blue = color4[7:0]; 
        end	
		  else begin
				Red = color5[23:16];
           Green = color5[15:8];
           Blue = color5[7:0];   
		  end
		  end
		  else if(son==1'b1) begin
				if(fontdata[11'd191-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(con==1'b1) begin
				if(fontdata[11'd199-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(oon==1'b1) begin
				if(fontdata[11'd207-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(ron==1'b1) begin
				if(fontdata[11'd215-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(eon==1'b1||e1on==1'b1) begin
				if(fontdata[11'd223-8*e1on-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(mon==1'b1||m1on==1'b1) begin
				if(fontdata[11'd231-DrawX-8*m1on]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(tenthon==1'b1) begin
				if(fontdata[11'd191-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(onethon==1'b1) begin
				if(fontdata[11'd199-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(lon==1'b1) begin
				if(fontdata[11'd191-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(ion==1'b1) begin
				if(fontdata[11'd199-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(fon==1'b1) begin
				if(fontdata[11'd207-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(life1on==1'b1) begin
				if(fontdata[11'd191-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'h26;
            Blue = 8'h26;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if(life2on==1'b1) begin
				if(fontdata[11'd199-DrawX]==1'b1) begin
					Red = 8'hff;
            Green = 8'h26;
            Blue = 8'h26;
				end
				else begin
					Red = 8'h00;
					Green = 8'h42;
					Blue = 8'hff;
				end
		  end
		  else if (wall_on == 1'b1)
		  begin
				//Blue Wall
				Red = 8'h00;
            Green = 8'h42;
            Blue = 8'hff;
		  end
		  else if(ghost_on==1'b1) begin
				if(blue==1'b1) begin
					if(color_ghost==24'hff0000) begin
					//Blue Ghost
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
				end
           end	
			  else begin
					Red = color_ghost[23:16];
           Green = color_ghost[15:8];
           Blue = color_ghost[7:0];
			  end
		  end
		  else if(ghost_ong==1'b1) begin
				if(blue==1'b1) begin
					if(color_ghost==24'hff0000) begin
					//Blue Ghost
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
				end
				end
				else begin
					if(color_ghost==24'hff0000) begin
					//Green Ghost
				Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
				end
				else begin
					Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
				end
				end
		  end
		  else if(ghost_onp==1'b1) begin
				if(blue==1'b1) begin
					if(color_ghost==24'hff0000) begin
					//Blue Ghost
				Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
				end
				end
				else begin
					if(color_ghost==24'hff0000) begin
					//Pink Ghost
				Red = 8'hff;
            Green = 8'h26;
            Blue = 8'hff;
				end
				else begin
					Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
				end
				end
		  end
		  else if((bean1on==1'b1&&b1==1'b0)||(bean2on==1'b1&&b2==1'b0)||(bean3on==1'b1&&b3==1'b0)||(bean4on==1'b1&&b4==1'b0)||(bean5on==1'b1&&b5==1'b0)||(bean6on==1'b1&&b6==1'b0)||(bean7on==1'b1&&b7==1'b0)||(bean8on==1'b1&&b8==1'b0)||(bean9on==1'b1&&b9==1'b0)||(bean10on==1'b1&&b10==1'b0)) begin
				//Red Bean
				Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h01;
		  end
		  else if(Bean11on==1'b1&&b11==1'b0) begin
				Red = 8'h50;
            Green = 8'hb9;
            Blue = 8'h48;
		  end
        else 
        begin
            // Background with nice color gradient
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
        end
    end 
    
	 frameRAM frameRAM0(.read_address(address),.Clk(clk),.data_Out(color));
	 frameRAMa frameRAM1(.read_address(address),.Clk(clk),.data_Out(color2));
	 frameRAMb frameRAM2(.read_address(address),.Clk(clk),.data_Out(color3));
	 frameRAMc frameRAM3(.read_address(address),.Clk(clk),.data_Out(color4));
	 frameRAMd frameRAM4(.read_address(address),.Clk(clk),.data_Out(color5));
	 frameRAMghost frameRAM5(.read_address(address_ghost),.Clk(clk),.data_Out(color_ghost));
	 delay blue5(.Reset(Reset),.over(over),.frame_clk(frame_clk),.b11(b11),.blue(blue));
	 font_rom font1(.addr(romaddress),.data(fontdata));
	 
endmodule
