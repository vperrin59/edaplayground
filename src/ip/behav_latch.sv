module tech_nand
(
  input  wire a, b,
  output wire y
);

  localparam DEL = 1ns;

  // Avoid X propagation
  // logic out;

  // initial begin
  //   out = $random;
  // end

  // always @(*) begin
  //   out = y;
  // end

  assign #(DEL) y = ~(a & b);

endmodule

module sr_latch
(
  input  wire sb, // Inverted Set
  input  wire rb, // Inverted Reset
  output wire q,
  output wire qb
);

  tech_nand set_nand  (.a(sb), .b(qb), .y(q));
  tech_nand reset_nand(.a(rb), .b(q), .y(qb));


endmodule

module latch
(
  input  wire d,
  input  wire clk,

  output wire q,
  output wire qb
);

  // Internal set/reset s_o/r_o are active (deasserted) when CLK == 1
  // Internal set/reset s_o/r_o are deactive (asserted) when CLK == 0

  // First stage makes sure only one of the SET/RESET is active at a time.

  // Q/QB needs combination of s_o/r_o to be active/deactive in order to change
  // that's why output value only change on positive clk edge

  wire s_o, r_o;

  wire q_inv;

  assign #1ns q_inv = ~q;

  // TODO: Put inverter with delay for D

  // First stage
  // Set
  tech_nand nand1(.a(d), .b(clk), .y(s_o));
  // Reset
  tech_nand nand2(.a(~d), .b(clk), .y(r_o));

  // Second stage with feedback loop
  // Set
  tech_nand nand3(.a(s_o), .b(qb), .y(q));
  // Reset
  tech_nand nand4(.a(r_o), .b(q), .y(qb));

endmodule : latch

module tb();

  logic clk, d;
  logic q, qb;

  string mode;

  initial begin
    clk = 0;
    repeat(500)
      #5ns clk = ~clk;
  end

  localparam CLK_RPT_CNT = 3;

  initial begin
    $dumpvars(0, tb);
    $dumpfile("dump.vcd");
    d <= 1'b0;
    mode = "NORMAL";
    repeat(CLK_RPT_CNT) @(posedge clk);
    d <= ~d;
    repeat(CLK_RPT_CNT) @(posedge clk);
    d <= ~d;
    repeat(CLK_RPT_CNT) @(posedge clk);
    mode = "D TOGGLE WHEN CK 1";
    #2ns;
    // Change d after clk edge when clk is high
    d <= ~d;
    repeat(CLK_RPT_CNT) @(posedge clk);
    mode = "D TOGGLE WHEN CK 0";
    // Change d after clk edge when clk is low
    #7ns;
    d <= ~d;
    repeat(CLK_RPT_CNT) @(posedge clk);
    mode = "GLITCH ON CK";
    // Glitch on clk
    #2ns;
    force clk = 1'bx;
    #1ns;
    force clk = 1'b1;
    release clk;
    repeat(CLK_RPT_CNT) @(posedge clk);
    d <= ~d;
    repeat(CLK_RPT_CNT) @(posedge clk);
    // Glitch on clk
    #2ns;
    force clk = 1'bx;
    #1ns;
    force clk = 1'b1;
    release clk;
    $finish;
  end

  latch dut
  (
    .d(d),
    .clk(clk),
    .q  (q),
    .qb (qb)
  );

endmodule