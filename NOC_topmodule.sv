/*
============================================================================
 * Description: whole NOC
 * Author:      Hira Firdous
 * Date:        29/08/2024
 ===========================================================================
*/

module NOC_TOP_Module(
    input  logic        clk,
    input  logic        reset,
    input  logic [12:0] packet,
    input  logic        valid,
    output logic        ready
);

    // Internal signals
    logic decode, routing, buffer_enable;
    logic router_ack, router_available;
    logic buffer;

    // Instantiate the Datapath module
    Datapath datapath_inst (
        .clk(clk),
        .reset(reset),
        .packet(packet),
        .decode(decode),
        .routing(routing),
        .buffer_enable(buffer_enable),
        .router_ack(router_ack),
        .router_available(router_available)
    );

endmodule