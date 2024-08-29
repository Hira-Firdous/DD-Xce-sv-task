/*
============================================================================
 * Description: dummy router mimicks the functionality of the router
 * Author:      Hira Firdous
 * Date:        29/08/2024
 ===========================================================================
*/
module RDatapath(
    input  logic        clk,
    input  logic        reset,
    input  logic [12:0] packet, 
    input  logic        decode,
    input  logic        routing,
    input  logic        buffer_enable,
    output logic        router_ack,
    output logic        router_available
);

    //logic [ buffer_data;

    logic [1:0] dest_addr;
    logic [1:0] pkt_type;
    logic [7:0] payload;
    logic       eop;


    always_comb begin
        if (decode) begin
            //packet 
            dest_addr=packet[12:11];
            pkt_type=packet[10:9];
            payload=packet[8:2];
            eop=packet[1:0];
        end
        else begin
            dest_addr=0;
            pkt_type=0;
            payload=0;
            eop=0;
        end
    end
    // Datapath Operations
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            //buffer_data <= 8'b0;
            router_ack<=0;
            router_available<=1;
        end else begin
            if (routing) begin
                //will do the routing
                router_available<=1;
                //TODO:This will change depending upon the value of
                      //the router and the value of buffer
                router_ack<=1;
                
            end

            if (buffer_enable) begin
                //will store the buffer
            end
        end
    end

    // Output Assignment
    assign data_out = data;

endmodule
