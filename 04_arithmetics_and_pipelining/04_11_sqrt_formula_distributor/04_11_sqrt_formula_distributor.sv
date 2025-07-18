module sqrt_formula_distributor
# (
    parameter formula = 1,
              impl    = 1
)
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
    // Implement a module that will calculate formula 1 or formula 2
    // based on the parameter values. The module must be pipelined.
    // It should be able to accept new triple of arguments a, b, c arriving
    // at every clock cycle.
    //
    // The idea of the task is to implement hardware task distributor,
    // that will accept triplet of the arguments and assign the task
    // of the calculation formula 1 or formula 2 with these arguments
    // to the free FSM-based internal module.
    //
    // The first step to solve the task is to fill 03_04 and 03_05 files.
    //
    // Note 1:
    // Latency of the module "formula_1_isqrt" should be clarified from the corresponding waveform
    // or simply assumed to be equal 50 clock cycles.
    //
    // Note 2:
    // The task assumes idealized distributor (with 50 internal computational blocks),
    // because in practice engineers rarely use more than 10 modules at ones.
    // Usually people use 3-5 blocks and utilize stall in case of high load.
    //
    // Hint:
    // Instantiate sufficient number of "formula_1_impl_1_top", "formula_1_impl_2_top",
    // or "formula_2_top" modules to achieve desired performance.
    localparam N = 50;
    
    logic [6:0]   counter;
        
    logic [31:0]  a_array         [0 : N-1];
    logic [31:0]  b_array         [0 : N-1];
    logic [31:0]  c_array         [0 : N-1];
    logic [N-1:0] vld_array;
    
    
    logic [31:0]  res_array       [0:N-1];
    logic [N-1:0] res_vld_array;

    
    
    always_ff @(posedge clk) begin
      if(rst) 
        counter  <= 'b0;
      else 
      if(arg_vld) begin
        counter  <= (counter == N-1) ? 'b0: counter + 'b1;
      end
    end
    
    
    always_ff @(posedge clk) begin
      for(int j = 0; j < N ; j++) begin
        if(arg_vld & (j == counter)) begin
          a_array[j] <= a;  
          b_array[j] <= b;
          c_array[j] <= c;
        end
      end
    end
    
    
    always_ff @(posedge clk) begin
      if (rst) begin
        vld_array <= N'(0);
      end
      else begin
        for(int j = 0; j < N ; j++) begin
          if(j == counter &  arg_vld) 
            vld_array[j] <=  'b1;  // вот тут у меня просто присваивалась еденица, и из-за этого я потратил 2 часа !! запомнить 
                                      // если каунтер и равен нужному это же не значит что аргумнты валидны  
          else 
            vld_array[j] <= 'b0;
        end
      end 
    end
    
    genvar i;
    
    generate 
      for(i = 0; i < N; i++) begin
        if (formula == 1) begin
          if (impl == 1)begin
            formula_1_impl_1_top formula_top_i
            (
               .clk(clk),
               .rst(rst),
               
               .arg_vld(vld_array[i]),
               .a(a_array[i]),
               .b(b_array[i]),
               .c(c_array[i]),
               
               .res_vld(res_vld_array[i]),
               .res(res_array[i])
            );
          
          end else if (impl == 2) begin
            formula_1_impl_2_top formula_top_i
            (
                .clk(clk),
                .rst(rst),
                
                .arg_vld(vld_array[i]),
                .a(a_array[i]),
                .b(b_array[i]),
                .c(c_array[i]),
                
                .res_vld(res_vld_array[i]),
                .res(res_array[i])
            );
        
          end
          
        end else if (formula == 2) begin
          formula_2_top formula_top_i
          (
              .clk(clk),
              .rst(rst),
              
              .arg_vld(vld_array[i]),
              .a(a_array[i]),
              .b(b_array[i]),
              .c(c_array[i]),
              
              .res_vld(res_vld_array[i]),
              .res(res_array[i])
          );
        
        end
      end
    endgenerate 
    
    
    logic [31:0] res_comb;
    assign res_vld = |res_vld_array;
    assign res = res_comb;
    always_comb
        for (int j = 0; j < N; j++)
            if (res_vld_array[j]) begin
                res_comb = res_array[j];
            end


endmodule
