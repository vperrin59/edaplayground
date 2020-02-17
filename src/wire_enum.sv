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

module tb ();

  typedef enum logic {
    ZERO  = 1'b0,
    ONE   = 1'b1
  } bit_t;


  wire bit_t test = ZERO;

  wire bit_t test_0;
  bit [1:0]  test_1;

  assign test_0 = bit_t'(test_1);

endmodule

`resetall