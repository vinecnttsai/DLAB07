

module debounce #(parameter N = 20, parameter WIDTH = 1) (
    input clk,
    input sys_rst_n,
    input [WIDTH-1:0] org,
    output [WIDTH-1:0] debounced
);

    parameter IDLE = 0, HOLD = 1;
    (* mark_debug = "true", dont_touch = "true" *)reg Q;
    (* mark_debug = "true", dont_touch = "true" *)reg Q_next;
    (* mark_debug = "true", dont_touch = "true" *)reg org_reg;
    (* mark_debug = "true", dont_touch = "true" *)wire [$clog2(N + 1) - 1:0] cnt;

    always @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            org_reg <= 0;
        end else begin
            org_reg <= org;
        end
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            Q <= IDLE;
        end else begin
            Q <= Q_next;
        end
    end

    always @(*) begin
        case (Q)
            IDLE: begin
                if (org_reg != org) begin
                    Q_next = HOLD;
                end else begin
                    Q_next = IDLE;
                end
            end
            HOLD: begin
                if (cnt == N - 1) begin
                    Q_next = IDLE;
                end else begin
                    Q_next = HOLD;
                end
            end
        endcase
    end

    locker #(.N(N), .WIDTH(WIDTH)) lc (
        .clk(clk),
        .sys_rst_n(sys_rst_n),
        .lock(Q),
        .org(org_reg),
        .cnt(cnt),
        .debounced(debounced)
    );

endmodule


module locker #(
    parameter N = 20,
    parameter WIDTH = 1
)(
    input clk,
    input sys_rst_n,
    input lock,
    input [WIDTH-1:0] org,
    output reg [$clog2(N + 1) - 1:0] cnt,
    output reg [WIDTH-1:0] debounced
);

    always @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            cnt <= 0;
        end else if (!lock) begin
            cnt <= 0;
        end else if (cnt == N - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            debounced <= 0;
        end else if (!lock) begin
            debounced <= org;
        end
    end

endmodule