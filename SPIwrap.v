module SPIwrap(MOSI, SCK, SS_n, rst_n, MISO);
	
	input MOSI, SCK, SS_n, rst_n;
	output MISO;
	wire rx_valid, tx_valid;
	wire [7:0] tx_data;
	wire [9:0] rx_data;

	SPImem SPImem1(rx_data, rx_valid, SCK, rst_n, tx_data, tx_valid);
	SPIslav SPIslav1(MOSI, MISO, SS_n, SCK, rst_n, rx_data, rx_valid, tx_data, tx_valid);

endmodule