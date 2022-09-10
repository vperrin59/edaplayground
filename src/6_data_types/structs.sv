module tb();

  typedef struct packed {
    logic [17-1:0] instr;
    logic [10-1:0] addr;
  } instr_packet_t;

  instr_packet_t instr_packet;
  instr_packet_t instr_packet_after_flatten;

  // Struct flattening

  // flattened structure
  wire [$bits(instr_packet_t)-1:0] instr_packet_flat = instr_packet;

  // Convert back
  assign instr_packet_after_flatten = instr_packet_flat;

endmodule : tb