//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_impl_2_fsm
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

    output logic        isqrt_1_x_vld,
    output logic [31:0] isqrt_1_x,

    input               isqrt_1_y_vld,
    input        [15:0] isqrt_1_y,

    output logic        isqrt_2_x_vld,
    output logic [31:0] isqrt_2_x,

    input               isqrt_2_y_vld,
    input        [15:0] isqrt_2_y
);

    // Task:
    // Implement a module that calculates the formula from the `formula_1_fn.svh` file
    // using two instances of the isqrt module in parallel.
    //
    // Design the FSM to calculate an answer and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm
      enum logic [2:0]
    {
        IDLE         = 3'd0,
        WAIT_a_b        = 3'd1,
        WAIT_c       = 3'd2
    }
    state, next_state;

    always_comb
    begin
        next_state = state;

        case (state)
        IDLE       : if ( arg_vld     )   next_state = WAIT_a_b;
        WAIT_a_b   : if ( isqrt_1_y_vld & isqrt_2_y_vld ) next_state = WAIT_c;
        WAIT_c  : if ( isqrt_1_y_vld ) next_state = IDLE;
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
        isqrt_1_x_vld = '0;
        isqrt_2_x_vld = '0;

        case (state)
        IDLE     : begin
            isqrt_1_x_vld = arg_vld;
            isqrt_2_x_vld = arg_vld;
        end

        WAIT_a_b : begin
            isqrt_1_x_vld = isqrt_1_y_vld;
        end
        endcase
    end



    always_comb
    begin
        isqrt_1_x = 'x;  // Don't care
        isqrt_2_x = 'x;  // Don't care

        case (state)
        IDLE : 
        begin
            isqrt_1_x = a;
            isqrt_2_x = b;
        end
        WAIT_a_b :  
        begin
            isqrt_1_x = c;
        end
        endcase
    end

    // The result

    always_ff @ (posedge clk)
        if (rst)
            res_vld <= '0;
        else
            res_vld <= (state == WAIT_c & isqrt_1_y_vld);




    always_ff @ (posedge clk)
        if (state == IDLE)
            res <= '0;
        else if (state == WAIT_a_b & isqrt_1_y_vld)
                res <= (res + isqrt_1_y) + isqrt_2_y;
        else if (state == WAIT_c & isqrt_1_y_vld)
                res <= res + isqrt_1_y;



endmodule
