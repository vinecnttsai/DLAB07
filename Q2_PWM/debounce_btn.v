
module debounce_bnt (
    input sys_clk,
    input sys_rst_n,
    input up,
    input down,
    output reg [6:0] cnt
);

    parameter N = 100;
    wire clk;
    wire debounced_up;
    wire debounced_down;
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
        cnt <= (cnt == 100) ? 0 : cnt + 1;
    end else if (down_posedge) begin
        cnt <= (cnt == 0) ? 100 : cnt - 1;
    end
end


    fq_div #(10000) clk_div ( // 3 for Simulation
        .org_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .div_n_clk(clk)
    ); 

    debounce #(.N(N), .WIDTH(1)) deb1 (
        .clk(clk),
        .sys_rst_n(sys_rst_n),
        .org(up),
        .debounced(debounced_up)
    );

    debounce #(.N(N), .WIDTH(1)) deb2 (
        .clk(clk),
        .sys_rst_n(sys_rst_n),
        .org(down),
        .debounced(debounced_down)
    );


endmodule
