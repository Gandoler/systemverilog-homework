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

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  wire const1 = 1'b1;
  wire const0 = 1'b0;
  
  wire na, nb, a_and_nb, b_and_na;

 mux mux_not(
    .d0(const1), 
    .d1(const0),
    .sel(a),
    .y(na)
   );
   
  
  mux mux_o(
    .d0(a), 
    .d1(na),
    .sel(b),
    .y(o)
  );



  
  // not
//   mux mux_not_a(
//   .d0(const1), 
//   .d1(const0),
//   .sel(a),
//   .y(na)
//   ); 
//   mux mux_not_b(
//   .d0(const1), 
//   .d1(const0),
//   .sel(b),
//   .y(nb)
//   ); 
  
//   //and
//    mux mux_a_and_nb(
//   .d0(const0), 
//   .d1(nb),
//   .sel(a),
//   .y(a_and_nb)
//   );
//    mux mux_b_and_na(
//   .d0(const0), 
//   .d1(b),
//   .sel(na),
//   .y(b_and_na)
//   );
  
// //or
//   mux mux_first_or_second(
//   .d0(b_and_na), 
//   .d1(const1),
//   .sel(a_and_nb),
//   .y(o)
//   );
  
endmodule
