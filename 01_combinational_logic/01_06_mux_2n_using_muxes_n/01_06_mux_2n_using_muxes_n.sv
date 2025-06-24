//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux_2_1
(
  input  [3:0] d0, d1,
  input        sel,
  output [3:0] y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module mux_4_1
(
  input  [3:0] d0, d1, d2, d3,
  input  [1:0] sel,
  output [3:0] y
);

  // Task:
  // Implement mux_4_1 using three instances of mux_2_1

  wire [3:0]y0, y1;
  
  
   mux_2_1 right_two(
  .d0(d0), //00
  .d1(d1), //01
  .sel(sel[0]),
  .y(y0)
  );
  
  mux_2_1 left_two(
  .d0(d2), //10
  .d1(d3), //11
  .sel(sel[0]),
  .y(y1)
  );
 
  
  mux_2_1 final_choice(
  .d0(y0), 
  .d1(y1), 
  .sel(sel[1]),
  .y(y)
  );
  

  
endmodule
