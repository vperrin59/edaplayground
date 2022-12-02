# Reset synchronization types

Things to bare in mind when picking which reset to use between sync and async reset.
Soft reset is related to mm triggered reset

* There can be some potential issues having soft reset connected to async pins. If for example soft reset is affecting one part of the logic in one clock domain
  There is one clock domain with logic A talking to logic B
  If logic A is being soft async reset, it will create issues to logic B
  Potential issues when in the same clk domain, logic is under reset and some not
  Otherwise when the full logic in one clock domain is under reset, you can use async reset. 
  CDC logic will already be in place for transitions to other domains
