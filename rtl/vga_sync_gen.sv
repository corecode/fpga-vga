module vga_sync_gen
  #(
    frontporch_len = 1,
    sync_len = 1,
    backporch_len = 1,
    active_len = 1
    )
(
 input wire  clk,
 input wire  enable,
 output wire sync,
 output wire active,
 output wire cycle
 );

localparam total_len = frontporch_len + sync_len + backporch_len + active_len;
localparam total_len_bit = $clog2(total_len);

   logic [total_len_bit-1:0] counter  = 0, counter_next;
   logic [total_len_bit-1:0] compare  = 0;

   wire                      compare_match;

   enum {
                     FRONTPORCH,
                     SYNC,
                     BACKPORCH,
                     ACTIVE
                     } state = FRONTPORCH, state_next;

assign sync = state == SYNC;
assign active = state == ACTIVE;
assign cycle = state == ACTIVE && compare_match;

assign compare_match = counter == compare;

always_comb
  case (state)
    FRONTPORCH: begin
       state_next    = SYNC;
       compare  = frontporch_len - 1;
    end
    SYNC: begin
       state_next    = BACKPORCH;
       compare  = frontporch_len + sync_len - 1;
    end
    BACKPORCH: begin
       state_next    = ACTIVE;
       compare  = frontporch_len + sync_len + backporch_len - 1;
    end
    ACTIVE: begin
       state_next    = FRONTPORCH;
       compare  = frontporch_len + sync_len + backporch_len + active_len - 1;
    end
  endcase

always_ff @(posedge clk)
  if (enable && compare_match)
    state   <= state_next;

always_comb
  if (state == ACTIVE && compare_match)
      counter_next  = '0;
  else
      counter_next  = counter + 1;

always_ff @(posedge clk)
  if (enable)
    counter <= counter_next;


endmodule
