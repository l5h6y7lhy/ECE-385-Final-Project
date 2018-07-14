module gameover (input [10:0] BallX,BallY,GhostX,GhostY,GhostXg,GhostYg,GhostXp,GhostYp,
						input [3:0] sum,
						input blue,
						output logic over
							);

always_comb begin
	if(BallX==GhostX&&BallY==GhostY&&blue==1'b0) begin over=1'b1; end
	else if(BallX==GhostXg&&BallY==GhostYg&&blue==1'b0) begin over=1'b1; end
	else if(BallX==GhostXp&&BallY==GhostYp&&blue==1'b0) begin over=1'b1; end
	else if(sum==4'b1101) begin over=1'b1; end
	else begin over=1'b0; end
end
							
endmodule

module ghostover (input [10:0] BallX,BallY,GhostX,GhostY,GhostXg,GhostYg,GhostXp,GhostYp,
						input blue,
						output logic overr,overg,overp
							);

always_comb begin
	if(BallX==GhostX&&BallY==GhostY&&blue==1'b1) begin overr=1'b1; end
	else begin overr=1'b0; end
end

always_comb begin
	if(BallX==GhostXg&&BallY==GhostYg&&blue==1'b1) begin overg=1'b1; end
	else begin overg=1'b0; end
end

always_comb begin
	if(BallX==GhostXp&&BallY==GhostYp&&blue==1'b1) begin overp=1'b1; end
	else begin overp=1'b0; end
end
							
endmodule
