//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);

    // Task:
    //
    // Implement a pipelined module formula_1_pipe that computes the result
    // of the formula defined in the file formula_1_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_1_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0
     logic        isqrt_1_y_vld;
    logic [15:0] isqrt_1_y;
    
    logic        isqrt_2_y_vld;
    logic [15:0] isqrt_2_y;
    
    logic        isqrt_3_y_vld;
    logic [15:0] isqrt_3_y;
    
    logic        res_vld_comb;
    logic [31:0] res_comb;
    
    
    always_ff @ (posedge clk)
    if (rst)
        res_vld_comb <= '0;
    else
        res_vld_comb <= (isqrt_1_y_vld & isqrt_2_y_vld & isqrt_3_y_vld );
    
    
    always_ff @ (posedge clk)
    if (rst)
        res_comb <= '0;
    else if (isqrt_1_y_vld & isqrt_2_y_vld & isqrt_3_y_vld )
        res_comb <= isqrt_3_y + isqrt_2_y + isqrt_1_y;
    
    
    assign res = res_comb;
    assign res_vld = res_vld_comb;
    
    
    isqrt isqrt_1
    (
       .clk(clk),
       .rst(rst),
       .x_vld(arg_vld),
       .x(a),
       .y_vld(isqrt_1_y_vld),
       .y(isqrt_1_y)
    );
    
    isqrt isqrt_2
    (
       .clk(clk),
       .rst(rst),
       .x_vld(arg_vld),
       .x(b),
       .y_vld(isqrt_2_y_vld),
       .y(isqrt_2_y)
    );
    isqrt isqrt_3
    (
       .clk(clk),
       .rst(rst),
       .x_vld(arg_vld),
       .x(c),
       .y_vld(isqrt_3_y_vld),
       .y(isqrt_3_y)
    );


endmodule
