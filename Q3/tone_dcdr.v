module tone_dcdr (
    input sys_clk,
    input sys_rst_n,
    input [3:0] key_pad,
    output tone_clk
);

wire [11:0] tone;

(* keep_hierarchy = "yes" *)mux #(.N(12), .WIDTH(1)) mux_tone (
    .data_in(tone),
    .default_in(1'b0),
    .sel(key_pad - 1),
    .out(tone_clk)
);

fq_div_even #(381_678) one ( 
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[0])
);

fq_div_even #(340_136) two ( 
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[1])
);

fq_div_even #(303_030) three (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[2])
);

fq_div_even #(286_532) four (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[3])
);

fq_div_even #(255_102) five (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[4])
);

fq_div_even #(227_272) six (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[5])
);


fq_div_even #(202_428) seven (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[6])
);

fq_div_even #(191_204) eight (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[7])
);

fq_div_even #(170_358) nine (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[8])
);

fq_div_even #(151_744) ten (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[9])
);

fq_div_even #(143_266) eleven (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[10])
);

fq_div_even #(127_550) twelve (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[11])
);



endmodule
/*
module tone_dcdr (
    input sys_clk,
    input sys_rst_n,
    input [3:0] key_pad,
    output tone_clk
);

wire [11:0] tone;

(* keep_hierarchy = "yes" *)mux #(.N(12), .WIDTH(1)) mux_tone (
    .data_in(tone),
    .default_in(1'b0),
    .sel(key_pad - 1),
    .out(tone_clk)
);

fq_div_even #(2) one (      // 381_678
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[0])
);

fq_div_even #(4) two (      // 340_136
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[1])
);

fq_div_even #(8) three (    // 303_030
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[2])
);

fq_div_even #(16) four (   // 286_532
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[3])
);

fq_div_even #(32) five (   // 255_102
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[4])
);

fq_div_even #(64) six (    // 227_272
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[5])
);

fq_div_even #(64) seven (   // 202_428
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[6])
);

fq_div_even #(32) eight (   // 191_204
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[7])
);

fq_div_even #(16) nine (    // 170_358
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[8])
);

fq_div_even #(8) ten (      // 151_744
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[9])
);

fq_div_even #(4) eleven (   // 143_266
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[10])
);

fq_div_even #(2) twelve (   // 127_550
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .div_n_clk(tone[11])
);

endmodule
*/