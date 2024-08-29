/*
============================================================================
 * Description: controller of the Router
 * Author:      Hira Firdous
 * Date:        29/08/2024
 ===========================================================================
*/

module RController(
    input  logic clk,
    input  logic reset,
    input  logic valid,
    input  logic router_ack,
    input  logic router_available,
    input  logic buffer,
    output logic decode,
    output logic ready,
    output logic routing,
    output logic buffer_enable
);

    // State Encoding
    typedef enum logic [2:0] {
        RECEIVE   = 3'b000,
        DECODE    = 3'b001,
        ROUTE     = 3'b010,
        ROUTING   = 3'b011,
        ROUTER    = 3'b100,
        BUFFER    = 3'b101
    } state_t;

    state_t current_state, next_state;

    // State Transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RECEIVE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        // Default Outputs
        next_state = current_state;
        ready = 0;
        routing = 0;
        buffer_enable = 0;
        decode=0;
        case (current_state)
            RECEIVE: begin
                if (valid)
                    decode=1;
                    next_state = DECODE;
            end

            DECODE: begin
                if (router_ack) begin
                    ready = 1;
                    next_state = ROUTING;
                end else begin
                    next_state = ROUTER;
                end
            end

            ROUTING: begin
                if (router_available && !buffer)
                    routing = 1;
                    next_state = ROUTE;
                else if (router_available && buffer)
                    buffer_enable = 1;
                    next_state = BUFFER;
            end

            ROUTE: begin
                routing = 1;
                if (router_ack)
                    next_state = RECEIVE;
                else 
                    next_state = ROUTE;
            end

            BUFFER: begin
                buffer_enable = 1;
                if (router_available && buffer)
                    next_state = ROUTING;
            end

            default: begin
                next_state = RECEIVE;
            end
        endcase
    end
endmodule
