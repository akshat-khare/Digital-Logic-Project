`timescale 1ns / 1ps
module Main(
	tx
	rx
   );


   // tri-state buffers
   assign tx= (tri_c) ? ps2c_out : 1'bz;
   assign rx = (tri_d) ? ps2d_out : 1'bz;

endmodule
