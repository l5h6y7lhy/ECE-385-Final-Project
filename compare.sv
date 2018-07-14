module comparator (input hitu, hitd, hitl, hitr,
							input [32:0] du,dd,dl,dr,
						output logic [1:0] dir
							);

logic [32:0] n1,n2,n;
always_comb begin
	if(hitu==1'b1&&hitd==1'b1) begin n1=33'd000;  end
	else if(hitu==1'b1) begin  n1=dd;  end
	else if(hitd==1'b1) begin  n1=du;  end
	else if(du>=dd) begin n1=dd;  end
	else begin n1=du;  end
end

always_comb begin
	if(hitl==1'b1&&hitr==1'b1) begin n2=33'd000;  end
	else if(hitl==1'b1) begin  n2=dr;  end
	else if(hitr==1'b1) begin  n2=dl;  end
	else if(dl>=dr) begin n2=dr;  end
	else begin n2=dl;  end
end

always_comb begin
	if(n1>=n2&&(hitl!=1'b1||hitr!=1'b1)) begin n=n2;  end
	else if(n1<n2&&(hitu!=1'b1||hitd!=1'b1))  begin n=n1;   end
	else if(n1>=n2&&(hitl==1'b1&&hitr==1'b1)) begin n=n1; end 
	else if(n1<n2&&(hitu==1'b1&&hitd==1'b1)) begin n=n2; end
	else begin n=33'd000;  end
end

always_comb begin
	if(n==du&&hitu==1'b0) begin dir=2'b00; end
	else if(n==dd&&hitd==1'b0) begin dir=2'b01; end
	else if(n==dl&&hitl==1'b0) begin dir=2'b10; end
	else begin dir=2'b11; end
end
							
endmodule

module comparatorf (input hitu, hitd, hitl, hitr,
							input [32:0] du,dd,dl,dr,
						output logic [1:0] dir
							);

logic [32:0] n1,n2,n;
always_comb begin
	if(hitu==1'b1&&hitd==1'b1) begin n1=33'd000;  end
	else if(hitu==1'b1) begin  n1=dd;  end
	else if(hitd==1'b1) begin  n1=du;  end
	else if(du>=dd) begin n1=du;  end
	else begin n1=dd;  end
end

always_comb begin
	if(hitl==1'b1&&hitr==1'b1) begin n2=33'd000;  end
	else if(hitl==1'b1) begin  n2=dr;  end
	else if(hitr==1'b1) begin  n2=dl;  end
	else if(dl>=dr) begin n2=dl;  end
	else begin n2=dr;  end
end

always_comb begin
	if(n1>=n2) begin n=n1;  end
	else begin n=n2;  end
end

always_comb begin
	if(n==du&&hitu==1'b0) begin dir=2'b00; end
	else if(n==dd&&hitd==1'b0) begin dir=2'b01; end
	else if(n==dl&&hitl==1'b0) begin dir=2'b10; end
	else begin dir=2'b11; end
end
							
endmodule
