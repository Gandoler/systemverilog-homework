//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

// A non-parameterized module
// that implements the signed multiplication of 4-bit numbers
// which produces 8-bit result

module signed_mul_4
(
  input  signed [3:0] a, b,
  output signed [7:0] res
);

  assign res = a * b;

endmodule

// A parameterized module
// that implements the unsigned multiplication of N-bit numbers
// which produces 2N-bit result

module unsigned_mul
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  output [2 * n - 1:0] res
);

  assign res = a * b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

// Task:
//
// Implement a parameterized module
// that produces either signed or unsigned result
// of the multiplication depending on the 'signed_mul' input bit.

module signed_or_unsigned_mul
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  input                signed_mul,
  output [2 * n - 1:0] res
);
    logic [n - 1:0] a_tmp;
    logic [n - 1:0] b_tmp;
    logic [2 * n - 1:0] out;

    always_comb begin
      
      if(signed_mul) begin
        a_tmp = a[n - 1] ? (~a) + 1 : a;
        b_tmp = b[n - 1] ? (~b) + 1 : b;
        out = a_tmp * b_tmp;
      end
      else  out =  a * b;
    end

   assign res =signed_mul?  ((a[n - 1] ^ b[n - 1])? (~out+1) : out) :out;
  
  
endmodule
