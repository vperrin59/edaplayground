module event_race2 ();

  logic clk;
  logic [1:0] data;
  logic [1:0] nb_data;
  event b_start_ev;
  event nb_start_ev;

  initial begin
    data = 0;
    nb_data <= 0;
    clk = 0;

    #5ns;

    data = 1;
    // nb_data <= 1;
    clk = 1;
    data = 2;
    // nb_data <= 2;

    #5ns;

    $finish;
  end

  always @(posedge clk) begin
    nb_data <= 2;
  end

  always @(posedge clk)
  begin
    $display($time,,"posedge clk trigger");
    // Blocking event trigger
    ->b_start_ev;
    // Non blocking event trigger
    ->>nb_start_ev;
  end

  always @(b_start_ev)
  begin
    $display($time,,"sampled d in blocking: %d", data);
    $display($time,,"sampled nb_d in blocking: %d", nb_data);
  end

  // Non-blocking trigger allow to see assigned data after NBA
  always @(nb_start_ev)
  begin
    $display($time,,"sampled d in non-blocking: %d", data);
    $display($time,,"sampled nb_d in non-blocking: %d", nb_data);
  end

  always @(b_start_ev)
  begin
    #0;
    $display($time,,"sampled d in #0 blocking: %d", data);
    $display($time,,"sampled nb_d #0 in blocking: %d", nb_data);
  end

endmodule