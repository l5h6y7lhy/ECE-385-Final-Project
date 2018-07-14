module delay(
                input Reset, over, frame_clk,  
					input [1:0] b11, 
					output blue 
       );

enum logic [1:0] {WAIT, DELAY, READY} state, next_state;
logic [15:0] counter, counter_in;
     
always_ff @ (posedge frame_clk, posedge over) begin
    if (over) begin
        state <= WAIT;
        counter <= 16'd0;
    end 
    else if (Reset) begin
        state <= WAIT;
        counter <= 16'd0;
    end
	 else begin
		  state <= next_state;
        counter <= counter_in;
	 end
end

always_comb begin
    // Next state logic
    next_state = state;
    case (state)
        // Wait until the special bean is eaten
        WAIT: begin
            if (b11==2'd3)
                next_state = DELAY;
        end
        // Wait for 8 seconds, which contain 480 frame images
        DELAY: begin
            if (counter >= 16'd480)
                next_state = READY;
        end
        // The special period is finished
        READY: begin
        end
    endcase
    // Control signals
    counter_in = 16'd0;
	 blue=1'b0;  //This variable will make all ghosts bule, which means they are in special periods
    case (state)
        WAIT: begin
        end
            
        DELAY: begin
            counter_in = counter + 16'd1;
				blue=1'b1;  //All ghosts will be in blue
        end
  
        READY: begin
        end
    endcase
end
     
endmodule
