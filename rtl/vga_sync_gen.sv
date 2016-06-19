module vga_sync_gen
  #(
    frontporch_len = 1,
    sync_len = 1,
    backporch_len = 1,
    active_len = 1,
    localparam total_len = frontporch_len + sync_len + backporch_len + active_len,
    localparam total_len_bit = $clog2(total_len)
    )
(
 input                            clk,
 input                            rst,
 input                            enable,
 output logic                     sync,
 output logic                     active,
 output logic                     cycle,
 output logic [total_len_bit-1:0] counter
 );


   logic [total_len_bit-1:0] counter_next;
   logic [total_len_bit-1:0] compare;

   wire                      compare_match;

   enum {
         ACTIVE,
         FRONTPORCH,
         SYNC,
         BACKPORCH
         } state, state_next;

assign compare_match = counter == compare;

always_comb
  case (state)
    ACTIVE: begin
       state_next    = FRONTPORCH;
       compare  = active_len - 1;
    end
    FRONTPORCH: begin
       state_next    = SYNC;
       compare  = active_len + frontporch_len - 1;
    end
    SYNC: begin
       state_next    = BACKPORCH;
       compare  = active_len + frontporch_len + sync_len - 1;
    end
    BACKPORCH: begin
       state_next    = ACTIVE;
       compare  = active_len + frontporch_len + sync_len + backporch_len - 1;
    end
  endcase

always_comb
  if (state == BACKPORCH && compare_match)
    counter_next  = '0;
  else
    counter_next  = counter + 1;

always_ff @(posedge clk)
  if (rst) begin
     state   <= FRONTPORCH;
     sync    <= '0;
     active  <= '0;
     cycle   <= '0;
     counter <= 0;
  end else if (enable) begin
     if (compare_match) state <= state_next;
     sync                     <= state == SYNC;
     active                   <= state == ACTIVE;
     cycle                    <= state == ACTIVE && compare_match;
     counter                  <= counter_next;
  end

endmodule
