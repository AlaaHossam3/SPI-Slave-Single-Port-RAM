module Wrap_tb ();

    reg MOSI, SS_n, clk, rst_n;
    wire MISO;
    reg [7:0] add_reg;

    Wrap DUT(MOSI, SS_n, clk, rst_n, MISO);

    initial begin
        clk = 0;
        forever 
            #5 clk = ~clk;
    end
    integer i;
    initial begin
        $readmemh("mem.dat", DUT.ram_init.mem);
        rst_n = 0;
        SS_n  = 1;
        MOSI  = 0;
        @(negedge clk);

        // Test Write Address 
        rst_n = 1;
        repeat(1) @(negedge clk);
        
        SS_n = 0;
        MOSI = 0;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        
        for(i = 0; i <= 8; i = i + 1) begin
            MOSI = $random;
            add_reg = {add_reg[6:0], MOSI};
            @(negedge clk);
        end

        $display("rx_data = bin(%b) = hex(%h)", 
                  DUT.ram_init.Din, DUT.ram_init.Din);
        $display("---------- Test Write Address ----------\n");

        SS_n = 1;
        @(negedge clk);
        
        // Test Write Data 
        SS_n = 0;
        @(negedge clk);
        repeat(2) begin
            MOSI = 0;
            @(negedge clk);
        end
        MOSI = 1;
        @(negedge clk);
        
        repeat(8) begin
            MOSI = $random;
            @(negedge clk);
        end

        $display("rx_data = bin(%b) = hex(%h)", 
                  DUT.ram_init.Din, DUT.ram_init.Din);
        $display("------------ Test Write Data -----------\n");

        SS_n = 1;
        @(negedge clk);

        // Test Read Address 
        SS_n = 0;
        @(negedge clk);
        repeat(2) begin
            MOSI = 1;
            @(negedge clk);
        end
        MOSI = 0;
        @(negedge clk);
        
        for(i = 0; i < 8; i = i + 1) begin
            MOSI = add_reg[7-i];
            @(negedge clk);
        end

        $display("rx_data = bin(%b) = hex(%h)", 
                  DUT.ram_init.Din, DUT.ram_init.Din);
        $display("----------- Test Read Address ----------\n");
        
        SS_n = 1;
        @(negedge clk);

        // Test Read Data 
        SS_n = 0;
        @(negedge clk);

        repeat(3) begin
            MOSI = 1;
            @(negedge clk);
        end
        repeat(8) begin
            MOSI = 0;
            @(negedge clk);
        end

        $display("rx_data = bin(%b) = hex(%h)", 
                  DUT.ram_init.Din, DUT.ram_init.Din); 
        $display("-------- Test Read Data Command --------\n");

        @(negedge clk);

        repeat(8) begin
            @(negedge clk);
            $display("MISO = %b", MISO);
        end


        @(negedge clk);
        $display("MISO = %b", MISO);
        $display("received_data = bin(%b) = hex(%h)", 
                  DUT.spi_init.received_data, DUT.spi_init.received_data);
        $display("------------ Test Read Data ------------\n");

        //End Connection
        SS_n = 1;
        @(negedge clk);

        $stop;
    end
endmodule