module test;

  logic a0, a1;
  logic b0, b1;
  logic c0, c1;

  initial begin
    $dumpvars(0, test);
    $dumpfile("dump.vcd");

    a0 = 0;
    a1 = 0;
    #100ns;

    a0 = 1;
    a1 = 1;
    #100ns

    #1us;
    $finish;
  end

  initial
    $monitor("@%0t: a0 = %d, b0 = %d, c0 = %d, a1 = %d, b1 = %d, c1 = %d", $time, a0, b0, c0, a1, b1, c1);

  // IEEE 1800 - 2017 Section 9.2.2.2.2

  // always_comb
  // When is it triggered ? does lhs retrigger sensitivity ?
  // always_comb automatically executes once at time zero, whereas always @* waits until a change occurs on a signal in the inferred sensitivity list.
  // always_comb is sensitive to changes within the contents of a function, whereas always @* is only sensitive to changes to the arguments of a function.
  // (However, it doesn’t infer sensitivity from tasks. If a task takes zero time, you can use a void function instead to infer sensitivity.)
  // Variables on the left-hand side of assignments within an always_comb procedure, including variables from the contents of a called function,
  //  cannot be written to by any other processes, whereas always @* permits multiple processes to write to the same variable.
  //
  // It states that any expression that is written within the always_comb block or within any function called within the always_comb block is
  // excluded from the implicit sensitivity list

  // Those two always comb have different behaviours
  always_comb begin
    b0 = a0;
    c0 = b0;
  end

  always_comb begin
    c1 = b1;
    b1 = a1; // b is not in inferred sensitivty list and the process is not retriggered here
  end

  // always @* begin

  // end

endmodule