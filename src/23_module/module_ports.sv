typedef struct packed {
  logic a;
  logic b;
} pack_str_t;

// typedef [2:0] pack_str_t pack_pack_str_t;

module a
(
  input wire [2:0] pack,
  input wire       unpack [2:0],
  input wire [2:0] [2:0] pack_md,
  input wire        unpack_md [2:0] [2:0],
  input wire pack_str_t pack_str,
  // This is illegal
  // input wire [2:0] pack_str_t pack_pack_str
  input wire pack_str_t pack_pack_str [2:0]
);

endmodule

module tb();


  // Many tools don't support nested module
  // module a
  // (
  //   input wire [2:0] pack,
  //   input wire       unpack [2:0],
  //   input wire [2:0] [2:0] pack_md,
  //   input wire        unpack_md [2:0] [2:0],
  //   input wire pack_str_t pack_str,
  //   input wire [2:0] pack_str_t pack_pack_str
  // );

  // endmodule

endmodule : tb