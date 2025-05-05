module sound_keypad (
    input sys_clk,
    input sys_rst_n,
    input E,
    input F,
    input G,
    output A,
    output B,
    output C,
    output D,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output [7:0] AN,
    output tone_clk
);
    wire [3:0] key_pad;    

    keypad k1 (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .E(E),
        .F(F),
        .G(G),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .locked_out(key_pad)
    );

    tone_dcdr tone_gen (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .key_pad(key_pad),
        .tone_clk(tone_clk)
    );

    // unused during Simulation
    (* keep_hierarchy = "yes" *)svn_dcdr uut2 (
        .in(key_pad),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .DP(DP)
    );
    assign AN = 8'b1111_1110; // Display on the first digit


endmodule