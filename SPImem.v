module SPImem(din, rx_valid, clk, rst_n, dout, tx_valid);
	
	input rx_valid, clk, rst_n;
	parameter MEM_DEPTH=256, ADDR_SIZE=8;
	input [ADDR_SIZE+1:0] din;
	output reg [ADDR_SIZE-1:0]dout;
	output reg tx_valid;
	reg [ADDR_SIZE-1:0] addr;
	reg sent;

	reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			dout<='b0;
			tx_valid<=0;
			sent<=0;
		end
		else if (rx_valid && din[9:8]!=2'b11) begin
			if (din[9:8]==2'b01) begin
				mem[addr]<=din[7:0];
				tx_valid<=0;
			end
			else begin
				addr<=din[7:0];
				tx_valid<=0;
				if (din[9:8]==2'b10) begin
					sent<=0;
				end
				else begin
					sent<=1;
				end
			end
		end
		else if (din[9:8]==2'b11 && sent==0) begin
			dout<=mem[addr];
			tx_valid<=1;
			sent<=1;
		end
		else begin
			tx_valid<=0;
		end
	end

endmodule