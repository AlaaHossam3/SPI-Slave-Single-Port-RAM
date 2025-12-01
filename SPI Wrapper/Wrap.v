module Wrap (MOSI, SS_n, clk, rst_n, MISO);
    
    input MOSI, SS_n, clk, rst_n;
    output MISO;

    wire tx_valid, clk, rst_n;
    wire [7:0] tx_data;

    wire rx_valid;
    wire [9:0] rx_data;

    RAM ram_init(.Din(rx_data), .rx_valid(rx_valid), .clk(clk), 
                 .rst_n(rst_n), .Dout(tx_data), .tx_valid(tx_valid));
                 
    SPI spi_init(.MOSI(MOSI), .SS_n(SS_n), .tx_data(tx_data), 
                 .tx_valid(tx_valid), .clk(clk), .rst_n(rst_n), 
                 .MISO(MISO), .rx_valid(rx_valid), .rx_data(rx_data));
endmodule