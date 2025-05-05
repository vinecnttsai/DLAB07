module tb_top_module;

    localparam WIDTH = 4;
    localparam DIGITS = 19;

    reg sys_clk;
    reg sys_rst_n;
    reg shift_enable;
    reg cnt_enable;
    reg dir;
    reg U_D;
    reg high_cnt;
    reg low_cnt;
    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;

    top_module uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .shift_enable(shift_enable),
        .cnt_enable(cnt_enable),
        .dir(dir),
        .U_D(U_D),
        .high_cnt(high_cnt),
        .low_cnt(low_cnt),
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

    // Clock generation
    always begin
        sys_clk = 0; #1 sys_clk = 1; #1;
    end

    initial begin
        // Initialize signals
        sys_rst_n = 1;
        shift_enable = 1;
        cnt_enable = 1;
        dir = 0;
        high_cnt = 1;
        low_cnt = 0;
        U_D = 1;
        
        // Reset the system
        #3 sys_rst_n = 0;
        #3 sys_rst_n = 1;
        
        // Test count enable, shift enable
        #500 cnt_enable = 0;
        #50 cnt_enable = 1;
        
        // Count at low requency, downward
        high_cnt = 0;
        low_cnt = 1;
        U_D = 0;
        
        #2000 $finish;
    end

endmodule
