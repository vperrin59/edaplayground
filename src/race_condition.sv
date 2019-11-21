// Code your testbench here
// or browse Examples

module race_test;
  
  logic clk1x = 0;
  logic clk2x = 0;
  
  always
    #5ns clk1x = !clk1x;
  
  int a, b;
  
  
  always @(posedge clk1x) begin
    a <= a+1;
    clk2x <= !clk2x;
  end
  
  // Problem here is that b will sample postpone value of a
  // clk2x is not triggering at the same time than clk1x but a bit later
  // This can be workaround by putting blocking assignment for clock divider
  always @(posedge clk2x) begin
    b <= a;
  end
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
    #1us
    $stop;
  end
endmodule