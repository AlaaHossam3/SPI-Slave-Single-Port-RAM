vlib work
vlog Wrap.v Wrap_tb.v SPI.v RAM.v
vsim -voptargs=+acc work.Wrap_tb
add wave -position insertpoint  \
sim:/Wrap_tb/clk \
sim:/Wrap_tb/rst_n \
sim:/Wrap_tb/MOSI \
sim:/Wrap_tb/SS_n \
sim:/Wrap_tb/MISO \
sim:/Wrap_tb/DUT/spi_init/tx_data \
sim:/Wrap_tb/DUT/spi_init/rx_data \
sim:/Wrap_tb/DUT/spi_init/rx_valid \
sim:/Wrap_tb/DUT/spi_init/tx_valid \
sim:/Wrap_tb/DUT/spi_init/cs \
sim:/Wrap_tb/DUT/spi_init/received_data \
sim:/Wrap_tb/DUT/ram_init/mem
run -all
#quit -sim