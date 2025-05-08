module tone_dcdr (
    input sys_clk,
    input sys_rst_n,
    input [3:0] key_pad,
    input [6:0] duty_cycle,
    output tone_clk
);

wire [11:0] tone;

(* keep_hierarchy = "yes" *)mux #(.N(12), .WIDTH(1)) mux_tone (
    .data_in(tone),
    .default_in(1'b0),
    .sel(key_pad - 1),
    .out(tone_clk)
);

PWM_fq_div #(381_678) one ( 
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[0])
);

PWM_fq_div #(340_136) two ( 
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[1])
);

PWM_fq_div #(303_030) three (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[2])
);

PWM_fq_div #(286_532) four (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[3])
);

PWM_fq_div #(255_102) five (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[4])
);

PWM_fq_div #(227_272) six (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[5])
);


PWM_fq_div #(202_428) seven (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[6])
);

PWM_fq_div #(191_204) eight (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[7])
);

PWM_fq_div #(170_358) nine (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[8])
);

PWM_fq_div #(151_744) ten (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[9])
);

PWM_fq_div #(143_266) eleven (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[10])
);

PWM_fq_div #(127_550) twelve (
    .sys_rst_n(sys_rst_n),
    .org_clk(sys_clk),
    .duty_cycle(duty_cycle),
    .div_n_clk(tone[11])
);

endmodule