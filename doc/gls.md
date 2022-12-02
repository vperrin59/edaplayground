# Gate-Level Simulation

## Utility

* Validate Backend SDC constraints, some paths may not be timed and they should
* Validate clock muxing scheme, wrong clock muxing may generate glitches

## Troubleshoot

* Check how signals are driven at the interface. May need to drive them on negedge
* Check the SDF annotation
* Modelling code inside `ifdef` in RTL will be removed in GLS
* Flops without reset may need to be initialized with random values
* Memory need to be initialized after reset sequence if needed with some hex