module test;

  real r;
  int i_int;
  int i_rtoi;
  int i_ceil;
  int i_floor;

  assign i_int = int'(r);
  assign i_rtoi = $rtoi(r);
  assign i_ceil = $ceil(r);
  assign i_floor = $floor(r);

  initial begin
    $monitor("@%0t: r = %f, i_int = %d, i_rtoi = %d, i_ceil = %d, i_floor = %d", $time, r, i_int, i_rtoi, i_ceil, i_floor);
    #5ns;
    r = 1.1;
    #5ns;
    r = 1.5;
    #5ns;
    r = 1.6;
    #5ns;
    r = -1.1;
    #5ns;
    r = -1.5;
    #5ns;
    r = -1.6;
  end

endmodule