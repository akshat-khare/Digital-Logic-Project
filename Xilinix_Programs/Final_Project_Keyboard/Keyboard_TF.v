`timescale 1ns / 1ps
module Keyboard_TF;

	// Inputs
	reg clk;
	reg reset;
	reg [3:0]ps2c;
	reg [3:0]ps2d;
	integer i, j, k;
	reg [3:0] mem_d [0:15];
	reg [3:0] mem_c [0:15];
	
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
	
	// ps2c value loop
	initial begin
		ps2c = mem_c[0];
		#50;
		for (j = 0; j < 16; j = j + 1)
			begin
			   mem_c[j] = j;
				ps2c = mem_c[j];
				#50;
			end
	end
	
	// ps2d value loop
	initial begin
		ps2d = 4'b0001;
		#50;
		ps2d = 4'b0000;
		#75;
		for (k = 0; k < 8; k = j + 1)
			begin
			   mem_d[k] = k;
				ps2d = mem_d[k];
				#50;
			end
			$stop;
	end
	
endmodule

