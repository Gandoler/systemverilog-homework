//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);

    // Task:
    //
    // Implement a module formula_1_pipe_aware_fsm
    // with a Finite State Machine (FSM)
    // that drives the inputs and consumes the outputs
    // of a single pipelined module isqrt.
    //
    // The formula_1_pipe_aware_fsm module is supposed to be instantiated
    // inside the module formula_1_pipe_aware_fsm_top,
    // together with a single instance of isqrt.
    //
    // The resulting structure has to compute the formula
    // defined in the file formula_1_fn.svh.
    //
    // The formula_1_pipe_aware_fsm module
    // should NOT create any instances of isqrt module,
    // it should only use the input and output ports connecting
    // to the instance of isqrt at higher level of the instance hierarchy.
    //
    // All the datapath computations except the square root calculation,
    // should be implemented inside formula_1_pipe_aware_fsm module.
    // So this module is not a state machine only, it is a combination
    // of an FSM with a datapath for additions and the intermediate data
    // registers.
    //
    // Note that the module formula_1_pipe_aware_fsm is NOT pipelined itself.
    // It should be able to accept new arguments a, b and c
    // arriving at every N+3 clock cycles.
    //
    // In order to achieve this latency the FSM is supposed to use the fact
    // that isqrt is a pipelined module.
    //
    // For more details, see the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0
    enum logic[2:0]{
      IDLE   = 3'd0,
      SEND_a = 3'd1,
      SEND_b = 3'd2,
      SEND_c = 3'd3,
      GET_a  = 3'd4,
      GET_b  = 3'd5,
      GET_c  = 3'd6    
    }
    state, new_state;
    always_ff @ (posedge clk)
      if (rst)
          state <= IDLE;
      else
          state <= new_state;
    
    
    always_comb begin
      new_state = state;
      
      case(state)
        IDLE    : if(arg_vld) new_state = SEND_a;
        SEND_a  :             new_state = SEND_b;
        SEND_b  :             new_state = SEND_c;
        SEND_c  : if(isqrt_y) new_state = GET_a;
        GET_a   :             new_state = GET_b;
        GET_b   :             new_state = GET_c;
        GET_c   :             new_state = IDLE;
      endcase
    end 
    
    
    always_comb begin
      isqrt_x_vld = 1'b0;
      case(state) 
       IDLE     : if(arg_vld) isqrt_x_vld = 1'b1;   
       SEND_a   :             isqrt_x_vld = 1'b1;
       SEND_b   :             isqrt_x_vld = 1'b1;
//       SEND_c   :             isqrt_x_vld = 1'b1;
      endcase
    end
    
    
    always_comb
    begin
        isqrt_x = 1'b0;  // Don't care

        case (state)
        IDLE   :   isqrt_x = a;
        SEND_a   :   isqrt_x = b;
        SEND_b   :   isqrt_x = c;
        endcase
    end
    
   


    always_ff @ (posedge clk)
        if (rst)
            res_vld <= '0;
        else
            res_vld <= (state == GET_c );

   


    always_ff @ (posedge clk)
        if (state == IDLE)
            res <= '0;
        else if (isqrt_y_vld)
                res <= res + isqrt_y;
      


endmodule
