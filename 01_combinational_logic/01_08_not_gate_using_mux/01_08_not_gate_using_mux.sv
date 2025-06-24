//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module not_gate_using_mux
(
    input  i,
    output o
);

  // Task:
  // Implement not gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  wire const0 = 1'b0;
  wire const1 = 1'b1;
  mux mux_not(
  .d0(const1), 
  .d1(const0),
  .sel(i),
  .y(o)
  );

endmodule
