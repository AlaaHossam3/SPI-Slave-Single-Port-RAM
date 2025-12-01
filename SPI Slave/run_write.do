vlib work
vlog SPI_write_tb.v SPI.v
vsim -voptargs=+acc work.SPI_write_tb
add wave -position insertpoint  \
sim:/SPI_write_tb/clk \
sim:/SPI_write_tb/MISO \
sim:/SPI_write_tb/MOSI \
sim:/SPI_write_tb/MOSI_reg \
sim:/SPI_write_tb/rst_n \
sim:/SPI_write_tb/rx_data \
sim:/SPI_write_tb/rx_valid \
sim:/SPI_write_tb/SS_n \
sim:/SPI_write_tb/tx_data \
sim:/SPI_write_tb/tx_valid
run -all
#quit -sim