//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe
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
    // Implement a pipelined module formula_2_pipe that computes the result
    // of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
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
    
    
    logic [31:0] shift_register_1_data;
    logic        shift_register_1_valid;
    
    logic [31:0] shift_register_2_data;
    logic        shift_register_2_valid;  
    
    
    logic [31:0] sum1_reg;
    logic        sum_1_en;
    
    logic [31:0] sum2_reg;
    logic        sum_2_en;
    
    
    
    
    
  shift_register_with_valid # (.width(width), .depth(isqrt_latency)) shift_register_1
  (
     .clk(clk),
     .rst(rst),
     
     .in_vld(arg_vld),
     .in_data(b),
     
     .out_vld(shift_register_1_valid),
     .out_data(shift_register_1_data)
  );
  
  
  shift_register_with_valid # (.width(width), .depth(2*isqrt_latency + 1)) shift_register_2
  (
     .clk(clk),
     .rst(rst),
     
     .in_vld(arg_vld),
     .in_data(a),
     
     .out_vld(shift_register_2_valid),
     .out_data(shift_register_2_data)
  );



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
       .x(sum1_reg),
       .y_vld(isqrt_2_y_vld),
       .y(isqrt_2_y)
    );
    isqrt isqrt_3
    (
       .clk(clk),
       .rst(rst),
       .x_vld(arg_vld),
       .x(sum2_reg),
       .y_vld(isqrt_3_y_vld),
       .y(isqrt_3_y)
    );
    
    
    
    assign res_vld = isqrt_3_y_vld;
    assign res     = isqrt_3_y;
    
    // первый регистр с en
    always_ff @(posedge clk) begin
      if (rst) 
        sum_1_en <= '0;
      else if(~rst)
        sum_1_en <= shift_register_1_valid;
      else if (sum_1_en)
        sum1_reg <= shift_register_1_data + isqrt_1_y;
     end
     
     // второй регистр с en
    always_ff @(posedge clk) begin
      if (rst) 
        sum_2_en <= '0;
      else if(~rst)
        sum_2_en <= shift_register_2_valid;
      else if (sum_2_en)
        sum2_reg <= shift_register_2_data + isqrt_2_y;
     end
    

endmodule
