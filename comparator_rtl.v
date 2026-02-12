module comparator_8bit_clk (
    input  wire        clk,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg         equal,
    output reg         greater,
    output reg         less
);

wire [7:0] xnor_bits;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : xnor_loop
        assign xnor_bits[i] = ~(a[i] ^ b[i]);
    end
endgenerate

wire eq_wire = &xnor_bits;

wire gt_wire = (a[7] & ~b[7]) |
               ( xnor_bits[7] & (a[6] & ~b[6]) ) |
               ( &xnor_bits[7:6] & (a[5] & ~b[5]) ) |
               ( &xnor_bits[7:5] & (a[4] & ~b[4]) ) |
               ( &xnor_bits[7:4] & (a[3] & ~b[3]) ) |
               ( &xnor_bits[7:3] & (a[2] & ~b[2]) ) |
               ( &xnor_bits[7:2] & (a[1] & ~b[1]) ) |
               ( &xnor_bits[7:1] & (a[0] & ~b[0]) );

wire lt_wire = (~a[7] & b[7]) |
               ( xnor_bits[7] & (~a[6] & b[6]) ) |
               ( &xnor_bits[7:6] & (~a[5] & b[5]) ) |
               ( &xnor_bits[7:5] & (~a[4] & b[4]) ) |
               ( &xnor_bits[7:4] & (~a[3] & b[3]) ) |
               ( &xnor_bits[7:3] & (~a[2] & b[2]) ) |
               ( &xnor_bits[7:2] & (~a[1] & b[1]) ) |
               ( &xnor_bits[7:1] & (~a[0] & b[0]) );

always @(posedge clk) begin
    equal   <= eq_wire;
    greater <= gt_wire;
    less    <= lt_wire;
end

endmodule

