module SPI ( MOSI, SS_n, tx_data, tx_valid, clk, rst_n, MISO, rx_valid, rx_data);
    
    localparam IDLE      = 3'b000;
    localparam CHK_CMD   = 3'b001;
    localparam WRITE     = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;

    input MOSI, SS_n, tx_valid, clk, rst_n;
    input [7:0] tx_data;

    output reg MISO, rx_valid;
    output reg [9:0] rx_data;
    
    // FSM encoding using (gray, one_hot or sequential)

    (*fsm_encoding = "one_hot"*) reg [2:0] ns, cs;
    reg [7:0] received_data;
    reg [3:0] count;
    reg       add_sent;

    //Next State Logic
    always @(*) begin
        case (cs)
            IDLE:  begin
                if(SS_n) 
                    ns = IDLE;
                else if(~SS_n)
                    ns = CHK_CMD;
            end

            CHK_CMD: begin 
                if(SS_n)
                    ns = IDLE;
                else if(~SS_n && ~MOSI)
                    ns = WRITE;
                else if(~SS_n && MOSI && ~add_sent)
                    ns = READ_ADD;
                else if(~SS_n && MOSI && add_sent)
                    ns = READ_DATA;
            end

            WRITE: begin
                if(SS_n)
                    ns = IDLE;
                else
                    ns = WRITE;
            end
            
            READ_ADD: begin
                if(SS_n)
                    ns = IDLE;
                else
                    ns = READ_ADD;
            end

            READ_DATA: begin
                if(SS_n)
                    ns = IDLE;
                else
                    ns = READ_DATA;
            end
        endcase
    end

    //State Transition 
    always @(posedge clk) begin
        if(~rst_n) 
            cs <= IDLE;
        else
            cs <= ns;
    end

    //Output Logic
    always @(posedge clk) begin
        if(~rst_n) begin
            MISO          <= 0;
            rx_valid      <= 0;
            rx_data       <= 0;
            count         <= 0;
            received_data <= 0;
            add_sent      <= 0;
        end
        else begin
            case (cs)
                IDLE: begin
                    MISO     <= 0;
                    rx_valid <= 0;
                    rx_data  <= 10'd0;
                    count    <= 4'd0;
                end

                CHK_CMD: begin
                    MISO     <= 0;
                    rx_valid <= 0;
                    rx_data  <= 10'd0;
                    count    <= 4'd0;
                end

                WRITE: begin
                    if(count < 10) begin
                        count   <= count + 1;
                        rx_data <= {rx_data[8:0], MOSI};
                        if(count == 9)
                            rx_valid <= 1; 
                    end
                    else begin
                        count    <= 4'd0;
                        add_sent <= 0;
                    end
                end
                
                READ_ADD: begin
                    if(count < 10) begin
                        count   <= count + 1;
                        rx_data <= {rx_data[8:0], MOSI};
                        if(count == 9)
                            rx_valid <= 1; 
                    end
                    else begin
                        count    <= 4'd0;
                        add_sent <= 1;
                    end
                end

                READ_DATA: begin
                    if(count < 10 && ~tx_valid) begin
                        count   <= count + 1;
                        rx_data <= {rx_data[8:0], MOSI};
                        if(count == 9)
                            rx_valid <= 1; 
                    end
                    else if(tx_valid && rx_valid) begin
                        received_data <= tx_data;    
                        MISO          <= tx_data[7]; 
                        count         <= 1;
                        rx_valid      <= 0;
                    end
                    else if(rx_valid == 0) begin
                        if(count < 8) begin
                            MISO  <= received_data[7-count];
                            count <= count + 1;
                        end
                        else begin
                            count <= 0;
                            MISO  <= 0;
                        end
                    end
                end
            endcase
        end
    end
endmodule