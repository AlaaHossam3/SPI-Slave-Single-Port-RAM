vlib work
vlog SPI_read_tb.v SPI.v
vsim -voptargs=+acc work.SPI_read_tb
add wave -position insertpoint  \
sim:/SPI_read_tb/clk \
sim:/SPI_read_tb/MISO \
sim:/SPI_read_tb/MOSI \
sim:/SPI_read_tb/MISO_reg \
sim:/SPI_read_tb/rst_n \
sim:/SPI_read_tb/rx_data \
sim:/SPI_read_tb/rx_valid \
sim:/SPI_read_tb/SS_n \
sim:/SPI_read_tb/tx_data \
sim:/SPI_read_tb/tx_valid
run -all
#quit -sim