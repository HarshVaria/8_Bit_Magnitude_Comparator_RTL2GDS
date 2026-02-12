`timescale 1ns/1ns
`include "comparator_rtl.v" 

module testbench;

    reg [7:0] A, B;
    reg Clock;
    wire equal, greater, less;

    // Instantiate the DUT
    comparator_8bit_clk dut (
        .clk(Clock),
        .a(A),
        .b(B),
        .equal(equal),
        .greater(greater),
        .less(less)
    );

    // Clock Generation (10ns period)
    initial Clock = 0;
    always #5 Clock = ~Clock;

    // Waveform generation (VCD + FSDB)
    initial begin
        // For GTKWave (VCD)
        $dumpfile("comparator_wave.vcd");
        $dumpvars(0, testbench);

        // For Verdi (FSDB)
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, testbench);
    end

    // Stimulus
    initial begin
        A = 0; B = 0;

        // Test Case 1: Equal
        #12 A = 8'd25; B = 8'd25;
        @(posedge Clock); #1;
        $display("A = %d, B = %d => Equal: %b, Greater: %b, Less: %b", A, B, equal, greater, less);

        // Test Case 2: Greater
        #10 A = 8'd200; B = 8'd100;
        @(posedge Clock); #1;
        $display("A = %d, B = %d => Equal: %b, Greater: %b, Less: %b", A, B, equal, greater, less);

        // Test Case 3: Less
        #10 A = 8'd5; B = 8'd50;
        @(posedge Clock); #1;
        $display("A = %d, B = %d => Equal: %b, Greater: %b, Less: %b", A, B, equal, greater, less);

        // Test Case 4: Edge case (0 vs 255)
        #10 A = 8'd0; B = 8'd255;
        @(posedge Clock); #1;
        $display("A = %d, B = %d => Equal: %b, Greater: %b, Less: %b", A, B, equal, greater, less);

        // Test Case 5: Random mid values
        #10 A = 8'd127; B = 8'd128;
        @(posedge Clock); #1;
        $display("A = %d, B = %d => Equal: %b, Greater: %b, Less: %b", A, B, equal, greater, less);

        // Test Case 6: Back to Equal
        #10 A = 8'd100; B = 8'd100;
        @(posedge Clock); #1;
        $display("A = %d, B = %d => Equal: %b, Greater: %b, Less: %b", A, B, equal, greater, less);

        #50 $finish;
    end

endmodule

