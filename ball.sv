//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  03-03-2017                               --
//    Spring 2017 Distribution                                           --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Reset, 
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  over,
					input [15:0]  keycode,            // This represents the input from the keyboard
               output [10:0]  BallX, BallY, BallS, // Ball coordinates and size
					output [10:0]  xmotion,ymotion,
					output logic ledl, ledr, ledu, ledd
              );
    
    logic [10:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [10:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 logic [15:0] oldkey;  //The previous key pressed
	 logic hit0, hit1, hit2, hit3, hitu, hitd, hitl, hitr;
     
    parameter [10:0] Ball_X_Center=627;  // Center position on the X axis
    parameter [10:0] Ball_Y_Center=467;  // Center position on the Y axis
	 parameter [10:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [10:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [10:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [10:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [10:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [10:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [10:0] Ball_Size=4;        // Ball size
    
    assign BallX = Ball_X_Pos;
    assign BallY = Ball_Y_Pos;
    assign BallS = Ball_Size;
	 assign xmotion= Ball_X_Motion;
	 assign ymotion= Ball_Y_Motion;
	 
	 always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            oldkey<=16'b000;
        end
		  else if (Reset)
        begin
            oldkey<=16'b000;
        end
        else 
        begin
            if((keycode==16'h001A)||(keycode==16'h0016)||(keycode==16'h0004)||(keycode==16'h0007)) begin  oldkey<=keycode;  end  
        end
    end
    
    always_ff @ (posedge frame_clk, posedge over)
    begin
        if (over)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 11'd0;
            Ball_Y_Motion <= 11'd0;
        end
		  else if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 11'd0;
            Ball_Y_Motion <= 11'd0;
        end
        else 
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    
    always_comb
    begin
        // By default, keep motion unchanged
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        
        unique case(keycode[15:0])
 
   16'h001A:  // w (up)
begin
  if((Ball_X_Motion==1'b1 && hit0==1'b1)||(Ball_X_Motion>11'd10 && hit1==1'b1)||(Ball_Y_Motion==1'b1 && hit2==1'b1)||(Ball_Y_Motion>11'd10 && hit3==1'b1)) begin
	Ball_X_Motion_in = 11'd0;   //Clear the x velocity
	Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
  end
  else if(hitu==1'b1 || (((Ball_X_Pos+1'b1)/4)%2)==1'b0  || ((Ball_X_Pos+1'b1)%4)!=1'b0) begin
	// By default, keep motion unchanged
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
  end
  else begin
		Ball_X_Motion_in = 11'd0;   //Clear the x velocity
		Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
  end
end     

16'h0016:  // s (down)
begin
	if((Ball_X_Motion==1'b1 && hit0==1'b1)||(Ball_X_Motion>11'd10 && hit1==1'b1)||(Ball_Y_Motion==1'b1 && hit2==1'b1)||(Ball_Y_Motion>11'd10 && hit3==1'b1)) begin
	Ball_X_Motion_in = 11'd0;   //Clear the x velocity
	Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
  end
	else if(hitd==1'b1 || (((Ball_X_Pos+1'b1)/4)%2)==1'b0  || ((Ball_X_Pos+1'b1)%4)!=1'b0) begin
	// By default, keep motion unchanged
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
  end
  else begin
		Ball_X_Motion_in = 11'd0;   //Clear the x velocity
		Ball_Y_Motion_in = Ball_Y_Step;
  end
end     

16'h0004:  // a (left)
begin
   if((Ball_X_Motion==1'b1 && hit0==1'b1)||(Ball_X_Motion>11'd10 && hit1==1'b1)||(Ball_Y_Motion==1'b1 && hit2==1'b1)||(Ball_Y_Motion>11'd10 && hit3==1'b1)) begin
	Ball_X_Motion_in = 11'd0;   //Clear the x velocity
	Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
  end
    else if(hitl==1'b1 || (((Ball_Y_Pos+1'b1)/4)%2)==1'b0  || ((Ball_Y_Pos+1'b1)%4)!=1'b0) begin
	// By default, keep motion unchanged
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
  end
   else begin
		Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
		Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.
  end
end     

16'h0007:  // d (right)
begin
   if((Ball_X_Motion==1'b1 && hit0==1'b1)||(Ball_X_Motion>11'd10 && hit1==1'b1)||(Ball_Y_Motion==1'b1 && hit2==1'b1)||(Ball_Y_Motion>11'd10 && hit3==1'b1)) begin
	Ball_X_Motion_in = 11'd0;   //Clear the x velocity
	Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
  end
   else if(hitr==1'b1 || (((Ball_Y_Pos+1'b1)/4)%2)==1'b0  || ((Ball_Y_Pos+1'b1)%4)!=1'b0) begin
	// By default, keep motion unchanged
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
  end
  else begin
		Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
		Ball_X_Motion_in = Ball_X_Step; 
  end
end     

default:  // When no keys are pressed
begin
     if((Ball_X_Motion==1'b1 && hit0==1'b1)||(Ball_X_Motion>11'd10 && hit1==1'b1)||(Ball_Y_Motion==1'b1 && hit2==1'b1)||(Ball_Y_Motion>11'd10 && hit3==1'b1)) begin
	Ball_X_Motion_in = 11'd0;   //Clear the x velocity
	Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
  end
	  else if(oldkey==16'h001A  && hitu==1'b0 && (((Ball_X_Pos+1'b1)/4)%2)==1'b1  && ((Ball_X_Pos+1'b1)%4)==1'b0) begin
	    Ball_X_Motion_in = 11'd0;   //Clear the x velocity
		 Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
  end
     else if(oldkey==16'h0016  && hitd==1'b0 && (((Ball_X_Pos+1'b1)/4)%2)==1'b1  && ((Ball_X_Pos+1'b1)%4)==1'b0) begin
	    Ball_X_Motion_in = 11'd0;   //Clear the x velocity
		 Ball_Y_Motion_in = Ball_Y_Step;
  end
     else if(oldkey==16'h0004  && hitl==1'b0 && (((Ball_Y_Pos+1'b1)/4)%2)==1'b1  && ((Ball_Y_Pos+1'b1)%4)==1'b0) begin
	    Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
		 Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.
  end
     else if(oldkey==16'h0007  && hitr==1'b0 && (((Ball_Y_Pos+1'b1)/4)%2)==1'b1  && ((Ball_Y_Pos+1'b1)%4)==1'b0) begin
	    Ball_Y_Motion_in = 11'd0;   //Clear the y velocity
		 Ball_X_Motion_in = Ball_X_Step;  
  end
     else begin
		  // By default, keep motion unchanged
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
	  end
end     

endcase           
		  
        // Update the ball's position with its motion
        Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion_in;
        Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;
        
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #2/2:
          Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
          Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
          What is the difference between writing
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
          How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
          Give an answer in your Post-Lab.
    **************************************************************************************/
        
    end
	 
	 always_comb
    begin
		if(Ball_X_Motion==11'd1) begin ledr=1; end
		else begin ledr=0; end  //If the ball is moving to the right, ledr should be om
	 end
	 
	 always_comb
    begin
		if(Ball_X_Motion > 11'd10) begin ledl=1; end
		else begin ledl=0; end  //If the ball is moving to the left, ledl should be om
	 end
	 
	 always_comb
    begin
		if(Ball_Y_Motion==11'd1) begin ledd=1; end
		else begin ledd=0; end  //If the ball is moving down, ledd should be om
	 end
	 
	 always_comb
    begin
		if(Ball_Y_Motion > 11'd10) begin ledu=1; end
		else begin ledu=0; end  //If the ball is moving up, ledu should be om
	 end
	 
walldecider decider0(.DrawX(Ball_X_Pos+Ball_Size+Ball_X_Motion),.DrawY(Ball_Y_Pos),.wall_on(hit0));
walldecider decider1(.DrawX(Ball_X_Pos-Ball_Size),.DrawY(Ball_Y_Pos),.wall_on(hit1));
walldecider decider2(.DrawX(Ball_X_Pos),.DrawY(Ball_Y_Pos+Ball_Size+Ball_Y_Motion),.wall_on(hit2));
walldecider decider3(.DrawX(Ball_X_Pos),.DrawY(Ball_Y_Pos-Ball_Size),.wall_on(hit3));
walldecider decider4(.DrawX(Ball_X_Pos),.DrawY(Ball_Y_Pos-Ball_Size),.wall_on(hitu));
walldecider decider5(.DrawX(Ball_X_Pos),.DrawY(Ball_Y_Pos+1'b1+Ball_Size),.wall_on(hitd));
walldecider decider6(.DrawX(Ball_X_Pos-Ball_Size),.DrawY(Ball_Y_Pos),.wall_on(hitl));
walldecider decider7(.DrawX(Ball_X_Pos+1'b1+Ball_Size),.DrawY(Ball_Y_Pos),.wall_on(hitr));

endmodule
