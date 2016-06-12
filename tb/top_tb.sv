`timescale 1 ns / 100 ps

module top_tb;

   logic [8:1] led;

   logic hsync_n;
   logic hactive;
   logic next_line;
   logic vsync_n;
   logic vactive;
   logic next_frame;

top dut(.*);

initial
  #150000 $finish;

endmodule


module platform
  (
   output logic clk,
   output logic rst
   );

assign rst = 0;

initial begin
   clk  = 0;
   forever
     #10 clk++;
end

endmodule
