`default_nettype none

//============================================================================
//  Testbench for showing how to use wire / var in the module port list
//============================================================================

typedef struct packed {
  int a;
} user_int_t;

module dut(
  input var bit       a, // net must be 4-state datatype
  input wire logic    b,
  input var  reg        c, // Not compiling
  input var  int        d, // net must be 4-state datatype
  input var  user_int_t s,
  input wire integer    e,
  input var int         h, // Need var for 2-state data type
  input var int         i[1],
  input var real      f, // net must be 4-state datatype
  input int         g[2]
);

/*
  See LRM [6.5]
  Net 'd' is declared with a data type that is not allowed for nets.
  Net data types can only be composed of 4-state integral types, enum with
  4-state base type, structure, union, and fixed-size arrays.
*/

//============================================================================
//  Variable declarations IEEE 1800-2017 Section 6.8
//============================================================================

// If no data type specified, implicitly use logic

var byte my_byte; // equivalent to "byte my_byte;"
var v;            // equivalent to "var logic v;"
var [15:0] vw;    // equivalent to "var logic [15:0] vw;"
var enum bit { clear, error } status;
var reg r;


endmodule : dut

module tb();

bit         a;
logic       b;
reg         c;
int         d;
integer     e;
real        f;
int         g[2];
int         h;
int         i[1];
user_int_t  s;

dut u_dut(.*);

endmodule