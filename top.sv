module top_module (
    input  logic         clk,
    input  logic         rst,
    input  logic         src_valid,
    input  logic         dd_ready,
    output logic         src_ready,
    output logic         dd_valid,
    output logic [12:0]  packet
);

    // Internal signal to trigger packet generation
    logic generate_packet;

    // Instantiate the control unit
    control_unit u_control_unit (
        .clk            (clk),
        .rst            (rst),
        .src_valid      (src_valid),
        .dd_ready       (dd_ready),
        .src_ready      (src_ready),
        .dd_valid       (dd_valid),
        .generate_packet(generate_packet)
    );

    // Instantiate the packet generator
    packet_generator u_packet_generator (
        .clk            (clk),
        .rst            (rst),
        .generate_packet(generate_packet),
        .packet         (packet)
    );

endmodule
