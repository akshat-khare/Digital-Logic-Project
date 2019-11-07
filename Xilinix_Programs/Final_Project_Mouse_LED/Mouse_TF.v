`timescale 1ns / 1ps
module Mouse_TF;

	// Inputs
	reg clk;
	reg reset;
	reg ps2c;
	reg ps2d;
	integer i, j, k;
	reg [3:0] mem_d [16:0];
	reg [3:0] mem_c [16:0];
	// clock loop main
	initial begin
		clk = 1'b0;
		#50;
		for (i = 0; i < 20; i = i + 1)
			begin
				clk = ~clk;
				#50;
			end
	end
	
	initial begin
		ps2c = mec_c[0];
		#50;
		for (j = 0; j < 16; j = j + 1)
			begin
			   mem[j] = j;
				ps2c = mem_c[j];
				#50;
			end
	end
	
	initial begin
		ps2c = mec_c[1];
		#50;
		ps2c = mec_c[0];
		#75;
		for (j = 0; j < 16; j = j + 1)
			begin
			   mem[j] = j;
				ps2c = mem_c[j];
				#50;
			end
	end
	
endmodule

