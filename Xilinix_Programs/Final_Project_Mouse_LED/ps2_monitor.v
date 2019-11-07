//Listing 10.3
module ps2_monitor
   (
    input wire clk, reset,
    input wire [7:0] sw,
    input wire [2:0] btn,
    inout wire ps2d, ps2c,
    output wire tx
   );

   // constant declaration
   localparam SP=8'h20; // space in ASCII

  // symbolic state declaration
   localparam [1:0]
      idle  = 2'b00,
      send1 = 2'b01,
      send0 = 2'b10,
      sendb = 2'b11;

   // signal declaration
   reg [1:0] state_reg, state_next;
   wire [7:0] rx_data;
   reg [7:0] w_data, ascii_code;
   wire psrx_done_tick, wr_ps2;
   reg wr_uart;
   wire [3:0] hex_in;

   // body
   //====================================================
   // instantiation
   //====================================================
   // instantiate ps2 transmitter/receiver
   ps2_rxtx ps2_rxtx_unit
      (.clk(clk), .reset(reset), .wr_ps2(wr_ps2),
       .din(sw), .dout(rx_data), .ps2d(ps2d), .ps2c(ps2c),
       .rx_done_tick(psrx_done_tick), .tx_done_tick());

   // instantiate UART (only use the UART transmitter)
   uart uart_unit
      (.clk(clk), .reset(reset), .rd_uart(1'b0),
       .wr_uart(wr_uart), .rx(1'b1), .w_data(w_data),
       .tx_full(), .rx_empty(), .r_data(), .tx(tx));

   // instantiate debounce circuit
   debounce btn_db_unit
      (.clk(clk), .reset(reset), .sw(btn[0]),
       .db_level(), .db_tick(wr_ps2));


   //====================================================
   // FSM to send 3 ASCII characters
   //====================================================
   // state registers
   always @(posedge clk, posedge reset)
      if (reset)
         state_reg <= idle;
      else
         state_reg <= state_next;

   // next-state logic
   always @*
   begin
      wr_uart = 1'b0;
      w_data = SP;
      state_next = state_reg;
      case (state_reg)
         idle:
            if (psrx_done_tick) // a scan code received
               state_next = send1;
         send1: // send higher hex char
            begin
               w_data = ascii_code;
               wr_uart = 1'b1;
               state_next = send0;
            end
         send0: // send lower hex char
            begin
               w_data = ascii_code;
               wr_uart = 1'b1;
               state_next = sendb;
            end
         sendb:  // send blank char
            begin
               w_data = SP;
               wr_uart = 1'b1;
               state_next = idle;
            end
      endcase
   end

   //====================================================
   // scan code to ASCII display
   //====================================================
   // split the scan code into two 4-bit hex
   assign hex_in = (state_reg==send1)? rx_data[7:4] :
                                       rx_data[3:0];
   // hex digit to ASCII code
   always @*
    case (hex_in)
       4'h0: ascii_code = 8'h30;
       4'h1: ascii_code = 8'h31;
       4'h2: ascii_code = 8'h32;
       4'h3: ascii_code = 8'h33;
       4'h4: ascii_code = 8'h34;
       4'h5: ascii_code = 8'h35;
       4'h6: ascii_code = 8'h36;
       4'h7: ascii_code = 8'h37;
       4'h8: ascii_code = 8'h38;
       4'h9: ascii_code = 8'h39;
       4'ha: ascii_code = 8'h41;
       4'hb: ascii_code = 8'h42;
       4'hc: ascii_code = 8'h43;
       4'hd: ascii_code = 8'h44;
       4'he: ascii_code = 8'h45;
       default: ascii_code = 8'h46;
    endcase

endmodule
