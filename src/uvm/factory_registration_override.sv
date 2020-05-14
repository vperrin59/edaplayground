module tb();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class base_class extends uvm_object;

    `uvm_object_utils(base_class)

    function new(string name="");
      super.new(name);
    endfunction

    virtual function print_type_name();
      $display("TYPE_NAME: %s", type_name);
    endfunction

  endclass


  class class_b#(parameter type T = uvm_sequence) extends base_class;

    // Not used for registry by name but for printing
    const static string type_name = $sformatf("class_b #(%s)",T::type_name);

    // This macro does not register by typename in factory because of object_registry
    // Uvm base macro assumes no factory registry for param objects

    // Registering by type
   `uvm_object_param_utils(class_b#(T))


    function new(string name="");
      super.new(name);
    endfunction

  endclass

  class class_c#(parameter type T = uvm_sequence, string TYPENAME = "unknown") extends base_class;

    // VP: type_name needs to be elaboration constant for factory registration
    // VP: because it needs to be given to uvm_object_registry parameter

    const static string type_name = TYPENAME;

    typedef uvm_object_registry#(class_c#(T, TYPENAME), TYPENAME) type_id;

    // Registered through   local static this_type me = get(); in uvm_object_registry class

    static function type_id get_type();
      return type_id::get();
    endfunction

    function new(string name="");
      super.new(name);
    endfunction

    virtual function print_type_name();
      $display("TYPE_NAME2: %s", type_name);
    endfunction

  endclass

  typedef class_c#(uvm_sequence_base, "class_c#(uvm_sequence_base)") class_c_sequence_base_t;
  typedef class_c#(uvm_reg_single_bit_bash_seq, "class_c#(uvm_reg_single_bit_bash_seq)") class_c_bit_bash_t;
  typedef class_c#(uvm_mem_mam, "class_c#(uvm_mem_mam)") class_c_mem_mam_t;
  typedef class_c#(uvm_mem_region, "class_c#(uvm_mem_region)") class_c_mem_region_t;
  typedef class_c#(uvm_sequence_base, "type_id_ovr_inst") class_c_type_id_ovr_inst_t;
  typedef class_c#(uvm_sequence_base, "type_id_ovr_type") class_c_type_id_ovr_type_t;

  base_class type_ovr_by_type_name;
  base_class type_ovr_by_type;
  base_class inst_ovr_by_type_name;
  base_class inst_ovr_by_type;

  base_class type_id_ovr_inst;
  base_class type_id_ovr_type;

  uvm_factory fac = uvm_factory::get;

  initial begin
    // Factory override before
    // set_type_override(base_class::type_name, class_c_sequence_base_t::type_name );
    fac.print();
    // VP: Here for the override we need class_c_sequence_base_t to be registered in the factory
    // VP: This one works without factory regitration ???
    // base_class::type_id::set_type_override(class_c_sequence_base_t::get_type(), 1);

    //============================================================================
    //  Override directly through the factory
    //============================================================================

    fac.set_type_override_by_name(base_class::type_name, class_c_bit_bash_t::type_name);

    type_ovr_by_type_name = base_class::type_id::create("type_ovr_by_type_name");
    type_ovr_by_type_name.print_type_name();

    fac.set_type_override_by_type(/*uvm_object_wrapper*/ base_class::get_type(), /*uvm_object_wrapper*/ class_c_sequence_base_t::get_type());

    type_ovr_by_type = base_class::type_id::create("type_ovr_by_type");
    type_ovr_by_type.print_type_name();

    fac.set_inst_override_by_name (base_class::type_name, class_c_mem_region_t::type_name, "inst_ovr_by_type_name");

    inst_ovr_by_type_name = base_class::type_id::create("inst_ovr_by_type_name");
    inst_ovr_by_type_name.print_type_name();

    fac.set_inst_override_by_type (/*uvm_object_wrapper*/ base_class::get_type(), /*uvm_object_wrapper*/ class_c_mem_mam_t::get_type(), "inst_ovr_by_type");

    inst_ovr_by_type = base_class::type_id::create("inst_ovr_by_type");
    inst_ovr_by_type.print_type_name();

    //============================================================================
    //  Override through type_id, uvm_object_registry
    //  It goes through factory
    //============================================================================

    base_class::type_id::set_type_override (/*uvm_object_wrapper*/ class_c_type_id_ovr_type_t::get_type());
    type_id_ovr_type = base_class::type_id::create("type_id_ovr_type");
    type_id_ovr_type.print_type_name();

    base_class::type_id::set_inst_override (/*uvm_object_wrapper*/ class_c_type_id_ovr_inst_t::get_type(), "type_id_ovr_inst", /*parent*/null);

    type_id_ovr_inst = base_class::type_id::create("type_id_ovr_inst");
    type_id_ovr_inst.print_type_name();

    //============================================================================
    //  Can also override through functions in uvm_component but it also goes through factory
    //============================================================================

  end

endmodule : tb