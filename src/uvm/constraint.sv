// TODO: equivalence constrants

/*
DVCON 2014 The Top Most Common SystemVerilog Constrained Random Gotchas
How does theconstraintSolver work?
In an  attemptto  solve  a  specific  randomization  problem,  the  Solver  takes  the  following  steps  when  it encounters a randomize()callas dictated by the SystemVerilog LRM?[1]:
1.Calls the pre_randomize() virtual function recursively in a top-down manner.
2.Scans the entire randomization cluster enclosing all random variables and constraints.
3.Solves random variables with simple equality constraints (e.g. constraint c {x ==5;};).
4.Executes  simple  functions  called  in  constraints;  functions  with  no  arguments  or  whose  arguments  are constants  or  variables  that  do  not  belong  to  the  current  randomization  cluster.
Remember  that  the Solver does not look into functions?contents, and so even if functions access random variables in their body,  they  are  still  going  to  be  called  and  evaluated  substituting  random  variables  with  their  current values.
5.Updates  constraints  of  the  current  randomization  cluster by substituting  with  values  deduced  in  steps #3 and #4 (also non-random variables used in constraints are substituted with their current values).
6.Groups random variables and constraints into independent randsets. A randsetholds random variables that  share  common  constraints;  i.e.  variables  that  their  solution  depends  on  each  other  because  of common  constraints,
together  with  their  constraints.This  step  is  useful  for  performance  as  well  as random stability reasons.
7.Orders  randsets.  The  order  of  randsets  depends  on  thenature  of  random  variables  or  constraints. Generally they are ordered as follows:a.Randsets holding cyclic random variables (declared with the randcmodifier)3. Because randccycles  operate  on  single  variables,
this  implies  that  each randcvariable  must  beevaluated separately (even from other dependent randcvariables).b.Randsets holding random variables passed as arguments to functions used in constraints.c.Remaining randsets.
8.Picks the appropriateengine for each randset to solve the problem of random variables and constraints athand.
9.Attempts to solve a randsetsatisfying all enclosed constraints, takingany number of iterations it needs.
10.Following  a  randset  solution,  records  the  solution  within  the  Solver  and  then  proceeds  to  the  next randset. Take into account that there is no going-back strategy if a subsequent randset fails (i.e. Thereis no loop back to pick other solutions for previously solved randsets when following randsets fail).
11.If  the  Solver  fails  to  solve  a  specific  randset,  it  aborts  the  entire  randomization  process  and  flags  a randomization  failure (i.e. therandomize()function  shall  return  zero) without  updating  any  of  the successfully solved random variables.
12.If all randsetsare successfully solved, the Solver will:
  a.Generate random valuesfor any unconstrained random variables remaining.
  b.Updates all random variables with the newly generated solution.
  c.Callsthepost_randomize()virtual function recursively in a top-down manner.
*/

// Random variables passed as function arguments are forced to be solved first by the Solver

// Thread,  module,  program,  interface and   package   RNGs   are   used   to   select   random   values   for $urandom()(as   well   as $urandom_range(), std::randomize(),  randsequence,  randcase,  andshuffle())

// Random  stability  is  addressed carefully  in  the  Universal Verification  Methodology  (UVM)?[4]:
// a)  UVM components are re-seeded during their construction based on their type and full path names.
// b) Sequences are re-seeded automatically before their actual start


// It has to be carefully keptin mind that randomize()does not instantiate class objects

module tb();

  class base_object;
    rand int b;

    constraint b1_ctr {
      b < 256;
    }

    function new();
    endfunction

    function void print_b();
      $display("print_b from base_object, b: %0d", b);
    endfunction

  endclass

  class rand_object extends base_object;

    rand int a;

    // Redefining b variable
    // Be careful when redefining variables. This is perfectly legal in SystemVerilog,
    // each variable will have its own context in objects of type rand_object
    // (i.e. rand_object will access b defined in rand_object, while rand_object.super.* will access b defined in base_object)
    rand bit [15:0] b;

    rand bit b_a[];

    constraint b_a_ctr {
      b_a.size() == 10;
      // Reduction array method are casted to element width, bit here
      //b_a.sum() == 5; // -> this will provoke solver failure
      b_a.sum() with (int'(item)) == 10;
    }

    constraint b2_ctr {
      b > 32;
    }

    // Functions must be automatic in constraints
    // Random variables must be inputs to the function
    function automatic int count_ones ( bit [9:0] w );
      for( count_ones = 0; w != 0; w = w >> 1 )
        count_ones += w & 1'b1;
    endfunction


    rand int count;
    rand bit [9:0] ones;

    // This would fail, because the function will not use the randomized ones value but the init value
    function automatic int count_ones_2 ();
      count_ones_2 = 0;
      for( int k; k << 10; k++ )
        count_ones_2 += ones[k];
    endfunction

    // IEEE 1800-2017 Section 18.5.12
    // This constraint is not equivalent to one version with unrolled logic (no function).
    // This constraint is not bidirectional, because ones is randomized first implicitly
    // with priority calculation. there is an implicit variable ordering
    // Constraints that include only variables with higher priority are solved before other, lower priority constraints
    // Random variables solved as part of a higher priority set of constraints become state variables to the remaining set of constraints
    // Return values of functions are used as state variables for the constraint solver
    // Constraint with higher priorities are solved first WITHOUT considering lower priority constraints at all ---> can cause the overall constraints to fail
    // Different from solve ... before ...
    static constraint count_ctr {
      count == count_ones(ones);
      // count == count_ones();
    }


    extern constraint static_ctr;

    function new();
    endfunction

    function void pre_randomize();
    endfunction

    function void post_randomize();
    endfunction

  endclass : rand_object

  // This constraint can make the randomization fails because as said previously
  // ones is randomized first, irrespective of constraint count_ctr, and then the solver
  // tries to resolve count
  constraint rand_object::static_ctr {count < 5;};

  rand_object h;

  initial begin
    int a;
    a = 50;
    h = new();
    // This is not the wanted behaviour
    // Unqualified names in an unrestricted in-lined constraint block are then resolved by searching first in the scope of therandomize()
    // with object class followed by a search of the scope containing the method call the local scop
    // h.randomize() with { a == h.a;};
    h.randomize() with { a == local::a;};
    $display("%p", h);

    // This will print b variable from base_class since print_b is declared in base_object
    h.print_b();
  end

endmodule : tb