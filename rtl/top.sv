module top
  (
   output [8:1] led,
   output       hsync_n,
   output       hactive,
   output       next_line,
   output       vsync_n,
   output       vactive,
   output       next_frame
   );

   logic        clk;
   logic        rst;

platform platform(.*);

   wire         henable  = 1;
   wire         hsync;
   wire [9:0]   hpos;
vga_sync_gen #(.frontporch_len(16),
               .sync_len(96),
               .backporch_len(48),
               .active_len(640))
hsync_i(.enable(henable),
        .sync(hsync),
        .active(hactive),
        .cycle(next_line),
        .counter(hpos),
        .*);
assign hsync_n = ~hsync;

assign led[1] = clk;
assign led[2] = henable;
assign led[3] = hsync_n;
assign led[4] = hactive;
assign led[5] = next_line;
assign led[6] = 1'b1;
assign led[7] = 1'b0;
assign led[8] = 1'bz;

   wire         vsync;
   wire [9:0]   vpos;
vga_sync_gen #(.frontporch_len(10),
               .sync_len(2),
               .backporch_len(33),
               .active_len(480))
vsync_i(.enable(next_line),
        .sync(vsync),
        .active(vactive),
        .cycle(next_frame),
        .counter(vpos),
        .*);
assign vsync_n = ~vsync;

endmodule
