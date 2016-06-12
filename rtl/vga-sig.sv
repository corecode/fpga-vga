module vga_sig
  (
   clk,
   hsync,
   vsync,
   r,
   g,
   b
   );

parameter frontporch_h  = 16;
parameter sync_h        = 96;
parameter backporch_h   = 48;
parameter active_h      = 640;

parameter frontporch_v  = 10;
parameter sync_v        = 2;
parameter backporch_v   = 33;
parameter active_v      = 480;

   input logic clk;
   output logic hsync;
   output logic vsync;
   output logic r;
   output logic g;
   output logic b;




assign r = 0;
assign g = 0;
assign b = 0;

endmodule
