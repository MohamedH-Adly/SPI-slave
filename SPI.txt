vlib finalproject
vlog SPImem.v SPIslav.v SPIwrap.v SPIwraptb.v                   +cover -covercells
vsim -voptargs=+acc work.SPIwraptb	         -cover
add wave -position end  sim:/SPIwraptb/MOSI
add wave -position end  sim:/SPIwraptb/SCK
add wave -position end  sim:/SPIwraptb/SS_n
add wave -position end  sim:/SPIwraptb/rst_n
add wave -position end  sim:/SPIwraptb/MISO
add wave -position end  sim:/SPIwraptb/tempaddr
add wave -position end  sim:/SPIwraptb/tempdata
add wave -position end  sim:/SPIwraptb/SPIwrap1/rx_valid
add wave -position end  sim:/SPIwraptb/SPIwrap1/tx_valid
add wave -position end  sim:/SPIwraptb/SPIwrap1/tx_data
add wave -position end  sim:/SPIwraptb/SPIwrap1/rx_data
add wave -position end  sim:/SPIwraptb/SPIwrap1/SPIslav1/cs
add wave -position end  sim:/SPIwraptb/SPIwrap1/SPIslav1/ns
add wave -position end  sim:/SPIwraptb/SPIwrap1/SPIslav1/counter
add wave -position end  sim:/SPIwraptb/SPIwrap1/SPIslav1/addr_data
add wave -position end  sim:/SPIwraptb/SPIwrap1/SPImem1/addr
add wave -position end  sim:/SPIwraptb/SPIwrap1/SPImem1/mem

run -all				 
coverage save SPIwraptb.ucdb -onexit
vcover report SPIwraptb.ucdb

