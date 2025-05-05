`timescale 1ns/1ps

module tb_sound_keypad;

reg sys_clk;
reg sys_rst_n;
reg [2:0] test_EFG;
wire A, B, C, D;
wire CA, CB, CC, CD, CE, CF, CG, DP;
wire [7:0] AN;
wire tone_clk;

sound_keypad uut (
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .E(test_EFG[2]),
    .F(test_EFG[1]),
    .G(test_EFG[0]),
    .A(A),
    .B(B),
    .C(C),
    .D(D),
    .CA(CA),
    .CB(CB),
    .CC(CC),
    .CD(CD),
    .CE(CE),
    .CF(CF),
    .CG(CG),
    .DP(DP),
    .AN(AN),
    .tone_clk(tone_clk)
);

initial sys_clk = 0;
always #5 sys_clk = ~sys_clk;

task bounce_keypad;
    input [2:0] key_value;
    input [3:0] bouncing_time;
    integer i;
    begin
        for (i = 0; i < bouncing_time; i = i + 1) begin
            test_EFG = key_value;
            #3;
            test_EFG = 3'b000; // bounce to default value
            #3;
            test_EFG = key_value; // back to correct
            #3; 
        end
        test_EFG = 3'b000;
    end
endtask


integer k;
initial begin

    sys_rst_n = 1;
    test_EFG = 3'b000;
    #3 sys_rst_n = 0;
    #3 sys_rst_n = 1;

    for (k = 0; k < 13; k = k + 1) begin
        case (k % 3)
            3'b000: bounce_keypad(3'b001, ($random % 8 + 8) % 8 + 2 ); // bouncing times = 2 ~ 9
            3'b001: bounce_keypad(3'b010, ($random % 8 + 8) % 8 + 2 ); // bouncing times = 2 ~ 9
            3'b010: bounce_keypad(3'b100, ($random % 8 + 8) % 8 + 2); // bouncing times = 2 ~ 9
            default: bounce_keypad(3'b000, ($random % 8 + 8) % 8 + 2); // bouncing times = 2 ~ 9
        endcase
        #120;
    end

    #500;
    $finish;
end

endmodule
