vlib work
vlog -f src_files_slave.list 
vsim -voptargs=+acc work.slave_test 
add wave -position insertpoint  \
sim:/slave_test/hsel \
sim:/slave_test/hwrite \
sim:/slave_test/hready \
sim:/slave_test/readyin \
sim:/slave_test/hresetn \
sim:/slave_test/hclk \
sim:/slave_test/haddr \
sim:/slave_test/hwdata \
sim:/slave_test/hsize \
sim:/slave_test/hburst \
sim:/slave_test/htrans \
sim:/slave_test/add_offset \
sim:/slave_test/hrdata \
sim:/slave_test/hreadyout \
sim:/slave_test/hresp \
sim:/slave_test/dut/mem \
sim:/slave_test/dut/offset \
sim:/slave_test/dut/readyout \
sim:/slave_test/dut/sel \
sim:/slave_test/dut/write \
sim:/slave_test/dut/transmode \
sim:/slave_test/dut/address \
sim:/slave_test/dut/flag \
sim:/slave_test/dut/readyout
run -all