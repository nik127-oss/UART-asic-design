`timescale 1ns/10ps

`include "UART.v"

module UART_TB();

 parameter c_CLOCK_PERIOD_NS = 40;
 parameter c_CLKS_PER_BIT   = 217;

 reg r_Clock = 0;
 reg r_TX_DV = 0;
 reg [7:0] r_TX_Byte = 0;

 wire w_TX_Active;
 wire w_RX_DV;
 wire [7:0] w_RX_Byte;

 // ================= DUT =================
 UART #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_INST
 (
    .i_Clock(r_Clock),

    .i_TX_DV(r_TX_DV),
    .i_TX_Byte(r_TX_Byte),
    .o_TX_Active(w_TX_Active),
    .o_TX_Done(),

    .o_RX_DV(w_RX_DV),
    .o_RX_Byte(w_RX_Byte)
 );

 // ================= CLOCK =================
 always #(c_CLOCK_PERIOD_NS/2) r_Clock <= ~r_Clock;

 // ================= STIMULUS =================
 initial begin
    @(posedge r_Clock);
    @(posedge r_Clock);

    r_TX_DV   <= 1'b1;
    r_TX_Byte <= 8'h3F;

    @(posedge r_Clock);
    r_TX_DV <= 1'b0;

    // Wait enough time for full transmission
    #(c_CLKS_PER_BIT * 10 * c_CLOCK_PERIOD_NS);

    $finish;
 end

endmodule