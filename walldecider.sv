module walldecider (input [10:0]  DrawX, DrawY,	
							output logic wall_on
							);
	always_comb begin
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
				
endmodule
