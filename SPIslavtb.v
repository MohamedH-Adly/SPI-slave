module SPIslavtb();
	
	reg MOSI, SS_n, tx_valid, clk, rst_n;
	wire MISO, rx_valid;
	reg [7:0] tx_data;
	wire [9:0] rx_data;

	SPIslav SPIslav1(MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);

	initial begin
		clk=0;
		forever
		#1 clk=!clk;
	end


	initial begin
		rst_n=0;
		SS_n=1;
		tx_valid=0;
		MOSI=0;
		tx_data=0;
		#10;
		rst_n=1;
		SS_n=0;
		MOSI=1;
		#2;
		MOSI=0;//control
		#2;
		MOSI=0;//1
		#2;
		MOSI=0;
		#2;
		MOSI=1;
		#2;
		MOSI=1;
		#2;
		MOSI=0;//5
		#2;
		MOSI=0;//6
		#2;
		MOSI=0;//7
		#2;
		MOSI=0;//8
		#2;
		MOSI=1;//9
		#2;
		MOSI=1;//10
		#2;
		SS_n=1;
		MOSI=0;//
		#2;
		#2;
		$stop;		
	end

endmodule