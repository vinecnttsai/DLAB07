`timescale 1ns / 1ps

module tb_top_module;

    reg sys_clk;
    reg sys_rst_n;
    reg up;
    reg down;

    wire CA, CB, CC, CD, CE, CF, CG, DP;
    wire [7:0] AN;

    top_module uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .up(up),
        .down(down),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .DP(DP),
        .AN(AN)
    );

    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

    integer i;
    initial begin
        sys_rst_n = 0;
        #10 sys_rst_n = 1;
    end

    task button_up_bounce;
        input [31:0] bounce_count;
        input [31:0] bounce_time;
        input final_state;
        integer i;
        begin
            for (i = 0; i < bounce_count; i = i + 1) begin
                up = ~up;
                #bounce_time;
            end
            up = final_state;
        end
    endtask
    
    task button_down_bounce;
        input [31:0] bounce_count;
        input [31:0] bounce_time;
        input final_state;
        integer i;
        begin
            for (i = 0; i < bounce_count; i = i + 1) begin
                down = ~down;
                #bounce_time;
            end
            down = final_state;
        end
    endtask

    initial begin
        up = 0;
        down = 0;
        #20;

        for (i = 0; i < 18; i = i + 1) begin
            button_up_bounce(20, 3, 1);
            #200;
            button_up_bounce(20, 3, 0);
            #200;
        end

        for (i = 0; i < 18; i = i + 1) begin
            button_down_bounce(20, 3, 1);
            #200;
            button_down_bounce(20, 3, 0);
            #200;
        end

        $finish;
    end
    
endmodule