package pkg_1;
  typedef bit bit_1_t;

endpackage

package pkg_2;
  typedef bit bit_2_t;
endpackage

package pkg_chaining;

  // A wildcard import statement does not import everything in package pkg_chaining; it only makes symbols candidates for importing.
  import pkg_1::*;
  import pkg_2::*;

  // bit_2_t is referenced here so it will be exported
  import pkg_2::bit_2_t;

  // bit_1_t is referenced here so it will be exported
  function bit_1_t bidon(bit_1_t src);
    return src;
  endfunction


  // LRM 26.6 Exporting imported names from packages wrote:
  // Symbols that are candidates for import but not actually imported are not made available.
  export pkg_1::*;
  export pkg_2::*;

  // export *::*;

endpackage


module test;

  import pkg_chaining::*;

  bit_1_t bit_1;
  bit_2_t bit_2;

endmodule : test