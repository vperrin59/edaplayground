module test;

`ifndef __COMPILE_GUARD__
  `define __COMPILE_GUARD__

  // Default args
  `define PRINT(a, b="b") \
    $display(a, b);

  // Multiple arg macros
  `define FORMAT_INFO(MSG) \
  $display($sformatf MSG);

  `define STRINGIFY(x) \
    `"x`"

  `define msg(x,y) `"x: `\`"y`\`"`"

`endif

  // `include "included.sv"

  initial begin
    `PRINT("a")
    `PRINT("a", "c")
    `PRINT(, "c")
    `PRINT(`__FILE__, `__LINE__)

    `FORMAT_INFO(("Formatted message :%s", "raw_string"))

    $display(`msg(x,y));

    `line 3 "included.sv" 0

    $display(`__FILE__);
    $display(`__LINE__);


  end

  `define append(f) f``_master

  logic `append(clock);

endmodule : test