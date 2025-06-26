//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts serial data to the parallel multibit value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits, the module should assert the parallel_valid
    // output and set the data.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
  always_ff @ (posedge clk or posedge rst) begin 
     if (rst) begin
       parallel_data <= 'b0;
       cnt <= 'b0;
       end
     else if (serial_valid) begin
       cnt <= cnt + 'b1;
       parallel_data <= { serial_data,  parallel_data[width - 1 : 1] };
       end
       
     parallel_valid <= (cnt == (width-1)) & serial_valid;
        
  end

endmodule
