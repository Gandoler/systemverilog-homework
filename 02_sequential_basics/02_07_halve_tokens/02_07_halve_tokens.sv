//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output b
);
    // Task:
    // Implement a serial module that reduces amount of incoming '1' tokens by half.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 110_011_101_000_1111
    // b -> 010_001_001_000_0101
 enum logic[1:0]
  {
     zero       = 2'b00,
     nonzero_click1    = 2'b10,
     nonzero_click2    = 2'b11
  }
  state, new_state;
  
  
  always_comb
  begin
   new_state = state;
   
     case (state)
       zero: 
          if(a) new_state = nonzero_click1;
          
        nonzero_click1: begin
          if(a) new_state = nonzero_click2;
//          if(~a) new_state = nonzero_click1;
        end
        
        nonzero_click2: begin
          if(~a) new_state = zero;
          if(a) new_state = nonzero_click1;
        end
    endcase  
  end
  
  
  assign b = a & (state == nonzero_click1);
  
  
   always_ff @ (posedge clk)
    if (rst)
      state <= zero;
    else
      state <= new_state;

    

  

endmodule
