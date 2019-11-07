`timescale 1ns / 10ps
////////////////////////////////////////////////////////////////////////////////
//Luis Armando Leon Munoz
//ELE 430
//Z994806
//Final Project
//Ping Pong game
////////////////////////////////////////////////////////////////////////////////
module ping_pong_tb;

	// Inputs
	reg CLK_50MHZ;
	reg RESET;
	reg [1:0] btn;

	// Outputs
	wire hsync;
	wire vsync;
	wire [2:0] rgb;
	
	// Instantiate the Unit Under Test (UUT)
	vga_pong uut (
		.CLK_50MHZ(CLK_50MHZ), 
		.RESET(RESET), 
		.btn(btn), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);
	
	always
	begin 
	CLK_50MHZ = 1'b1;
	#50;
	CLK_50MHZ = 1'b0;
	#50;
	end

	initial 
	begin
	
	btn = 3'b00;
	#50;
	
	btn = 3'b01;
	#50;
	
	btn = 3'b01;
	#50;
	
	btn = 3'b01;
	#50;
	
	btn = 3'b10;
	#50;
	
	btn = 3'b10;
	#50;
	
	btn = 3'b11;
	#50;
	
	btn = 3'b11;
	#50;
	
	$stop;
	end
      
endmodule

