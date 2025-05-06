
module top_module (
    input sys_clk,
    input sys_rst_n,
    input up,
    input down,
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

    parameter N = 100; // 5 for Simulation
    (* mark_debug = "true", dont_touch = "true" *)wire clk;
    (* mark_debug = "true", dont_touch = "true" *)wire debounced_up;
    (* mark_debug = "true", dont_touch = "true" *)wire debounced_down;
    (* mark_debug = "true", dont_touch = "true" *)reg [3:0] cnt;
    (* mark_debug = "true", dont_touch = "true" *)wire [31:0] cnt_bcd_32;
    (* mark_debug = "true", dont_touch = "true" *)reg [31:0] cnt_32;


//----------------------------------4-bit counter----------------------------------
/*
    always @(posedge debounced_up or posedge debounced_down or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            cnt = 0;
        end else if (debounced_up) begin
            cnt = cnt + 1;
        end else if (debounced_down) begin
            cnt = cnt - 1;
        end
    end

    svn_dcdr svn1 (
        .in(cnt),
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
*/
//----------------------------------4-bit counter----------------------------------


//----------------------------------32-bit counter----------------------------------
    always @(posedge debounced_up or posedge debounced_down or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            cnt_32 = 0;
        end else if (debounced_up) begin
            cnt_32 = cnt_32 + 1;
        end else if (debounced_down) begin
            cnt_32 = cnt_32 - 1;
        end
    end

    bin_to_bcd #(8) b1 (
        .in(cnt_32),
        .out(cnt_bcd_32)
    );
    
    marquee #(.N(32)) m1 (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .seq(cnt_bcd_32),
        .enable(1'b0),
        .dir(1'b0),
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
//----------------------------------32-bit counter----------------------------------


//----------------------------------debounce----------------------------------
    fq_div #(10000) clk_div ( // 3 for Simulation
        .org_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .div_n_clk(clk)
    ); 

    (* keep_hierarchy = "yes" *)debounce #(.N(N), .WIDTH(1)) deb1 (
        .clk(clk),
        .sys_rst_n(sys_rst_n),
        .org(up),
        .debounced(debounced_up)
    );

    (* keep_hierarchy = "yes" *)debounce #(.N(N), .WIDTH(1)) deb2 (
        .clk(clk),
        .sys_rst_n(sys_rst_n),
        .org(down),
        .debounced(debounced_down)
    );

//----------------------------------debounce----------------------------------

endmodule
