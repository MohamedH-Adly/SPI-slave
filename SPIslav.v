module SPIslav(MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
	
	parameter IDLE=3'b000, CHK_CMD=3'b001, WRITE=3'b010, READ_ADD=3'b011, READ_DATA=3'b100;
	input MOSI, SS_n, tx_valid, clk, rst_n;
	output reg MISO, rx_valid;
	input [7:0] tx_data;
	output reg [9:0] rx_data;
	reg [2:0] cs,ns;
	reg readflag;
	reg [3:0] counter;
	reg [9:0] addr_data;

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			MISO<=0;
			counter<=0;
			readflag<=0;
			addr_data<=0;
			rx_valid<=0;
			rx_data<=0;
			cs<=IDLE;
		end
		else begin
			cs<=ns;
			if (~SS_n) begin
				if (cs==IDLE) begin
					rx_valid<=0;
					MISO<=0;
				end
				else if (cs==CHK_CMD) begin
					rx_valid<=0;
					MISO<=0;				
				end
				else if (counter!=9 && cs!=READ_DATA) begin
					addr_data<={addr_data,MOSI};
					counter<=counter+1;
					rx_valid<=0;
					MISO<=0;
				end
				else if (cs==WRITE) begin
					rx_valid<=1;
					rx_data<={addr_data,MOSI};
					counter<=0;
				end
				else if (cs==READ_ADD) begin
					rx_valid<=1;
					rx_data<={addr_data,MOSI};
					counter<=0;
					readflag<=1;
				end
				else if (cs==READ_DATA) begin
					if (counter!=9 && readflag) begin
						addr_data<={addr_data,MOSI};
						counter<=counter+1;
						rx_valid<=0;
						MISO<=0;
					end
					else if (readflag) begin
						rx_valid<=1;
						rx_data<={addr_data,MOSI};
						readflag<=0;
					end
					else begin
						rx_valid<=0;
						rx_data<=0;
						if (~readflag && counter==9) begin
							counter<=0;
						end
						else if (tx_valid==1) begin
							addr_data[7:0]<=tx_data;
							MISO<=tx_data[7];
						end
						else begin
							{MISO, addr_data[6:1]}<=addr_data[6:0];
						end
					end
				end
				else begin
					rx_valid<=0;
					MISO<=0;
					counter<=0;
				end
			end
			else begin
				rx_valid<=0;
				MISO<=0;
				counter<=0;
			end
		end
	end

	always @(cs, SS_n, tx_valid, MOSI) begin
		case (cs)
			IDLE:
				if (~SS_n) begin
					ns=CHK_CMD;
				end
				else begin
					ns=IDLE;
				end
			CHK_CMD:
				if (~SS_n) begin
					if (~MOSI) begin
						ns=WRITE;
					end
					else if (~readflag) begin
						ns=READ_ADD;
					end
					else begin
						ns=READ_DATA;
					end
				end
				else begin
					ns=IDLE;
				end
			WRITE:
				if (~SS_n) begin
					ns=WRITE;
				end
				else begin
					ns=IDLE;
				end
			READ_ADD:
				if (~SS_n) begin
					ns=READ_ADD;
				end
				else begin
					ns=IDLE;
				end
			READ_DATA:
				if (~SS_n) begin
					ns=READ_DATA;
				end
				else begin
					ns=IDLE;
				end
			default: ns=IDLE;
		endcase
	end

endmodule