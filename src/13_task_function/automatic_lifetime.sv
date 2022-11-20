// IEEE 1800-2017 Section 13.3.1 and 13.4.2

// Normal package
// Declaring package automatic will define all functions. tasks inside as automatic
package /*automatic*/ complex_pkg;

  typedef struct {
    int x;
    int y;
  } c_t;


  typedef enum {RE, IM} c_type_t;

  // Static task, all internal variables are static
  // for all threads
  // input args are copied locally when the function is called
  // The last function call assigns the input variable
  // ref args are forbidden for static tasks
  task c_incr(input c_type_t c_type);
    c_t c;

    repeat(5) begin
      $display("TYPE: %s c: %p", c_type.name, c);
      if (c_type == RE) c.x += 1;
      else              c.y += 1;
      #10ns;
    end

  endtask

  // ref args require a variable to be assigned not a constant
  task automatic auto_c_incr(ref c_type_t c_type);
    c_t c;

    repeat(5) begin
      $display("TYPE: %s c: %p", c_type.name, c);
      if (c_type == RE) c.x += 1;
      else              c.y += 1;
      #10ns;
    end

  endtask

endpackage

module test;
  import complex_pkg::*;

  c_type_t re_type;
  c_type_t im_type;

  assign re_type = RE;
  assign im_type = IM;


  initial begin
    fork
      complex_pkg::c_incr(re_type);
      complex_pkg::c_incr(im_type);
    join
  end

  // static keyword is optional, initialization happens before time 0
  int svar1 = 1;

  initial begin
    #100ns;
    for (int i=0; i<3; i++) begin
      // automatic variable assignment executes each time the outer loop is called
      automatic int loop3 = 0;
      for (int j=0; j<3; j++) begin
        loop3 ++;
        $display("%3d",loop3);
      end
    end
    $display("\n");
    for (int i=0; i<3; i++) begin
      // The static variable assignment executes once before time 0
      /* static */ int loop2 = 0;
      for (int j=0; j<3; j++) begin
        loop2 ++;
        $display("%3d",loop2);
      end
    end
    $display("\n");
    $finish;
  end


endmodule : test