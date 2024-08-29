
/*
============================================================================
 * Description: Code use for to generate the random packets
 * Author:      Hira Firdous
 * Date:        29/08/2024
 ===========================================================================
*/


module PacketGenerator(
    input  logic        clk,
    input  logic        reset_n,
    input  logic        ready,    
    output logic        valid,     
    output logic [12:0] packet    
);

    // Packet fields
    logic [1:0] dest_addr;
    logic [1:0] pkt_type;
    logic [7:0] payload;
    logic       eop;


    logic [3:0] state;


    always_comb begin
        dest_addr = $urandom_range(0, 3); //rabdomizing the router
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (ready) begin
                        pkt_type  <= 2'b00;   // type will also be example
                        payload   <= 8'hAA;   // taking example
                        eop       <= 1'b1;    
                        valid     <= 1'b1;
                        packet    <= {eop, payload, pkt_type, dest_addr};
                        state     <= 1;
                    end
                end
                1: begin
                    if (ready) begin
                        // Ready for the next packet
                        valid <= 1'b0;
                        state <= 0;
                    end
                end

                default: state <= 0;
            endcase
        end
    end

endmodule

