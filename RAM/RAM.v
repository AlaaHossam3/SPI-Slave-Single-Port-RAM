module RAM ( Din, rx_valid, clk, rst_n, Dout, tx_valid);

    parameter MEM_DEPTH   = 256;
    parameter ADDR_SIZE   = 8;

    localparam WRITE_ADD  = 2'b00;
    localparam WRITE_DATA = 2'b01;
    localparam READ_ADD   = 2'b10;
    localparam READ_DATA  = 2'b11;
    
    input [9:0] Din;
    input rx_valid, clk, rst_n;

    output reg [7:0] Dout;
    output reg tx_valid;

    reg [ADDR_SIZE-1:0] addr_wr, addr_rd;
    reg [7:0] mem[MEM_DEPTH-1:0];

    always @(posedge clk) begin
        if(~rst_n) begin
            Dout     <= 0;
            tx_valid <= 0;
            addr_wr  <= 0;
            addr_rd  <= 0;
        end
        else begin
            case (Din[9:8])
                WRITE_ADD:  if (rx_valid) begin
                    addr_wr  <=  Din[7:0];
                    tx_valid <= 0;
                end
                WRITE_DATA: if (rx_valid) begin
                    mem[addr_wr] <= Din[7:0];
                    tx_valid     <= 0;
                end
                READ_ADD: if (rx_valid) begin
                    addr_rd  <= Din[7:0];
                    tx_valid <= 0;
                end
                READ_DATA: begin
                    Dout     <= mem[addr_rd];
                    tx_valid <= 1;
                end
            endcase
        end
    end
endmodule