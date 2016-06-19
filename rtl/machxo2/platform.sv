module platform
  #(
    use_pll = 0
    )
  (
   output clk,
   output rst
   );

generate
   if (use_pll == 0) begin
      OSCH #(.NOM_FREQ("24.18"))
      OSCH_inst(.STDBY(1'b0),
                .OSC(clk),
                .SEDSTDBY());
   end else begin
      wire         osc_clk;

      OSCH #(.NOM_FREQ("7.00"))
      OSCH_inst(.STDBY(1'b0),
                .OSC(osc_clk),
                .SEDSTDBY());
      pll PLL_inst(.CLKI(osc_clk),
                   .CLKOP(),
                   .CLKOS(clk));
   end
endgenerate

por #(.cycles(3))
por_i(.por(rst),
      .clk(clk));

endmodule
