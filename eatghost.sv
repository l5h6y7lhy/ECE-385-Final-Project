module eatghost (input Reset, over, frame_clk, blue,
						input [10:0] Ghostrx,Ghostry,Ghostgx,Ghostgy,Ghostpx,Ghostpy,
						input [10:0] BallX,BallY,
						output [23:0] eaten
							);

		logic [1:0] c;  //Recode how many ghosts are going to be eaten
							
always_ff @ (posedge frame_clk, posedge over, posedge blue)
    begin
        if (over==1'b1)
        begin
            eaten <=24'b000000;
        end
        else if(blue==1'b1) begin
				eaten<=eaten+5*c;  //Add scores for eating ghosts
		  end
		  else if(Reset==1'b1) begin
				eaten <=24'b000000;
		  end
		  else begin eaten<=eaten+5*c;   end
    end
	 
always_comb begin
	if((Ghostrx==BallX&&Ghostry==BallY&&blue==1'b1)&&(Ghostgx==BallX&&Ghostgy==BallY&&blue==1'b1)&&(Ghostpx==BallX&&Ghostpy==BallY&&blue==1'b1)) begin c=2'd3; end
	else if((Ghostrx==BallX&&Ghostry==BallY&&blue==1'b1)&&(Ghostgx==BallX&&Ghostgy==BallY&&blue==1'b1)) begin c=2'd2; end
	else if((Ghostrx==BallX&&Ghostry==BallY&&blue==1'b1)&&(Ghostpx==BallX&&Ghostpy==BallY&&blue==1'b1)) begin c=2'd2; end
	else if((Ghostgx==BallX&&Ghostgy==BallY&&blue==1'b1)&&(Ghostpx==BallX&&Ghostpy==BallY&&blue==1'b1)) begin c=2'd2; end
	else if(Ghostrx==BallX&&Ghostry==BallY&&blue==1'b1) begin c=2'd1; end
	else if(Ghostgx==BallX&&Ghostgy==BallY&&blue==1'b1) begin c=2'd1; end
	else if(Ghostpx==BallX&&Ghostpy==BallY&&blue==1'b1) begin c=2'd1; end
	else begin c=2'd0; end
end
							
endmodule
