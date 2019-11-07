`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//Luis Armando Leon Munoz
//ELE 430
//Z994806
//Final Project
//Ping Pong game
//////////////////////////////////////////////////////////////////////////////////
module vga_game
   (
	 input wire CLK_50MHZ, RESET,
    input wire video_on,
	 input wire [1:0] btn,
    input wire [9:0] pix_x, pix_y,
    output reg [2:0] graph_rgb
   );

   // constant and signal declaration
   // x, y coordinates (0,0) to (639,479)
   localparam MAX_X = 640;
   localparam MAX_Y = 480;
	wire refr_tick;
   //--------------------------------------------
   // vertical stripe as a wall0
   //--------------------------------------------
   // wall0 left, right boundary
   localparam WALL0_X_L = 630;
   localparam WALL0_X_R = 639;
	//--------------------------------------------
   // vertical stripe as a wall1
   //--------------------------------------------
   // wall1 left, right boundary
   localparam WALL1_X_L = 0;
   localparam WALL1_X_R = 9;
   //--------------------------------------------
   // right paddle
   //--------------------------------------------
   // bar left, right boundary
   localparam BAR0_X_L = 612;
   localparam BAR0_X_R = 615;
	
	localparam BAR_Y_SIZE = 72;
	localparam BAR_V = 4;
		
	wire [9:0] bar0_y_t, bar0_y_b;
	reg [9:0] bar0_y_reg, bar0_y_next;
	//--------------------------------------------
   // left paddle
   //--------------------------------------------
   // bar left, right boundary
   localparam BAR1_X_L = 24;
   localparam BAR1_X_R = 27;
	
	wire [9:0] bar1_y_t, bar1_y_b;
	reg [9:0] bar1_y_reg, bar1_y_next;
   //--------------------------------------------
   // square ball
   //--------------------------------------------
	localparam BALL_SIZE = 8;
	
	// ball velocity can be pos or neg)
   localparam BALL_V_P = 1;
   localparam BALL_V_N = -1;
	
   // ball left, right boundary
   wire [9:0] ball_x_l, ball_x_r;
	
   // ball top, bottom boundary
   wire [9:0] ball_y_t, ball_y_b;
	
   // reg to track left, top position
   reg [9:0] ball_x_reg, ball_y_reg;
   wire [9:0] ball_x_next, ball_y_next;
	
   // reg to track ball speed
   reg [9:0] x_delta_reg, x_delta_next;
   reg [9:0] y_delta_reg, y_delta_next;
	//-------------------------------------------
	//round ball
	//-------------------------------------------
	wire [2:0] rom_addr, rom_col;
	reg [7:0] rom_data;
	wire rom_bit;
   //--------------------------------------------
   // object output signals
   //--------------------------------------------
	wire wall_right, wall_left, paddle_right, paddle_left;
   wire wall0_on,  wall1_on, bar0_on, bar1_on, sq_ball_on, rd_ball_on;
   wire [2:0] wall0_rgb, wall1_rgb, bar0_rgb, bar1_rgb, ball_rgb;

   // body
	//--------------------------------------------
   // round ball image ROM
   //--------------------------------------------
   always @*
   case (rom_addr)
      3'h0: rom_data = 8'b00111100; //   ****
      3'h1: rom_data = 8'b01111110; //  ******
      3'h2: rom_data = 8'b11111111; // ********
      3'h3: rom_data = 8'b11111111; // ********
      3'h4: rom_data = 8'b11111111; // ********
      3'h5: rom_data = 8'b11111111; // ********
      3'h6: rom_data = 8'b01111110; //  ******
      3'h7: rom_data = 8'b00111100; //   ****
   endcase

   // registers
   always @(posedge CLK_50MHZ, posedge RESET)
      if (RESET)
         begin
            bar0_y_reg <= 0;
				bar1_y_reg <= 0;
            ball_x_reg <= 0;
            ball_y_reg <= 0;
            x_delta_reg <= 10'h004;
            y_delta_reg <= 10'h004;
         end
				else
					begin
						bar0_y_reg <= bar0_y_next;
						bar1_y_reg <= bar1_y_next;
						ball_x_reg <= ball_x_next;
						ball_y_reg <= ball_y_next;
						x_delta_reg <= x_delta_next;
						y_delta_reg <= y_delta_next;
					end

   // refr_tick: 1-clock tick asserted at start of v-sync
   //            i.e., when the screen is refreshed (60 Hz)
   assign refr_tick = (pix_y==481) && (pix_x==0);
   //--------------------------------------------
   // walls strip
   //--------------------------------------------
   // pixel within wall
	assign wall_right = (WALL0_X_L<=pix_x) && (pix_x<=WALL0_X_R);
	assign wall0_on = wall_right;
	assign wall0_rgb = 3'b110; // yellow
	
	assign wall_left = (WALL1_X_L<=pix_x) && (pix_x<=WALL1_X_R);
	assign wall1_on = wall_left;
	assign wall1_rgb = 3'b110; // yellow
   //--------------------------------------------
   // paddles
   //--------------------------------------------
   // pixel within paddles
	assign bar0_y_t = bar0_y_reg;
	assign bar0_y_b = bar0_y_t + BAR_Y_SIZE - 1;
	
	assign paddle_right = (BAR0_X_L<=pix_x) && (pix_x<=BAR0_X_R) &&
								 (bar0_y_t<=pix_y) && (pix_y<=bar0_y_b);
								 
	assign bar0_on = paddle_right;
	
	assign bar0_rgb = 3'b100; // red
	
	// new paddle right y-position
   always @*
   begin
      bar0_y_next = bar0_y_reg; // no move
		
      if (refr_tick)
		
         if (btn[0] & (bar0_y_b < (MAX_Y-1-BAR_V)))
            bar0_y_next = bar0_y_reg + BAR_V; // move down
				
				else if (btn[1] & (bar0_y_t > BAR_V))
					bar0_y_next = bar0_y_reg - BAR_V; // move up
   end

	assign bar1_y_t = bar1_y_reg;
	assign bar1_y_b = bar1_y_t + BAR_Y_SIZE - 1;
								 
	assign paddle_left = (BAR1_X_L<=pix_x) && (pix_x<=BAR1_X_R) &&
                        (bar1_y_t<=pix_y) && (pix_y<=bar1_y_b);
						 
	assign bar1_on = paddle_left;
   
   assign bar1_rgb = 3'b001; // blue 
	
	// new paddle left y-position
   always @*
   begin
      bar1_y_next = bar1_y_reg; // no move
		
      if (refr_tick)
		
         if (btn[0] & (bar1_y_b < (MAX_Y-1-BAR_V)))
            bar1_y_next = bar1_y_reg + BAR_V; // move down
				
				else if (btn[1] & (bar1_y_t > BAR_V))
					bar1_y_next = bar1_y_reg - BAR_V; // move up
   end
	
	
   //--------------------------------------------
   // square ball
   //--------------------------------------------
   // pixel within squared ball
	assign ball_x_l = ball_x_reg;
   assign ball_y_t = ball_y_reg;
   assign ball_x_r = ball_x_l + BALL_SIZE - 1;
   assign ball_y_b = ball_y_t + BALL_SIZE - 1;
	
   // pixel within ball
   assign sq_ball_on = (ball_x_l<=pix_x) && (pix_x<=ball_x_r) &&
                       (ball_y_t<=pix_y) && (pix_y<=ball_y_b);
				
   // map current pixel location to ROM addr/col
   assign rom_addr = pix_y[2:0] - ball_y_t[2:0];
   assign rom_col = pix_x[2:0] - ball_x_l[2:0];
   assign rom_bit = rom_data[rom_col];
	
   // pixel within ball
   assign rd_ball_on = sq_ball_on & rom_bit;
	
   // ball rgb output
   assign ball_rgb = 3'b000;   // black
	
   // new ball position
   assign ball_x_next = (refr_tick) ? ball_x_reg + x_delta_reg :
                        ball_x_reg ; 
   assign ball_y_next = (refr_tick) ? ball_y_reg + y_delta_reg :
                        ball_y_reg ;
								
   // new ball velocity
   always @*
   begin
      x_delta_next = x_delta_reg;
      y_delta_next = y_delta_reg;
		
      if (ball_y_t < 1) // reach top
         y_delta_next = BALL_V_P;
			
				else if (ball_y_b > (MAX_Y-1)) // reach bottom
					y_delta_next = BALL_V_N;
					
					else if (ball_x_r >= WALL0_X_L) // reach wall
						x_delta_next = BALL_V_N;    // bounce back
						
					else if ((BAR0_X_L <= ball_x_r) && (ball_x_r <= BAR0_X_R) &&
						(bar0_y_t <= ball_y_b) && (ball_y_t <= bar0_y_b))
							// reach x of right bar and hit, ball bounce back
							x_delta_next = BALL_V_N;
			
				else if (ball_x_l <= WALL1_X_R) // reach wall
					x_delta_next = BALL_V_P;    // bounce back
					
      else if ((BAR1_X_L <= ball_x_l) && (ball_x_l <= BAR1_X_R) &&
               (bar1_y_t <= ball_y_b) && (ball_y_t <= bar1_y_b))
						// reach x of right bar and hit, ball bounce back
						x_delta_next = BALL_V_P;
		
   end
   //--------------------------------------------
   // rgb multiplexing circuit
   //--------------------------------------------
   always @*
      if (~video_on)
         graph_rgb = 3'b000; // blank
      else
         if (wall0_on)
            graph_rgb = wall0_rgb;
				
				else if (wall1_on)
					graph_rgb = wall1_rgb;
					
						else if (bar0_on)
							graph_rgb = bar0_rgb;
							
								else if (bar1_on)
									graph_rgb = bar1_rgb;
									
										else if (rd_ball_on)
											graph_rgb = ball_rgb;
											
         else
            graph_rgb = 3'b111; // white background

endmodule
