// Code your testbench here
// or browse Examples

module test;
  
  logic req;
  logic ack;
  
  logic clk;
  
  always
    #5ns clk = ~clk;
  
  initial begin
    $dumpvars(0, test);
    $dumpfile("dump.vcd");
    clk = 0;
    req = 0;
    ack = 0;
    
	#100ns;
    
    req = 1;
    #100ns
    req = 1;
    #100ns
    ack = 1;
    req = 1;
    
    #1us;
    $finish;
  end
  
  
  assert property(@(posedge clk) $rose(req) |-> req until $rose(ack));
  assert property(@(posedge clk) $rose(req) |-> req s_until $rose(ack));
  assert property(@(posedge clk) $rose(req) |-> req s_until_with $rose(ack));
  
endmodule