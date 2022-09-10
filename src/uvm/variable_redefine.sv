module tb();

  class base_object;
    rand int b;

    function new();
    endfunction

    function void print_b();
      $display("print_b from base_object, %s b: %0d", $typename(b), b);
    endfunction

  endclass

  class rand_object extends base_object;

    // Redefining b variable
    // Be careful when redefining variables. This is perfectly legal in SystemVerilog,
    // each variable will have its own context in objects of type rand_object
    // (i.e. rand_object will access b defined in rand_object, while rand_object.super.* will access b defined in base_object)
    rand bit [15:0] b;

    function new();
    endfunction

  endclass : rand_object

  rand_object h;

  initial begin
    h = new();
    $display("%p", h);
    // This will print b variable from base_class since print_b is declared in base_object
    h.print_b();
  end

endmodule : tb