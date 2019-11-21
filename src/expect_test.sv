// Code your testbench here
// or browse Examples

module tb;

  logic a;
  logic clk=0;
  
  default clocking cb @(posedge clk); endclocking
  
  always
    #5ns clk = ~clk;
  
initial begin
  $dumpfile("dump.vcd"); $dumpvars;
  $display("START");
  a = 0;
  #100ns;
  a = 1;
  #100ns;
  $finish;
end

initial begin
  #10ns;
  e_1 : expect(@(posedge clk) 1 ##1 $changed(a, @cb) |-> a==1) $display("SUCCESS 1 at %t", $time); else
    $display("FAIL 1");
  // We don't go here because above assertion is vacuous
end
  
initial begin
  #10ns;
  e_2 : expect(@(posedge clk) 1 ##1 $changed(a, @cb)) $display("SUCCESS 2 at %t", $time); else
    $display("FAIL 2 at %t", $time);
end
  
initial begin
  #10ns;
  e_3 : expect(@ (posedge clk) ##[1:$] $changed(a,@cb )) $display("SUCCESS 3 at %t", $time); else
    $display("FAIL 3 at %t", $time);
end

initial begin
  #95ns;
  e_4 : expect(@ (posedge clk) 1 ##1 $changed(a, @cb)) $display("SUCCESS 4 at %t", $time); else
    $display("FAIL 4 at %t", $time);
end
  
endmodule