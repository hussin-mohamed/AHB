module master_test ();
    logic hwrite_in, hready, hresp, hclk, hresetn, start, burst, data_ready;
    logic [31:0] hwdata_in, haddrin, hrdata;
    logic [1:0] offset_in;
    logic [2:0]  hsize_in;
    logic       hwrite;
    logic [31:0] haddr, hwdata, hrdata_out;
    logic [2:0] hsize;
    logic [2:0] hburst;
    logic [1:0] htrans, offset;

    // Instantiate the DUT
    mast dut(
        .hwrite_in(hwrite_in),
        .hready(hready),
        .hresp(hresp),
        .hclk(hclk),
        .hresetn(hresetn),
        .start(start),
        .burst(burst),
        .data_ready(data_ready),
        .hwdatain(hwdata_in),
        .haddrin(haddrin),
        .hsize_in(hsize_in),
        .offset_in(offset_in),
        .hrdata(hrdata),
        .hwrite(hwrite),
        .haddr(haddr),
        .hwdata(hwdata),
        .hrdata_out(hrdata_out),
        .hsize(hsize),
        .hburst(hburst),
        .htrans(htrans),
        .offset(offset)
    );

    initial hclk = 0;
    always #5 hclk = ~hclk;
    // Task to apply stimulus with case description
task apply_transfer(
    input logic hresetn_t, hwrite_in_t, hready_t, hresp_t, start_t, burst_t, data_ready_t,
    input logic [2:0] hsize_in_t,
    input logic [31:0] haddrin_t, hwdatain_t,
    input logic [1:0] offset_in_t,
    input logic [31:0] hrdata_t,
    input string case_desc
);
    begin
        hresetn   = hresetn_t;
        hwrite_in = hwrite_in_t;
        hready    = hready_t;
        hresp     = hresp_t;
        start     = start_t;
        burst     = burst_t;
        data_ready= data_ready_t;
        hsize_in  = hsize_in_t;
        haddrin   = haddrin_t;
        hwdata_in  = hwdatain_t;
        offset_in = offset_in_t;
        hrdata    = hrdata_t;
        @(negedge hclk);
        $display("Case: %s, Simulation time: %0t", case_desc, $time);
    end
endtask

initial begin
    // reset sequence
    apply_transfer(0, 1, 1, 0, 1, 0, 1, 2, 0, 5, 0, 5, "reset sequence");

    // idle write transfer
    apply_transfer(1, 1, 1, 0, 0, 0, 0, 2, 0, 5, 0, 5, "idle write transfer");

    // idle write transfer
    apply_transfer(1, 1, 1, 0, 1, 0, 0, 2, 0, 5, 0, 5, "idle write transfer");

    // non seq write transfer
    apply_transfer(1, 1, 1, 0, 1, 0, 1, 2, 0, 5, 0, 5, "non seq write transfer");
    apply_transfer(1, 1, 1, 0, 1, 0, 1, 2, 0, 5, 0, 5, "non seq write transfer");

    // burst write transfer
    apply_transfer(1, 1, 1, 0, 1, 1, 1, 2, 0, 5, 0, 5, "burst write transfer");
    repeat(6) @(negedge hclk);

    // idle write transfer no error
    apply_transfer(1, 1, 1, 0, 1, 0, 0, 2, 0, 5, 0, 5, "idle write transfer no error");

    // start of burst write transfer
    apply_transfer(1, 1, 1, 0, 1, 1, 1, 2, 4, 5, 0, 5, "start of burst write transfer");
    apply_transfer(1, 1, 1, 0, 1, 1, 1, 2, 4, 5, 0, 5, "start of burst write transfer");

    // busy write transfer
    apply_transfer(1, 1, 1, 0, 1, 1, 0, 2, 4, 5, 0, 5, "busy write transfer");

    // burst write transfer
    apply_transfer(1, 1, 1, 0, 1, 1, 0, 2, 8, 5, 0, 5, "burst write transfer");

    // burst termination write transfer
    apply_transfer(1, 1, 1, 0, 0, 0, 0, 2, 4, 5, 0, 5, "burst termination write transfer");

    // idle write transfer
    apply_transfer(1, 1, 1, 0, 0, 0, 0, 2, 4, 5, 0, 5, "idle write transfer");

    // non seq write transfer
    apply_transfer(1, 1, 1, 0, 1, 1, 1, 2, 0, 5, 0, 5, "non seq write transfer");

    // seq write transfer
    apply_transfer(1, 1, 1, 0, 1, 1, 1, 2, 0, 5, 0, 5, "seq write transfer");
    @(negedge hclk);

    // wait write transfer
    apply_transfer(1, 1, 0, 0, 1, 1, 1, 2, 0, 5, 0, 5, "wait write transfer");
    apply_transfer(1, 1, 0, 0, 1, 1, 1, 2, 0, 5, 0, 5, "wait write transfer");
    apply_transfer(1, 1, 0, 0, 1, 1, 0, 2, 0, 5, 0, 5, "wait write transfer");
    apply_transfer(1, 1, 0, 0, 1, 0, 0, 2, 0, 5, 0, 5, "wait write transfer");
    apply_transfer(1, 1, 0, 0, 0, 0, 0, 2, 0, 5, 0, 5, "wait write transfer");

    // wait write transfer
    apply_transfer(1, 1, 1, 0, 0, 0, 0, 2, 0, 5, 0, 5, "wait write transfer");

    // idle write transfer
    apply_transfer(1, 1, 1, 0, 0, 0, 0, 2, 0, 5, 0, 5, "idle write transfer");

    // non seq write transfer
    apply_transfer(1, 1, 1, 0, 1, 1, 1, 2, 0, 5, 0, 5, "non seq write transfer");

    // seq write transfer but with error
    apply_transfer(1, 1, 0, 1, 1, 1, 1, 2, 0, 5, 0, 5, "seq write transfer with error");

    // idle write transfer
    apply_transfer(1, 1, 1, 0, 0, 0, 0, 2, 0, 5, 0, 5, "idle write transfer");
    @(negedge hclk);

    $stop;
end

    
endmodule
