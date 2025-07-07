
module mul_adr(
	input [7:0] am_in,bm_in,aa_in,ba_in,
	output [8:0] s_out,
	output [15:0] p_out
);
	wire [7:0] am,bm,aa,ba;
	
	assign am = am_in;
	assign bm = bm_in;
	// assign aa = aa_in;
	// assign ba = ba_in;
	// assign am = 8'd0;
	// assign bm = 8'd0;
	assign aa = 8'd0;
	assign ba = 8'd0;
	
	mul u1(am,bm,p_out);
	add u2(aa,ba,s_out);
endmodule;


module mul(
	input [7:0] a_in,b_in,
	output [15:0] p_out
);

	assign p_out = a_in * b_in;
endmodule;

module add(
	input [7:0] a_in,b_in,
	output [8:0] s_out
);

	assign s_out = a_in + b_in;
endmodule;