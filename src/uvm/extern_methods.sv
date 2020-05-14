module tb;
  class foo #(type T = int);
    T member;
    extern function T get_member();
    extern function void set_member(T);
  endclass

  function foo::T foo::get_member(); // need scope operator :: for return type
    return member;
  endfunction

  function void foo::set_member(T member); // don't need :: for T, already in scope
    this.member = member;
  endfunction

  foo#(byte) b;
  foo#(shortint) s;
  initial begin
   b = new();
   s = new();
    b.set_member('hA);
    s.set_member('1);
    $display("b:%b   s:%b", b.get_member(), s.get_member());
  end
endmodule