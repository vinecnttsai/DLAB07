module timer_dec #(parameter Max = 15, parameter Min = 0, parameter Initial = 0, parameter DEC_DIGITS = 2) (
    input clk,
    input sys_rst_n,
    input [1:0] U_D, // 1 for up, 0 for hold, 3(-1 in 2's complement) for down
    output [1:0] carry_out,  // 1 for up, 0 for hold, 3(-1 in 2's complement) for down
    output [DEC_DIGITS*4 - 1:0] cnt_dec
);
    wire [$clog2(Max + 1) - 1:0] cnt;
    wire [DEC_DIGITS*4 - 1:0] cnt_padded;
    assign cnt_padded = {{(DEC_DIGITS*4 - $clog2(Max + 1)){1'b0}}, cnt};


    timer #(.Max(Max), .Min(Min), .Initial(Initial)) timer_inst (
        .clk(clk),
        .sys_rst_n(sys_rst_n),
        .carry_in(U_D),
        .carry_out(carry_out),
        .cnt(cnt)
    );

    b2d_converter #(.DEC_DIGITS(DEC_DIGITS)) b2d_converter_inst (
        .in(cnt_padded),
        .out(cnt_dec)
    );

endmodule

module timer #(
    parameter Max = 60,
    parameter Min = 0, 
    parameter Initial = 0
)(
    input clk,
    input sys_rst_n,
    input [1:0] carry_in,
    output reg [1:0] carry_out,
    output reg [$clog2(Max + 1) - 1:0] cnt
);
    always @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            cnt <= Initial;
            carry_out <= 2'b00;
        end else if (carry_in == 2'b00) begin // hold
            cnt <= cnt;
            carry_out <= 2'b00;
        end else if (carry_in == 2'b01) begin // up
            if (cnt == Max) begin
                cnt <= Min;
                carry_out <= 2'b01; // +1 in 2's complement
            end else begin
                cnt <= cnt + 1;
                carry_out <= 2'b00; // no carry out
            end
        end else if (carry_in == 2'b11) begin // down
            if (cnt == Min) begin
                cnt <= Max;
                carry_out <= 2'b11; // -1 in 2's complement
            end else begin
                cnt <= cnt - 1;
                carry_out <= 2'b00; // no carry out
            end
        end else begin // hold for carry_in == 0
            cnt <= cnt;
            carry_out <= 2'b00;
        end
    end

endmodule

module b2d_converter #(
    parameter DEC_DIGITS = 4
)(
    input  [(DEC_DIGITS*4)-1:0] in,
    output reg  [(DEC_DIGITS*4)-1:0] out
);

    localparam N = DEC_DIGITS * 4;
    integer i, j;
    reg [N + DEC_DIGITS*4 - 1:0] shift_reg;

    always @(*) begin
        shift_reg = 0;
        shift_reg[N-1:0] = in;

        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < DEC_DIGITS; j = j + 1) begin
                if (shift_reg[N + j*4 +: 4] >= 5)
                    shift_reg[N + j*4 +: 4] = shift_reg[N + j*4 +: 4] + 3;
            end
            shift_reg = shift_reg << 1;
        end

        for (j = 0; j < DEC_DIGITS; j = j + 1) begin
            out[j*4 +: 4] = shift_reg[N + j*4 +: 4];
        end
    end
endmodule
