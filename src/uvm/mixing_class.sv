module tb();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class base_class extends uvm_object;

    rand bit rand_bit;

    `uvm_object_utils(base_class)

    function new(string name="");
      super.new(name);
    endfunction

  endclass : base_class

  class mixing_seq#(parameter type T = uvm_sequence) extends T;

    const static string type_name = $sformatf("mixing_seq#(%s)",T::type_name);
    // Registering by type
    `uvm_object_param_utils(mixing_seq#(T))

    constraint ctr {
      this.rand_bit == 0;
    }

    function new(string name="");
      super.new(name);
    endfunction

  endclass

  typedef mixing_seq#(base_class) base_class_0_t;

  base_class_0_t base_class_0;

  initial begin
    base_class_0 = new();
    base_class_0.randomize();
    $display("base_class_0.randbit: %0d", base_class_0.rand_bit);
  end

endmodule : tb