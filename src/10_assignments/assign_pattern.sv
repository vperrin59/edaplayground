module test;

  logic a, b, c, d;


  // Net declaration assignment
  wire mynet = 1'b1;

  // This will just set initial value because of implied type var
  logic mylogic = 1'b1;

  var int A[2] = '{default:1};
  wire integer B = '{31:1, 23:1, 15:1, 8:1, default:0};

  typedef struct {real r, th;} C_t;

  var C_t C = '{th: 3.14/2.0, r: 1.0};

  // Default values for struct
  var C_t C_default = '{default: 0.0};

  var real y [0:1] = '{0.0, 1.1}, z [0:9] = '{default: 3.1416};

  // REG0, REG1, REG2, REG3
  enum { REG[0:3]} regname_e;

  //============================================================================
  //  Queue assignment
  //============================================================================

  typedef enum {
    ENUM_0,
    ENUM_1
  } enum_t;

  enum_t enum_q[$] = {ENUM_0, ENUM_1};
  bit enum_inside_q;

  // W: for some simulators, queues need to be used in procedural context
  // Dynamic type in non-procedural context
  assign enum_inside_q = ENUM_0 inside {enum_q};

  // Signed struct pack
  typedef struct packed signed {
    logic itg;
    logic frac;
  } acc_t;

  initial
    $monitor("@%0t: A[0] = %d, A[1] = %d, B = %b, y[0] = %f, y[1] = %f", $time, A[0], A[1], B, y[0], y[1]);

  initial begin
    $dumpvars(0, test);
    $dumpfile("dump.vcd");
    $monitor("@%0t: a = %d, b = %d, c = %d, d = %d", $time, a, b, c, d);

    assign d = a & b & c;

    a = 1;
    b = 0;
    c = 1;

    #100ns;

    b = 1;

    #100ns

    deassign d;

    b = 0;

    #1us;
    $finish;
  end

endmodule