/*
============================================================================
 * Filename:    test_bench.sv
 * Description: Testbench for whole test
 * Author:      Hira Firdous
 * Date:        29/08/2024
 ===========================================================================
*/

module tb_testbench;

    logic         clk;
    logic         rst;
    logic         src_valid;                             
    logic         dd_ready;                               
    logic [12:0]  packet;
    logic         src_ready;                             
    logic         dd_valid;        
    
    // Instantiate the top module with packet generator
    top_modulePG dut (
        .clk         (clk),   
        .rst         (rst),   
        .src_valid   (src_valid), 
        .dd_ready    (dd_ready),  
        .src_ready   (src_ready),               
        .dd_valid    (dd_valid),
        .packet      (packet)
    );

    

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Reset task
    task reset();
        begin
            rst = 1; 
            @(posedge clk);
            rst = 0;
        end
    endtask

    // Monitor task to check packet outputs
    task monitor_output();
        begin
            @(posedge src_valid);
            @(posedge clk);
        
            // Wait for destination ready
            while (!dd_ready) begin 
                @(posedge clk);
            end

            // Wait for destination valid 
            while (!dd_valid) begin 
                @(posedge clk);
            end 
            
            $display("Packet %b ", packet);
            @(posedge clk);
        end
    endtask

    // Random packet test task
    task random_test();
        int i;

        for (i = 0; i < num_testcases; i++) begin
            // Generate random inputs
            src_valid = 1;
            
            @(posedge clk);

            // Apply inputs
            dd_ready = 1;

            @(posedge clk);

            // Checking the packet at every iteration
            while (!dd_valid) begin 
                @(posedge clk);
            end 
            src_valid = 0; 

            @(posedge clk);
        end
    endtask


    initial begin
        $dumpfile("packet_generator.vcd");
        $dumpvars(0, dut);
        reset();

        fork
            forever monitor_output();
            begin
                // Random testcases
                random_test(); 
                
                
                $finish;
            end
        join
    end

endmodule
