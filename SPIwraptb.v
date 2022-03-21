module SPIwraptb();
	
	reg MOSI, SCK, SS_n, rst_n;
	wire MISO;
	reg [7:0] tempaddr;
	reg [7:0] tempdata;
	integer i=0;
	integer j=0;

	SPIwrap SPIwrap1(MOSI, SCK, SS_n, rst_n, MISO);

	initial begin
		SCK=0;
		forever
		#1 SCK=!SCK;
	end

	initial begin
		$readmemb("mem.dat",SPIwrap1.SPImem1.mem);
	end

	initial begin
		rst_n=0;
		SS_n=1;
		MOSI=0;
		#10;
		rst_n=1;
		for (i=0;i<1000;i=i+1) begin
			SS_n=0;
			MOSI=0;
			#2
			MOSI=0;//control
			#2
			MOSI=0;//1st
			#2
			MOSI=0;
			#2
			for (j=0;j<8;j=j+1) begin
				MOSI=$random;
				tempaddr={tempaddr[6:0], MOSI};
				#2;
			end
			SS_n=1;
			#2
			if (SPIwrap1.SPImem1.addr!=tempaddr) begin
				$monitor("rx address error"); 
				$stop;
			end
			SS_n=0;
			MOSI=0;
			#2
			MOSI=0;//control
			#2
			MOSI=0;//1st
			#2
			MOSI=1;
			#2
			for (j=0;j<8;j=j+1) begin
				MOSI=$random;
				tempdata={tempdata, MOSI};
				#2;
			end
			SS_n=1;
			#2;
			if (SPIwrap1.SPImem1.mem[tempaddr]!=tempdata) begin
				$monitor("rx data error"); 
				$stop;
			end
		end
		for (i=0;i<1000;i=i+1) begin
			SS_n=0;
			MOSI=0;
			#2
			MOSI=1;//control
			#2
			MOSI=1;//1st
			#2
			MOSI=0;
			#2
			for (j=0;j<8;j=j+1) begin
				MOSI=$random;
				tempaddr={tempaddr[6:0], MOSI};
				#2;
			end
			SS_n=1;
			#2
			if (SPIwrap1.SPImem1.addr!=tempaddr) begin
				$monitor("tx address error"); 
				$stop;
			end
			SS_n=0;
			MOSI=0;
			#2
			MOSI=1;//control
			#2
			MOSI=1;//1st
			#2
			MOSI=1;
			#2
			for (j=0;j<8;j=j+1) begin
				MOSI=$random;
				#2;
			end
			#4;
			for (j=0;j<8;j=j+1) begin
				tempdata={tempdata[6:0], MISO};
				#2;
			end
			SS_n=1;
			#2;
			if (SPIwrap1.SPImem1.mem[tempaddr]!=tempdata) begin
				$monitor("tx data error"); 
				$stop;
			end
		end
		rst_n=0;
		#2;
		$stop;
	end

endmodule