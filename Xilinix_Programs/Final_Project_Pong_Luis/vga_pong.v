`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//Luis Armando Leon Munoz
//ELE 430
//Z994806
//Final Project
//Ping Pong game
//////////////////////////////////////////////////////////////////////////////////
module vga_pong
   (
    input wire CLK_50MHZ, RESET,
	 input wire [1:0] btn,
    output wire hsync, vsync,
    output wire [2:0] rgb
   );

   // signal declaration
   wire [9:0] pixel_x, pixel_y;
   wire video_on, pixel_tick;
   reg [2:0] rgb_reg;
   wire [2:0] rgb_next;

   // body
   // instantiate vga sync circuit
   vga_screen unit0
      (.CLK_50MHZ(CLK_50MHZ), .RESET(RESET), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
   // instantiate graphic generator
   vga_game unit1
      (.CLK_50MHZ(CLK_50MHZ), .RESET(RESET), .btn(btn), .video_on(video_on),
		 .pix_x(pixel_x), .pix_y(pixel_y),.graph_rgb(rgb_next));
   // rgb buffer
   always @(posedge CLK_50MHZ)
      if (pixel_tick)
         rgb_reg <= rgb_next;
   // output
   assign rgb = rgb_reg;

endmodule
