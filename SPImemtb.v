module SPImemtb();
	
	reg rx_valid, clk, rst_n;
	reg [9:0] din;
	wire [7:0]dout;
	wire tx_valid;

	SPImem SPImem1(din, rx_valid, clk, rst_n, dout, tx_valid);

	initial begin
		clk=0;
		forever
		#1 clk=!clk;
	end

	initial begin
		$readmemb("mem.dat",SPImem1.mem);
	end

	initial begin
		rst_n=0;
		rx_valid=0;
		din=0;
		#10;
		rst_n=1;
		rx_valid=1;
		din='b0010101010;
		#2;
		rx_valid=1;
		din='b0110011001;
		#2;
		rx_valid=1;
		din='b0010101011;
		#2;
		rx_valid=1;
		din='b0110011010;
		#2;
		rx_valid=1;
		din='b1010101010;
		#2;
		rx_valid=0;
		din='b1111110000;
		#2;
		rx_valid=1;
		din='b1010101011;
		#2;
		rx_valid=0;
		din='b1111110000;
		#2;
		$stop;		
	end

endmodule