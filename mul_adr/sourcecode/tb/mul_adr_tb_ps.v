
module mul_adr_tb;

    // Inputs
    reg [7:0] a_in;
    reg [7:0] b_in;
    reg [15:0] tv;
    reg v;

    // Output
    wire [15:0] p_out;
    wire [8:0] s;

    // Instantiate the Unit Under Test (UUT)
    //mm_251 uut (
    //    .a_in(a_in), 
    //    .b_in(b_in), 
    //    .p_out(p_out)
    //);
    // Instantiate the Unit Under Test (UUT)
    mul_adr DUT (
        // .am_in(a_in), 
        // .bm_in(b_in), 
        .aa_in(a_in), 
        .ba_in(b_in), 
        .am_in(8'd0), 
        .bm_in(8'd0), 
        // .aa_in(8'd0), 
        // .ba_in(8'd0), 
    
	.s_out(s),
        .p_out(p_out)
    );

    // Task to check expected value
    task automatic check_mul(input [7:0] a, input [7:0] b);
        reg [15:0] mult;
        begin
            a_in = a;
            b_in = b;
            // #10; // Wait for the output to stabilize
            mult = (a * b);
            v = (p_out === mult[7:0])?1:0;
            $display("a = %d, b = %d, (a*b) %% 251 = %d, p_out = %d %s",
                     a, b, mult[7:0], p_out,
                     (p_out === mult[7:0]) ? "1" : "0");
        end
    endtask
    reg clk;
	`ifdef BACKANNOTATION
	initial 
	begin
	    $sdf_annotate(`SDF_FILE,DUT,,"/home/users/rushikeshk/mul_adr/export/sim/sdf.log","MAXIMUM");
//    	$dumpfile("/home/users/rushikeshk/GN/MM251/sim/out_files/synth65/mm251.vcd"); // Specify VCD file name
//    	$dumpvars(0, tb_mm_251_ps);    // Dump all variables within the module
	end
	`endif
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    //    forever #10 clk = ~clk;
    //    forever #10 clk = ~clk;
      end
    initial begin
        $display("Starting testbench for mm_251...");
        tv = 256;
//        clk = 0;
        // Test vectors
        check_mul(0, 0);
//        check_mul(1, 1);
//        check_mul(5, 7);
//        check_mul(100, 200);
//        check_mul(250, 250);
//        check_mul(123, 87);
//        check_mul(250, 1);
//        check_mul(1, 250);
//        check_mul(251, 251); // Input out of range, but testing behavior
//        repeat (256*256) @(posedge clk);
        repeat (256*255) @(posedge clk);
        $display("Testbench completed.");
        $stop;
    end
    
    always@(posedge clk)
    begin
                check_mul(tv[15:8], tv[7:0]);
                #1 tv = tv +1;
    end
    

endmodule
