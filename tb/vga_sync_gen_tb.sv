`timescale 1 ns / 100 ps

module vga_sync_gen_tb;

   logic clk;
   logic enable;
   logic sync;
   logic active;
   logic cycle;

vga_sync_gen #(.frontporch_len(3),
               .sync_len(2),
               .backporch_len(1),
               .active_len(4))
dut(.*);

initial
  #1500 $finish;

initial begin
   clk  = 0;
   forever
     #10 clk++;
end

initial begin
   enable  = 1;
   #400;
   forever begin
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      enable = 1;
      @(posedge clk);
      enable = 0;
   end
end


endmodule
