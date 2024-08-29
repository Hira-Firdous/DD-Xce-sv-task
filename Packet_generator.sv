module packet_generator(
    input  logic         clk,
    input  logic         rst,
    input  logic         generate_packet,
    output logic [12:0]  packet
);

    logic [1:0] dest_addr; 
    logic [1:0] packet_type; 
    logic [7:0] payload;
    logic       eop;

    always_comb begin
        if (generate_packet) begin
            //genarting random packets. 
            dest_addr   = $urandom_range(0, 3);  
            packet_type = $urandom_range(0, 3); 
            payload     = $urandom;            
            eop         = $urandom_range(0, 1); 
        end else begin
            // Default values when not generating a packet
            dest_addr   = 2'b00;
            packet_type = 2'b00;
            payload     = 8'b00000000;
            eop         = 1'b0;
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            packet <= 13'b0;
        end else if (generate_packet) begin
            packet <= {dest_addr, packet_type, payload, eop};
        end
    end

endmodule
