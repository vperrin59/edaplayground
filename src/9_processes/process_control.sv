// IEEE 1800-2017 Section 9.6

// Used for fork protection for forking with disable in a class.
`define BEGIN_FIRST_OF fork begin fork

`define END_FIRST_OF join_any disable fork; end join

module process_control ();

  task task_a();
    #10;
    $display("TASK_A");
  endtask : task_a

  task task_b();
    #5;
    $display("TASK_B");
  endtask : task_b

  // Only TASK_B will be displayed as it will be the first one to finish
  initial begin
    `BEGIN_FIRST_OF
      task_a();
      task_b();
    `END_FIRST_OF
  end


  // Disable statement can be used as a break for nested loops
  // disable can be used on a task, named block
  // Disable hierarchical identifier
  initial begin
    #20;
    begin: outer_double_loop
      for (int a = 0; a < 10; a++) begin: loop_a
        for (int b = 0; b < 10; b++) begin: loop_b
          // $display("a: %0d, b: %0d", a, b);
          // Break only stops inner loop
          // disable loop_a only disable inner loop -> break
          // disable loop_b does a continue
          if ((a + b) == 10) begin
            $display("Disable at a: %0d, b: %0d", a, b);
            disable outer_double_loop;
          end
        end
      end
    end
  end


  // Difference between disable and disable fork
  // The disable fork statement differs from disable in that disable fork considers
  // the dynamic parent-child relationship of the processes, whereas disable uses the
  // static, syntactical information of the disabled block



  //============================================================================
  //  Wait FORK to be done Section 9.6.1
  //============================================================================

endmodule