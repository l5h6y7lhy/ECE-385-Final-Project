module  ghostg ( input         Reset, 
                             frame_clk,          // The clock indicating a new frame (~30Hz)
									  over,overg,blue,
					 input [10:0]  BallX,BallY,
					 input [10:0] xmotion,ymotion,
               output [10:0]  GhostX, GhostY // Ball coordinates and size
              );

    logic [10:0] G_X_Pos, G_X_Motion, G_Y_Pos, G_Y_Motion;
    logic [10:0] G_X_Pos_in, G_X_Motion_in, G_Y_Pos_in, G_Y_Motion_in;
	 logic [15:0] oldkey;  //The previous key pressed
	 logic hitu, hitd, hitl, hitr;
	 logic [32:0] du,dd,dl,dr;
	 logic [1:0]  dir,dir1;  //The direction of ghost motion
	 logic move;  //Indicate whether the green ghost should begin to move
     
    assign GhostX = G_X_Pos;
    assign GhostY = G_Y_Pos;
    
    always_ff @ (posedge frame_clk ,posedge over, posedge overg)
    begin
        if (over)
        begin
            G_X_Pos <= 11'd587;
            G_Y_Pos <= 11'd11;
            G_X_Motion <= 11'b0;
            G_Y_Motion <= 11'b0;
        end
		  else if (overg)
        begin
            G_X_Pos <= 11'd587;
            G_Y_Pos <= 11'd11;
            G_X_Motion <= 11'b0;
            G_Y_Motion <= 11'b0;
        end
		  else if (Reset)
        begin
            G_X_Pos <= 11'd587;
            G_Y_Pos <= 11'd11;
            G_X_Motion <= 11'b0;
            G_Y_Motion <= 11'b0;
        end
        else 
        begin
            G_X_Pos <= G_X_Pos_in;
            G_Y_Pos <= G_Y_Pos_in;
            G_X_Motion <= G_X_Motion_in;
            G_Y_Motion <= G_Y_Motion_in;
        end
    end
	 
	 always_ff @ (posedge frame_clk ,posedge over, posedge overg)
    begin
        if (over)
        begin
            move <= 1'b0;
        end
		  else if (overg)
        begin
            move <= 1'b0;
        end
		  else if (Reset)
        begin
            move <= 1'b0;
        end
        else if(xmotion!=1'b0||ymotion!=1'b0)
        begin
           move <= 1'b1;  //The ghost should begin to move
        end
    end
    
    always_comb
    begin
		if(blue==1'b0) begin
		if(G_Y_Pos==11'd155&&G_X_Pos>11'd27&&G_X_Pos<=11'd43&&BallX>11'd15&&BallX<11'd39&&BallY>11'd119&&BallY<11'd232&&move==1'b1) begin
			G_X_Motion_in=11'b11111111111;G_Y_Motion_in=11'b00000; 
		end
		else if(move==1'b1&&dir==2'b00&&((G_Y_Motion!=11'b0)||(G_Y_Motion==11'b0&&((((G_X_Pos+1'b1)/4)%2)==1'b1)&&(((G_X_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b00000;G_Y_Motion_in=11'b11111111111; 
		end
		else if(move==1'b1&&dir==2'b01&&((G_Y_Motion!=11'b0)||(G_Y_Motion==11'b0&&((((G_X_Pos+1'b1)/4)%2)==1'b1)&&(((G_X_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b0;G_Y_Motion_in=11'b0001; 
		end
		else if(move==1'b1&&dir==2'b10&&((G_X_Motion!=11'b0)||(G_X_Motion==11'b0&&((((G_Y_Pos+1'b1)/4)%2)==1'b1)&&(((G_Y_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b11111111111;G_Y_Motion_in=11'b0; 
		end
		else if(move==1'b1&&dir==2'b11&&((G_X_Motion!=11'b0)||(G_X_Motion==11'b0&&((((G_Y_Pos+1'b1)/4)%2)==1'b1)&&(((G_Y_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b00001;G_Y_Motion_in=11'b00000; 
		end
		else begin
			G_X_Motion_in=G_X_Motion;G_Y_Motion_in=G_Y_Motion;
		end
		  
        // Update the ball's position with its motion
        G_X_Pos_in = G_X_Pos + G_X_Motion_in;
        G_Y_Pos_in = G_Y_Pos + G_Y_Motion_in;
		 end
		else begin
			if(move==1'b1&&dir1==2'b00&&((G_Y_Motion!=11'b0)||(G_Y_Motion==11'b0&&((((G_X_Pos+1'b1)/4)%2)==1'b1)&&(((G_X_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b00000;G_Y_Motion_in=11'b11111111111; 
		end
		else if(move==1'b1&&dir1==2'b01&&((G_Y_Motion!=11'b0)||(G_Y_Motion==11'b0&&((((G_X_Pos+1'b1)/4)%2)==1'b1)&&(((G_X_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b0;G_Y_Motion_in=11'b0001; 
		end
		else if(move==1'b1&&dir1==2'b10&&((G_X_Motion!=11'b0)||(G_X_Motion==11'b0&&((((G_Y_Pos+1'b1)/4)%2)==1'b1)&&(((G_Y_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b11111111111;G_Y_Motion_in=11'b0; 
		end
		else if(move==1'b1&&dir1==2'b11&&((G_X_Motion!=11'b0)||(G_X_Motion==11'b0&&((((G_Y_Pos+1'b1)/4)%2)==1'b1)&&(((G_Y_Pos+1'b1)%4)==1'b0)))) begin
			G_X_Motion_in=11'b00001;G_Y_Motion_in=11'b00000; 
		end
		else begin
			G_X_Motion_in=G_X_Motion;G_Y_Motion_in=G_Y_Motion;
		end
		  
        // Update the ball's position with its motion
        G_X_Pos_in = G_X_Pos + G_X_Motion_in;
        G_Y_Pos_in = G_Y_Pos + G_Y_Motion_in;
		end
    end

walldecider decider18(.DrawX(G_X_Pos),.DrawY(G_Y_Pos-11'd4),.wall_on(hitu));
walldecider decider19(.DrawX(G_X_Pos),.DrawY(G_Y_Pos+11'd5),.wall_on(hitd));
walldecider decider110(.DrawX(G_X_Pos-11'd4),.DrawY(G_Y_Pos),.wall_on(hitl));
walldecider decider111(.DrawX(G_X_Pos+11'd5),.DrawY(G_Y_Pos),.wall_on(hitr));
distanceu distance5(.GX(G_X_Pos),.GY(G_Y_Pos),.BallX(BallX+xmotion),.BallY(BallY),.distance(du));
distanced distance6(.GX(G_X_Pos),.GY(G_Y_Pos),.BallX(BallX+xmotion),.BallY(BallY),.distance(dd));
distancel distance7(.GX(G_X_Pos),.GY(G_Y_Pos),.BallX(BallX+xmotion),.BallY(BallY),.distance(dl));
distancer distance8(.GX(G_X_Pos),.GY(G_Y_Pos),.BallX(BallX+xmotion),.BallY(BallY),.distance(dr));
comparator compare1(.hitu(hitu),.hitd(hitd),.hitl(hitl),.hitr(hitr),.du(du),.dd(dd),.dl(dl),.dr(dr),.dir(dir));
comparatorf compare21(.hitu(hitu),.hitd(hitd),.hitl(hitl),.hitr(hitr),.du(du),.dd(dd),.dl(dl),.dr(dr),.dir(dir1));

endmodule