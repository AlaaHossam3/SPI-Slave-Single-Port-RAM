/*
    This testbench test the read flow.
*/
module SPI_read_tb ();
    
    reg MOSI, SS_n, tx_valid, clk, rst_n;
    reg [7:0] tx_data;

    wire MISO, rx_valid;
    wire [9:0] rx_data;

    reg [7:0] MISO_reg;

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
        
        //Test READ_ADD
        MOSI = 1;
        @(negedge clk);
        
         if(DUT.cs != 3) begin
            $display("Error READ_ADD");
            $stop;
        end
        else 
            $display("READ_ADD passed");

        MOSI = 1; @(negedge clk);
        MOSI = 0; @(negedge clk);
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

        //Test READ_DATA
        MOSI = 1;
        @(negedge clk);
        
         if(DUT.cs != 4) begin
            $display("Error READ_DATA");
            $stop;
        end
        else 
            $display("READ_DATA passed");

        MOSI = 1; @(negedge clk);
        MOSI = 1; @(negedge clk);
        repeat(8) begin
            MOSI = 0;
            @(negedge clk);
        end

        tx_valid = 1;
        tx_data  = 81;
        @(negedge clk);

        repeat(8) begin
            MISO_reg = {MISO_reg[6:0], MISO};
            @(negedge clk);
        end

        if(MISO_reg != tx_data) begin
            $display("Error MISO_REG");
            $stop;
        end
        else 
            $display("MISO_REG passed");

        $stop;
    end
endmodule