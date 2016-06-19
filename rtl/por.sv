module por
  #(
    parameter cycles = 2
    )
(
 output por,
 input clk
 );


   logic [cycles-1:0] por_b /* synthesis syn_preserve = 1 */ = { default:'1 };

always_ff @(posedge clk)
  por_b[0] <= '0;

for (genvar i = 0; i < cycles - 1; ++i)
  always_ff @(posedge clk)
    por_b[i + 1] <= por_b[i];

assign por = por_b[cycles-1];

endmodule
