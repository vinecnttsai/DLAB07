module top_module (
    input sys_clk,
    input sys_rst_n,
    input shift_enable,
    input cnt_enable,
    input U_D,
    input dir,
    input high_cnt,
    input low_cnt,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output [7:0] AN
);
    localparam WIDTH = 4;
    localparam DIGITS = 20;
    localparam [WIDTH - 1 : 0] dash = 4'hd;
    wire [WIDTH * 4 - 1:0] year;
    wire [WIDTH * 2 - 1:0] month;
    wire [WIDTH * 2 - 1:0] day;
    wire [WIDTH * 2 - 1:0] hour;
    wire [WIDTH * 2 - 1:0] minute;
    wire [WIDTH * 2 - 1:0] second;
    
    //====================Display=====================/
    marquee #(.N(WIDTH * DIGITS)) m1 (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .enable(shift_enable),
        .dir(dir),
        .seq({year, dash, month, dash, day, dash, hour, dash, minute, dash, second, 4'hf}),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .DP(DP),
        .AN(AN)
    );

    //====================Timer's Frequency=====================/
    wire clk_default, clk_low, clk_high;
    wire clk_cnt;
    fq_div #(50_000_000) fq_div_default ( // 8 for Simulation
        .sys_rst_n(sys_rst_n),
        .org_clk(sys_clk),
        .div_n_clk(clk_default)
    );

    fq_div #(10_000_000) fq_div_low ( // 5 for Simulation
        .sys_rst_n(sys_rst_n),
        .org_clk(sys_clk),
        .div_n_clk(clk_low)
    );

    fq_div #(100_000) fq_div_high ( // 3 for Simulation
        .sys_rst_n(sys_rst_n),
        .org_clk(sys_clk),
        .div_n_clk(clk_high)
    );

    assign clk_cnt = (high_cnt) ? clk_high : ((low_cnt)  ? clk_low : clk_default);


    //====================Timer=====================/
    // Carry id:  1 for down, 0 for hold, 3(-1 in 2's complement) for down

    wire [1:0] carry_chain [5:0];
    wire [1:0] carry_in;
    assign carry_in = (cnt_enable) ? ((U_D) ? 2'b01 : 2'b11) : 2'b00;

    timer_dec #(.Max(10000 - 1), .Min(0), .Initial(2025), .DEC_DIGITS(4)) timer_year (
        .clk(clk_cnt),
        .sys_rst_n(sys_rst_n),
        .U_D(carry_chain[4]),
        .carry_out(carry_out),
        .cnt_dec(year)
    );

    timer_dec #(.Max(13 - 1), .Min(1), .Initial(4), .DEC_DIGITS(2)) timer_month (
        .clk(clk_cnt),
        .sys_rst_n(sys_rst_n),
        .U_D(carry_chain[3]),
        .carry_out(carry_chain[4]),
        .cnt_dec(month)
    );

    timer_dec #(.Max(32 - 1), .Min(1), .Initial(23), .DEC_DIGITS(2)) timer_day (
        .clk(clk_cnt),
        .sys_rst_n(sys_rst_n),
        .U_D(carry_chain[2]),
        .carry_out(carry_chain[3]),
        .cnt_dec(day)
    );

    timer_dec #(.Max(24 - 1), .Min(0), .Initial(10), .DEC_DIGITS(2)) timer_hour ( // MAX = 4 - 1 for Simulation
        .clk(clk_cnt),
        .sys_rst_n(sys_rst_n),
        .U_D(carry_chain[1]),
        .carry_out(carry_chain[2]),
        .cnt_dec(hour)
    );

    timer_dec #(.Max(60 - 1), .Min(0), .Initial(0), .DEC_DIGITS(2)) timer_minute ( // MAX = 5 - 1 for Simulation
        .clk(clk_cnt),
        .sys_rst_n(sys_rst_n),
        .U_D(carry_chain[0]),
        .carry_out(carry_chain[1]),
        .cnt_dec(minute)
    );

    timer_dec #(.Max(60 - 1), .Min(0), .Initial(0), .DEC_DIGITS(2)) timer_second ( // MAX = 10 - 1 for Simulation
        .clk(clk_cnt),
        .sys_rst_n(sys_rst_n),
        .U_D(carry_in),
        .carry_out(carry_chain[0]),
        .cnt_dec(second)
    );

    


endmodule