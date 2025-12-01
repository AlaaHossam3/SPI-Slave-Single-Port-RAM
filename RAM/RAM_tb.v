module RAM_tb ();

    reg [9:0] Din_tb;
    reg rx_valid_tb, clk, rst_n_tb;

    wire [7:0] Dout_tb;
    wire tx_valid_tb;
    reg [7:0] addr_save;

    RAM DUT(.Din(Din_tb), .rx_valid(rx_valid_tb), .clk(clk), .rst_n(rst_n_tb), 
            .Dout(Dout_tb), .tx_valid(tx_valid_tb));

    initial begin
        clk = 0;
        forever
            #5 clk = ~clk;
    end

    integer i;
    initial begin
        $readmemh("mem.dat", DUT.mem);

        rst_n_tb    = 0;
        Din_tb      = {10{1'b0}};
        rx_valid_tb = 1;

        @(negedge clk);
        rst_n_tb = 1;

        for(i = 0; i<5; i = i+1) begin
            $display("\n---- Iteration number %0d ----", i+1);

            //Test write address
            Din_tb[9:8] = 2'b00;
            Din_tb[7:0] = $random;
            @(negedge clk);

            if(DUT.addr_wr != Din_tb) begin
                $display("Error in write address.");
                $stop;
            end
            else
                $display("Write address passed.");
            
            //Test write data
            Din_tb[9:8] = 2'b01;
            Din_tb[7:0] = $random;
            addr_save = DUT.addr_wr;
            @(negedge clk);

            if(DUT.mem[DUT.addr_wr] != Din_tb[7:0]) begin
                $display("Error in write data.");
                $stop;
            end
            else
                $display("Write data passed.");

            //Test read address
            Din_tb[9:8] = 2'b10;
            Din_tb[7:0] = addr_save;
            @(negedge clk);

            if(DUT.addr_rd != addr_save) begin
                $display("Error in read address.");
                $stop;
            end
            else
                $display("Read address passed.");
            
            //Test read data
            Din_tb[9:8] = 2'b11;
            @(negedge clk);

            if(Dout_tb != DUT.mem[DUT.addr_rd]) begin
                $display("Error in read data.");
                $stop;
            end
            else
                $display("Read data passed.");
        end
        $stop;
    end
endmodule