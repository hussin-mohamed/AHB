module slave_test;
    logic hsel, hwrite, hready, readyin, hresetn, hclk;
    logic [31:0] haddr, hwdata;
    logic [2:0] hsize, hburst;
    logic [1:0] htrans, add_offset;
    logic [31:0] hrdata;
    logic hreadyout, hresp;

    slave dut(
        .hsel(hsel), .hwrite(hwrite), .hready(hready), .readyin(readyin),
        .hresetn(hresetn), .hclk(hclk), .haddr(haddr), .hwdata(hwdata),
        .hsize(hsize), .hburst(hburst), .htrans(htrans), .add_offset(add_offset),
        .hrdata(hrdata), .hreadyout(hreadyout), .hresp(hresp)
    );

    initial hclk = 0;
    always #5 hclk = ~hclk;

    // Helper task for transactions, now with case name and simulation time
    task automatic ahb_trans(
        input logic hsel_i, hwrite_i, hready_i, readyin_i,
        input logic [31:0] haddr_i, hwdata_i,
        input logic [2:0] hsize_i, hburst_i,
        input logic [1:0] htrans_i, add_offset_i,
        input int cycles = 1,
        input string case_name = ""
    );
        begin
            hsel      = hsel_i;
            hwrite    = hwrite_i;
            hready    = hready_i;
            readyin   = readyin_i;
            haddr     = haddr_i;
            hwdata    = hwdata_i;
            hsize     = hsize_i;
            hburst    = hburst_i;
            htrans    = htrans_i;
            add_offset= add_offset_i;
            $display("[%0t] Case: %s", $time, case_name);
            repeat(cycles) @(negedge hclk);
        end
    endtask

    initial begin
        hresetn = 0;
        ahb_trans(1, 1, 1, 1, 32'h00000000, 32'h00000005, 3'b010, 3'b000, 2'b00, 2'b00, 1, "Reset");
        hresetn = 1;
        ahb_trans(1, 1, 1, 1, 32'h00000000, 32'h00000005, 3'b010, 3'b000, 2'b00, 2'b00, 1, "Write 1");
        ahb_trans(1, 1, 1, 1, 32'h00000000, 32'h00000005, 3'b010, 3'b000, 2'b10, 2'b00, 1, "Write 2");
        ahb_trans(0, 1, 1, 1, 32'h00000000, 32'h00000015, 3'b010, 3'b000, 2'b10, 2'b00, 1, "Write 3");
        ahb_trans(1, 1, 0, 0, 32'h00000004, 32'h00000020, 3'b010, 3'b000, 2'b10, 2'b00, 1, "Write 4");
        ahb_trans(1, 1, 1, 1, 32'h00000004, 32'h00000020, 3'b010, 3'b000, 2'b10, 2'b00, 2, "Write 5");
        ahb_trans(1, 1, 1, 1, 32'h00000004, 32'h00000000, 3'b010, 3'b000, 2'b10, 2'b00, 3, "Write 6");
        ahb_trans(1, 1, 1, 1, 32'h00000004, 32'h00000255, 3'b000, 3'b000, 2'b10, 2'b00, 3, "Write 7");
        ahb_trans(1, 1, 1, 1, 32'h00000004, 32'h00000255, 3'b000, 3'b000, 2'b10, 2'b01, 3, "Write 8");
        ahb_trans(1, 1, 1, 1, 32'h00000004, 32'h44667255, 3'b000, 3'b000, 2'b10, 2'b10, 3, "Write 9");
        ahb_trans(1, 1, 1, 1, 32'h00000004, 32'h44667255, 3'b000, 3'b000, 2'b10, 2'b11, 3, "Write 10");
        ahb_trans(1, 0, 1, 1, 32'h00000004, 32'h44667255, 3'b000, 3'b000, 2'b10, 2'b11, 3, "Read 1");
        ahb_trans(1, 0, 1, 1, 32'h00000004, 32'h44667255, 3'b000, 3'b000, 2'b10, 2'b00, 3, "Read 2");
        ahb_trans(1, 0, 1, 1, 32'h00000004, 32'h44667255, 3'b000, 3'b000, 2'b10, 2'b01, 3, "Read 3");
        ahb_trans(1, 0, 1, 1, 32'h00000004, 32'h44667255, 3'b000, 3'b000, 2'b10, 2'b00, 4, "Read 4");
        ahb_trans(1, 0, 1, 1, 32'h00000000, 32'h44667255, 3'b010, 3'b000, 2'b10, 2'b00, 3, "Read 5");
        ahb_trans(1, 1, 1, 1, 32'h00000000, 32'h44667255, 3'b001, 3'b000, 2'b10, 2'b00, 3, "Write 11");
        ahb_trans(1, 1, 1, 1, 32'h00000000, 32'h44667255, 3'b001, 3'b000, 2'b10, 2'b10, 3, "Write 12");
        ahb_trans(1, 0, 1, 1, 32'h00000000, 32'h44667255, 3'b001, 3'b000, 2'b10, 2'b10, 3, "Read 6");
        ahb_trans(1, 0, 1, 1, 32'h00000000, 32'h44667255, 3'b001, 3'b000, 2'b10, 2'b00, 3, "Read 7");
        $stop;
    end
endmodule
