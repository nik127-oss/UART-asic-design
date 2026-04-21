module UART
#(parameter CLKS_PER_BIT = 217)
(
    input        i_Clock,

    // TX Interface
    input        i_TX_DV,
    input  [7:0] i_TX_Byte,
    output       o_TX_Active,
    output       o_TX_Done,

    // RX Interface
    output       o_RX_DV,
    output [7:0] o_RX_Byte
);

    // Internal wire (this is your UART line)
    wire w_UART_Line;
    wire w_TX_Serial;

    UART_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) TX_INST (
        .i_Clock(i_Clock),
        .i_TX_DV(i_TX_DV),
        .i_TX_Byte(i_TX_Byte),
        .o_TX_Active(o_TX_Active),
        .o_TX_Serial(w_TX_Serial),
        .o_TX_Done(o_TX_Done)
    );

    // UART Line Behavior (IDLE = HIGH)
    assign w_UART_Line = (o_TX_Active) ? w_TX_Serial : 1'b1;

    UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) RX_INST (
        .i_Clock(i_Clock),
        .i_RX_Serial(w_UART_Line),
        .o_RX_DV(o_RX_DV),
        .o_RX_Byte(o_RX_Byte)
    );

endmodule