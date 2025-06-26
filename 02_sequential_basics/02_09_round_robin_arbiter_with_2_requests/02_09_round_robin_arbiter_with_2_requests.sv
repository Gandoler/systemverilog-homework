//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01
    enum logic[1:0]
  {
    non_request   =00,
    f_request     =01,
    s_request     =10,
    t_request     =11
  }
 next_in_line, current_request;
  
  
  
    
    always_comb begin 
      next_in_line = current_request;
    
      case (current_request)
        non_request: begin
          if(requests == 01) next_in_line = f_request;
          if(requests == 10) next_in_line = s_request;
          if(requests == 11) next_in_line = t_request;
          end
        f_request:  begin
          if(requests == 11) next_in_line = s_request;
          if(requests == 00) next_in_line = non_request;
          end
        s_request:  begin
          if(requests == 11) next_in_line = f_request;
          if(requests == 00) next_in_line = non_request;
          end
        t_request:  begin
          if(requests == 00) next_in_line = non_request;
          if(requests == 01) next_in_line = f_request;
          if(requests == 10) next_in_line = s_request;
          end
         
      endcase 
    end



    always_ff @(posedge clk) begin
      if (rst) 
        current_request <= non_request;
      else 
        current_request <= next_in_line;
    end
    
    
    

endmodule
