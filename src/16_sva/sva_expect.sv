//****************************************************************************
// Copyright(C) 2018, Kandou Bus S.A.
//
// The information contained herein is Kandou Bus S.A. confidential
// and proprietary information and is for use by Kandou Bus S.A.
// customers only.  The information may not be reproduced or modified
// in any form without the prior written of Kandou Bus S.A.
// Kandou Bus S.A. reserves the right to make changes to the
// information at any time without notice.
//
//***************************************************************************

interface chk_if ();

  property p_a(a, b);
    $rose(a) |-> ##10 b;
  endproperty

endinterface

package chk_pkg;

  property p_a(a, b);
    $rose(a) |-> ##10 b;
  endproperty

endpackage : chk_pkg

module tb();

  bit clk;
  bit a;
  bit b;


  always #1ns clk = ~clk;

  default clocking cb @(posedge clk);
    inout a;
    inout b;
  endclocking


  chk_if my_chk_if();

  initial begin
    cb.a <= ##1 1;
  end

  initial begin
    ##1;
    expect(my_chk_if.p_a(a, b))
      $display("IF EXPECT PASSED");
    else
      $display("IF EXPECT FAILED");

    $display("IF EXPECT AFTER");
  end

  initial begin
    ##1;
    expect(chk_pkg::p_a(a, b))
      $display("PKG EXPECT PASSED");
    else
      $display("PKG EXPECT FAILED");

    $display("PKG EXPECT AFTER");
  end

  initial begin
    #1us;
    $display("TIMEOUT OCCURED");
    $finish;
  end

endmodule : tb