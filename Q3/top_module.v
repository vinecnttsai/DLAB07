
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
    reg debounced_up_d, debounced_down_d;
    wire up_posedge, down_posedge; 

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        debounced_up_d <= 0;
        debounced_down_d <= 0;
    end else begin
        debounced_up_d <= debounced_up;
        debounced_down_d <= debounced_down;
    end
end

assign up_posedge = debounced_up & ~debounced_up_d;
assign down_posedge = debounced_down & ~debounced_down_d;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        cnt <= 0;
    end else if (up_posedge) begin
        cnt <= cnt + 1;
    end else if (down_posedge) begin
        cnt <= (cnt == 0) ? 15 : cnt - 1;
    end
end


    fq_div #(10000) clk_div ( // 3 for Simulation
        .org_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .div_n_clk(clk)
    ); 
    
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


endmodule
