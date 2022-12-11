`timescale 1ps/1fs
`default_nettype none

module test;

// Context determined operations
// Size is determined by the largest between LHS and RHS operands
// Signedness is determined by the signedness of RHS operands
// Both operands must be signed to perform signed arithmetic

// How to detect overflow / underflow
begin: signed_plus_signed
  // signed + signed
  // signed operation, pre padding is done with sign bit

  // Range -4 : +3
  logic signed [2:0] acc_ff, acc_nxt, acc_upd;
  logic acc_carry;

  assign {acc_carry, acc_nxt} = acc_ff + acc_upd;

  always_comb begin
    $display("acc_carry = %b, acc_nxt_msb = %d, acc_nxt = %2d, acc_ff = %2d, acc_upd = %2d", acc_carry, acc_nxt[$left(acc_nxt)], acc_nxt, acc_ff, acc_upd);
  end

  initial begin
    #10ns;

    $display("SIGNED + SIGNED");
    acc_ff  = 0;
    acc_upd = 0;

    #10ns;

    $display("OVERFLOW");
    acc_ff  = +3;
    acc_upd = +3;

    #10ns;

    $display("UNDERFLOW");
    acc_ff  = -3;
    acc_upd = -3;

  end

end: signed_plus_signed

begin: unsigned_plus_signed
  // unsigned + signed
  // unsigned operation, pre padding is done with zero

  // Range -4 : +3
  logic signed [2:0] acc_upd;
  // Range 0 : +7
  logic [2:0] acc_ff, acc_nxt;
  logic acc_carry;


  // Here we prepad manually sign bit
  assign {acc_carry, acc_nxt} = acc_ff + acc_upd;
  // assign {acc_carry, acc_nxt} = 4'(acc_ff) + 4'(acc_upd);
  // Here we forced signed operation to force sign prepadding
  // assign {acc_carry, acc_nxt} = signed'(acc_ff + acc_upd);
  // Here we forced all operands to be signed so the operation is signed
  // assign {acc_carry, acc_nxt} = signed'(acc_ff) + acc_upd;

  always_comb begin
    $display("acc_carry = %b, acc_nxt_msb = %d, acc_nxt = %2d, acc_ff = %2d, acc_upd = %2d", acc_carry, acc_nxt[$left(acc_nxt)], acc_nxt, acc_ff, acc_upd);
  end

  initial begin
    #100ns;

    $display("UNSIGNED + SIGNED");
    acc_ff  = 0;
    acc_upd = 0;

    #10ns;

    $display("OVERFLOW");
    acc_ff  = +7;
    acc_upd = +3;

    #10ns;

    $display("UNDERFLOW");
    acc_ff  =  0;
    acc_upd = -3;

  end

end

// unsigned + unsigned
begin: unsigned_plus_unsigned

  // Range 0 : +7
  logic [2:0] acc_ff, acc_nxt, acc_upd;
  logic acc_carry;

  assign {acc_carry, acc_nxt} = acc_ff + acc_upd;

  always_comb begin
    $display("acc_carry = %b, acc_nxt_msb = %d, acc_nxt = %2d, acc_ff = %2d, acc_upd = %2d", acc_carry, acc_nxt[$left(acc_nxt)], acc_nxt, acc_ff, acc_upd);
  end

  initial begin
    #200ns;

    $display("UNSIGNED + UNSIGNED");
    acc_ff  = 0;
    acc_upd = 0;

    #10ns;

    $display("OVERFLOW");
    acc_ff  = +7;
    acc_upd = +3;

  end
end: unsigned_plus_unsigned


begin: inversion
  logic [2:0] acc_ff;
  logic signed [3:0] acc_n_ff;

  // assign acc_n_ff = -acc_ff;
  // For HAL width mismatch
  assign acc_n_ff = -{1'b0, acc_ff};

  always_comb begin
    $display("acc_n_ff = %2d, acc_ff = %2d", acc_n_ff, acc_ff);
  end

  initial begin
    #300ns;

    $display("INVERSION");
    $display("%s",$typename(-acc_ff));
    $display("%s",$typename(4'sd1 + 3'sd1));
    acc_ff  = 0;

    #10ns;

    acc_ff  = +1;

    #10ns;

    acc_ff  = +7;
  end

end: inversion

`include "svlib_macros.svh"

import svlib_pkg::*;

begin: string_manipulation
  string s = $sformatf("%m");
  initial begin
    $display(s);
  end
end: string_manipulation


endmodule : test

`resetall