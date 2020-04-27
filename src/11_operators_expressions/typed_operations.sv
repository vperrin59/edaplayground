module tb();

  int IntA;

  initial begin
    // The result is -4
    IntA = -12 / 3;
    #1;
  // The result is 1431655761
    IntA = -'d 12 / 3;
    #1;
  // The result is -4
    IntA = -'sd 12 / 3;
    #1;
  // -4'sd12 is the negative of the 4-bit
  // quantity 1100, which is -4. -(-4) = 4
  // The result is 1
    IntA = -4'sd 12 / 3;
  end

  always_comb begin
    $display("IntA %0d", IntA);
  end

  int a, b;

  initial begin
    // Equivalent to blocking assignment
    // Left hand expression evaluated once
    // Assignment expression returns final value of a
    $display("a=b %0d", (a=b));
    $display("a+=1 %0d", (a+=1));
    $display("a+=1 %0d", (a+=1));
    b = 4;
    $display("a=b %0d", (a=b));

    if ((a=b))
      b = (a+=1);

    a = 10;
    // Undefined order of evaluations
    b = a++ + (a = a - 1);

    #1;

    a = 10;
    b = 20;

    $display("a %0d b %0d", a, b);
    a = ++b; // a = 21, because b is incr before assigned
    $display("++b a %0d b %0d", a, b);
    a = 10;
    b = 20;
    a = b++; // a = 20, because b is incr after assigned
    $display("b++ a %0d b %0d", a, b);
  end


endmodule : tb