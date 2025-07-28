vlib work
vlog -f src_files_top.list 
vsim -voptargs=+acc work.top_test 
add wave -position insertpoint  \
sim:/top_test/hwrite_in \
sim:/top_test/readyin1 \
sim:/top_test/readyin2 \
sim:/top_test/readyin3 \
sim:/top_test/hclk \
sim:/top_test/hresetn \
sim:/top_test/start \
sim:/top_test/burst \
sim:/top_test/data_ready \
sim:/top_test/hwdata_in \
sim:/top_test/haddr_in \
sim:/top_test/hsize_in \
sim:/top_test/offset_in \
sim:/top_test/hrdata_out \
sim:/top_test/dut/m1/haddr \
sim:/top_test/dut/m1/htrans \
sim:/top_test/dut/m1/hwdata \
sim:/top_test/dut/s1/address \
sim:/top_test/dut/s1/mem \
sim:/top_test/dut/s2/mem \
sim:/top_test/dut/s3/mem \
sim:/top_test/dut/ic1/hrdata1 \
sim:/top_test/dut/ic1/hrdata2 \
sim:/top_test/dut/ic1/hrdata3 \
sim:/top_test/dut/ic1/hready1 \
sim:/top_test/dut/ic1/hready2 \
sim:/top_test/dut/ic1/hready3 \
sim:/top_test/dut/ic1/hresp \
sim:/top_test/dut/ic1/hresp1 \
sim:/top_test/dut/ic1/hresp2 \
sim:/top_test/dut/ic1/hresp3 \
sim:/top_test/dut/ic1/hsel1 \
sim:/top_test/dut/ic1/hsel2 \
sim:/top_test/dut/ic1/hsel3 \
sim:/top_test/dut/ic1/sel \
sim:/top_test/dut/ic1/selector \
sim:/top_test/dut/ic1/selector_reg
run -all