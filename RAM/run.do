vlib work
vlog RAM_tb.v RAM.v
vsim -voptargs=+acc work.RAM_tb
add wave -position insertpoint  \
sim:/RAM_tb/clk \
sim:/RAM_tb/Din_tb \
sim:/RAM_tb/Dout_tb \
sim:/RAM_tb/rst_n_tb \
sim:/RAM_tb/rx_valid_tb \
sim:/RAM_tb/tx_valid_tb \
sim:/RAM_tb/DUT/mem
run -all
#quit -sim