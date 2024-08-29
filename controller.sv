/*
============================================================================
 * Description: Test controller for the testing of PG
 * Author:      Hira Firdous
 * Date:        29/08/2024
 ===========================================================================
*/
module control_unit (
    input  logic clk,   
    input  logic rst,   
    input  logic src_valid,                             
    input  logic dd_ready, 
    output logic src_ready,                             
    output logic dd_valid,          
    output logic generate_packet        
);

    // Defining states
    typedef enum logic [2:0] {
        IDLE,  
        GENERATE_PACKET,
        WAIT
    } state_t;

    state_t state, next_state;

    // State transition logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        src_ready = 0;
        dd_valid = 0;
        generate_packet = 0;
        next_state = state;  

        case (state)
            IDLE: begin
                src_ready = 1;  
                if (src_valid) begin
                    generate_packet = 1; 
                    next_state = GENERATE_PACKET;
                end
            end

            GENERATE_PACKET: begin
                generate_packet = 1; 
                if (dd_ready) begin
                    dd_valid = 1; 
                    next_state = IDLE;
                end else begin
                    next_state = WAIT; 
                end
            end

            WAIT: begin
                if (dd_ready) begin
                    dd_valid = 1;  
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE; 
            end
        endcase
    end

endmodule