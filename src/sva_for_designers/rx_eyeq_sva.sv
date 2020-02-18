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

module tb();

  bit clk;
  bit rxeyeqreq;
  bit rxeyeqdone;

  integer rxeyeq;

  localparam EYEQMODE_W = 4;
  typedef enum logic [EYEQMODE_W-1:0] {
    STARTUP_ENRZ_PH1   = 4'b0001,
    STARTUP_ENRZ_PH2   = 4'b0010,
    STARTUP_NRZ_BR     = 4'b0011,
    STARTUP_NRZ_DDR    = 4'b0100,
    STARTUP_NRZ_DDR_CR = 4'b0101,
    STARTUP_NRZ_DDR_EQ = 4'b0110, // Same as STARTUP_NRZ_DDR
    BACKGROUND_ENRZ    = 4'b1010,
    BACKGROUND_NRZ_BR  = 4'b1011,
    BACKGROUND_NRZ_DDR = 4'b1100,
    WAKE_START_CDR     = 4'b1101,
    UNKNOWN_MODE       = 4'hx
  } eyeqmode_t;

  eyeqmode_t rxeyeqmode;
  string     rxeyeqmode_s;

  localparam POWERDOWN_W = 2;

  typedef enum logic [POWERDOWN_W-1:0] {
    POWERDOWN_NORMAL  = 2'b00,
    POWERDOWN_IDLE    = 2'b01,
    POWERDOWN_SLEEP   = 2'b11,
    POWERDOWN_COMA    = 2'b10
  } powerdown_t;

  powerdown_t rxpdwn;

  always
    clk = #5ns ~clk;


  initial begin
    $dumpvars(0, tb);
    $dumpfile("dump.vcd");
    rxeyeqreq     = 0;
    rxeyeqdone    = 0;
    rxeyeqmode    = UNKNOWN_MODE;
    rxeyeqmode_s  = rxeyeqmode.name();
    rxpdwn        = POWERDOWN_NORMAL;

    repeat(5)
      @(posedge clk);

    rxeyeqreq   = 1;
    rxeyeqmode  = STARTUP_NRZ_DDR;
    rxeyeqmode_s  = rxeyeqmode.name();

    //============================================================================
    //  Testing a_eyeq_req
    //============================================================================
    // rxpdwn  = POWERDOWN_COMA;

    repeat(10)
      @(posedge clk);

    //============================================================================
    //  Testing a_eyeq_req_stable
    //============================================================================
    // rxeyeqmode = BACKGROUND_NRZ_DDR;

    rxeyeqdone  = 1;
    rxeyeq      = 10;

    repeat(2)
      @(posedge clk);

    //============================================================================
    //  Testing a_eyeq
    //============================================================================
    // rxeyeq      = 5;
    // repeat(2)
    //   @(posedge clk);

    rxeyeqreq   = 0;

    repeat(1)
      @(posedge clk);

    rxeyeqdone  = 0;

    repeat(2)
      @(posedge clk);

    #10ns;
    $finish;
  end


  //============================================================================
  //  Checkers
  //============================================================================

  // Checks rxeyeqreq can only be asserted during POWERDOWN_NORMAL
  a_eyeq_req          : assert property(@(posedge clk) $rose(rxeyeqreq) |-> rxpdwn == POWERDOWN_NORMAL);
  // Checks when rxeyeqreq is asserted, rxeyeqmode is stable until rxeyeqdone is deasserted
  a_eyeq_req_stable   : assert property(@(posedge clk) $rose(rxeyeqreq) |=> $stable(rxeyeqmode) s_until_with $fell(rxeyeqdone));


  // 4way handshake checks
  a_4way_hs_0   : assert property(@(posedge clk) $rose(rxeyeqreq) |-> !rxeyeqdone);
  a_4way_hs_1   : assert property(@(posedge clk) $rose(rxeyeqdone) |-> rxeyeqreq);
  a_4way_hs_2   : assert property(@(posedge clk) $fell(rxeyeqreq) |-> rxeyeqdone);

  // Checks that when rxeyeqdone is asserted rxeyeq is stable until rxeyeq is deasserted
  a_eyeq        : assert property(@(posedge clk) $rose(rxeyeqdone) ##1 1 |-> $stable(rxeyeq) until $fell(rxeyeqreq));

endmodule


`resetall