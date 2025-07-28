vlib work
vlog -f src_files_master.list 
vsim -voptargs=+acc work.master_test 
add wave -position insertpoint  \
sim:/master_test/burst \
sim:/master_test/data_ready \
sim:/master_test/haddr \
sim:/master_test/haddrin \
sim:/master_test/hburst \
sim:/master_test/hclk \
sim:/master_test/hrdata \
sim:/master_test/hrdata_out \
sim:/master_test/hready \
sim:/master_test/hresetn \
sim:/master_test/hresp \
sim:/master_test/hsize \
sim:/master_test/hsize_in \
sim:/master_test/htrans \
sim:/master_test/hwdata \
sim:/master_test/hwdata_in \
sim:/master_test/hwrite \
sim:/master_test/hwrite_in \
sim:/master_test/offset \
sim:/master_test/offset_in \
sim:/master_test/start \
sim:/master_test/dut/flag
run -all