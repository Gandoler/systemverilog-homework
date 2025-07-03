//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order using FSM.
    //
    // Requirements:
    // The solution must have latency equal to the three clock cycles.
    // The solution should use the inputs and outputs to the single "f_less_or_equal" module.
    // The solution should NOT create instances of any modules.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res1
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.
     enum logic[2:0]
      {
        Send_a_b             = 3'd0,
        Send_b_c_get_f_res   = 3'd1,
        Send_c_d_get_s_res   = 3'd2,
        Get_t_res            = 3'd3
      } state, new_state;
      logic [2:0]e1e2e3_comare, errors;
      
    
    always_comb begin 
      new_state = state;
      
      case(state)
        Send_a_b           : if(valid_in) new_state = Send_b_c_get_f_res;
        Send_b_c_get_f_res : if(valid_in) new_state = Send_c_d_get_s_res;
        Send_c_d_get_s_res : if(valid_in) new_state = Get_t_res;
        Get_t_res          :              new_state = Send_a_b;
        endcase
    end
    
     always_comb begin
      f_le_a ='x;
      f_le_b ='x;
      case(state)
        Send_a_b: begin
          f_le_a           = unsorted[0];
          f_le_b           = unsorted[1];
        end
        
        Send_b_c_get_f_res : begin
          e1e2e3_comare[2] = f_le_res;
          errors[2]        = f_le_err;
          f_le_a           = unsorted[1];
          f_le_b           = unsorted[2];
        end
        
        Send_c_d_get_s_res : begin
          e1e2e3_comare[1] = f_le_res;
          errors[1]        = f_le_err;
          f_le_a           = unsorted[2];
          f_le_b           = unsorted[3];
        end
        
        Get_t_res          : begin
          e1e2e3_comare[0] = f_le_res;
          errors[0]        = f_le_err;
        end
        endcase
    end  

    assign err = | errors ;
    
    always_comb begin
      if(state == Get_t_res & ~err) begin 
        if (e1e2e3_comare[1])
         if (e1e2e3_comare[0])
           sorted = unsorted;
         else
           if (e1e2e3_comare[2])
             {   sorted [0],   sorted [1], sorted [2] } = { unsorted [1], unsorted [0], unsorted[2] };
           else 
             {   sorted [0],   sorted [1], sorted [2] } = { unsorted [1], unsorted [2], unsorted[0] };
       else
         if (e1e2e3_comare[0])
           if (e1e2e3_comare[2])
             {   sorted [0],   sorted [1], sorted [2] } = { unsorted [0], unsorted [2], unsorted[1] };
           else 
             {   sorted [0],   sorted [1], sorted [2] } = { unsorted [2], unsorted [0], unsorted[1] };
         else
           {   sorted [0],   sorted [1], sorted [2] } = { unsorted [2], unsorted [1], unsorted[0] };
        valid_out = 'b1 ;
      end
    
    end



    always_ff @(posedge clk) begin
      if(rst)
        state = Send_a_b;
      else
        state = new_state;
    end




endmodule
