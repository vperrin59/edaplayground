// IEEE 1800-2017 Section 11.4.6

module tb();

  logic true;
  logic [1:0] signal;

  initial begin
    signal = 2'b10;
    #1;
    signal = 2'b00;
    #1;
    signal = 2'b11;
  end

  assign true = signal ==? 2'bx0;

  always_comb begin
    $display("signal %b, true %0d", signal, true);
  end

endmodule