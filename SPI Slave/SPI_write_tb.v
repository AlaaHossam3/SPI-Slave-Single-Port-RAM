/*
    This testbench test the write flow.
*/
module SPI_write_tb ();
    
    reg MOSI, SS_n, tx_valid, clk, rst_n;
    reg [7:0] tx_data;

    wire MISO, rx_valid;
    wire [9:0] rx_data;

    reg [9:0] MOSI_reg;

    SPI DUT(MOSI, SS_n, tx_data, tx_valid, clk, 
            rst_n, MISO, rx_valid, rx_data);

    initial begin
        clk = 0;
        forever 
            #5 clk = ~clk;
    end

    initial begin
        rst_n    = 0;
        SS_n     = 1;
        MOSI     = 0;
        tx_valid = 0;
        tx_data  = 0;
        @(negedge clk);

        //Test CHK_CMD
        rst_n = 1;
        SS_n  = 0;
        @(negedge clk);

        if(DUT.cs != 1) begin
            $display("Error CHK_CMD");
            $stop;
        end
        else 
            $display("CHK_CMD passed");
        
        //Test WRITE_ADD
        repeat(3) begin
            MOSI = 0;
            @(negedge clk);
        end
        
         if(DUT.cs != 2) begin
            $display("Error WRITE_ADD");
            $stop;
        end
        else 
            $display("WRITE_ADD passed");

        repeat(8) begin
            MOSI = $random;
            @(negedge clk);
        end

        //Back to IDLE
        SS_n = 1;
        @(negedge clk);

        //Test CHK_CMD
        SS_n = 0;
        @(negedge clk);
        
        if(DUT.cs != 1) begin
            $display("Error CHK_CMD");
            $stop;
        end
        else 
            $display("CHK_CMD passed");

        //Test WRITE_DATA
        repeat(2) begin
            MOSI = 0;
            @(negedge clk);
        end
        
        if(DUT.cs != 2) begin
            $display("Error WRITE_DATA");
            $stop;
        end
        else 
            $display("WRITE_DATA passed");

        MOSI = 1; @(negedge clk);
        repeat(8) begin
            MOSI = $random;
            MOSI_reg = {MOSI_reg[8:0], MOSI};
            @(negedge clk);
        end

        if(MOSI_reg != rx_data) begin
            $display("Error MOSI_REG");
            $stop;
        end
        else 
            $display("MOSI_REG passed");

        $stop;
    end
endmodule