module fq_div_even #(parameter N = 2)(
    input org_clk,
    input sys_rst_n,
    output reg div_n_clk
); 
    reg [63:0] count;

always @(posedge org_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        count <= 0;
        div_n_clk <= 0;
    end else begin
        if (count == (N/2 - 1)) begin
            div_n_clk <= ~div_n_clk;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule
