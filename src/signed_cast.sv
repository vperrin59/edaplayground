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

`timescale 1ps/1fs
`default_nettype none

module test;

  logic signed [1:0] upd;

  logic              init;
  logic signed [4:0] acc_ff, acc_nxt;

  logic [3:0] cnt_ff;

  // There should be no issue with sign conversion here
  assign acc_nxt =  init            ? 5'('sd0)  :
                    cnt_ff == 3'd0  ? 5'(upd)   : acc_ff + 5'(upd);

  initial begin
    $dumpvars(0, test);
    $dumpfile("dump.vcd");

    init = 0;
    upd  = 0;
    acc_ff = 0;
    cnt_ff  = 0;

    #1us;
    $finish;
  end

  // initial
  //   $monitor("@%0t: a0 = %d, b0 = %d, c0 = %d, a1 = %d, b1 = %d, c1 = %d", $time, a0, b0, c0, a1, b1, c1);

endmodule

`resetall