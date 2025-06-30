//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_fsm
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
    // Implement a module that calculates the formula from the `formula_2_fn.svh` file
    // using only one instance of the isqrt module.
    //
    // Design the FSM to calculate answer step-by-step and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm
    enum logic [2:0]
    {
        IDLE         = 3'd0,
        WAIT_sqrt_c        = 3'd1,
        WAIT_sqrt_b_plus_prev       = 3'd2,
        WAIT_sqrt_a_plus_prev       = 3'd3
    }
    state, next_state;

    always_comb
    begin
        next_state = state;

        case (state)
        IDLE                  : if ( arg_vld     )   next_state = WAIT_sqrt_c;
        WAIT_sqrt_c           : if ( isqrt_y_vld ) next_state = WAIT_sqrt_b_plus_prev;
        WAIT_sqrt_b_plus_prev : if ( isqrt_y_vld ) next_state = WAIT_sqrt_a_plus_prev;
        WAIT_sqrt_a_plus_prev : if ( isqrt_y_vld ) next_state = IDLE;
        endcase
    end

    always_ff @ (posedge clk)
        if (rst)
            state <= IDLE;
        else
            state <= next_state;

    // Datapath
     always_comb
    begin
        isqrt_x_vld = '0;

        case (state)
        IDLE                  : isqrt_x_vld = arg_vld;
        WAIT_sqrt_c           : isqrt_x_vld = isqrt_y_vld;
        WAIT_sqrt_b_plus_prev : isqrt_x_vld = isqrt_y_vld;        
        endcase
    end


    always_comb
    begin
        isqrt_x = 'x;  // Don't care


        case (state)
        IDLE                  :  
        begin
            isqrt_x = c;
        end
        WAIT_sqrt_c           :  
        begin
            isqrt_x = isqrt_y + b;
        end
        WAIT_sqrt_b_plus_prev : 
        begin
            isqrt_x = isqrt_y + a;
        end
        endcase
    end

    // The result

    always_ff @ (posedge clk)
        if (rst)
            res_vld <= '0;
        else
            res_vld <= ((state == WAIT_sqrt_a_plus_prev) & isqrt_y_vld);




    always_ff @ (posedge clk)
        if (state == IDLE)
            res <= '0;
        else if((state == WAIT_sqrt_a_plus_prev) & isqrt_y_vld)
            res <= isqrt_y;
       
       
     

endmodule
