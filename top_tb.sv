module top_test;
    logic hwrite_in, readyin1, readyin2, readyin3, hclk, hresetn, start, burst, data_ready;
    logic [31:0] hwdata_in, haddr_in;
    logic [2:0] hsize_in;
    logic [1:0] offset_in;
    logic [31:0] hrdata_out;
    string case_desc;

    top dut(
        .hwrite_in(hwrite_in),
        .readyin1(readyin1),
        .readyin2(readyin2),
        .readyin3(readyin3),
        .hclk(hclk),
        .hresetn(hresetn),
        .start(start),
        .burst(burst),
        .data_ready(data_ready),
        .hwdata_in(hwdata_in),
        .haddr_in(haddr_in),
        .hsize_in(hsize_in),
        .offset_in(offset_in),
        .hrdata_out(hrdata_out)
    );

    initial hclk = 0;
    always #5 hclk = ~hclk;

    // Task to apply transfer with case description
    task automatic run_case(
        input string desc,
        input logic hresetn_t, hwrite_in_t, readyin1_t, readyin2_t, readyin3_t,
        input logic start_t, burst_t, data_ready_t,
        input logic [31:0] hwdata_in_t, haddr_in_t,
        input logic [2:0] hsize_in_t,
        input logic [1:0] offset_in_t,
        input int repeat_count = 1
    );
        case_desc = desc;
        hresetn   = hresetn_t;
        hwrite_in = hwrite_in_t;
        readyin1  = readyin1_t;
        readyin2  = readyin2_t;
        readyin3  = readyin3_t;
        start     = start_t;
        burst     = burst_t;
        data_ready= data_ready_t;
        hwdata_in = hwdata_in_t;
        haddr_in  = haddr_in_t;
        hsize_in  = hsize_in_t;
        offset_in = offset_in_t;
        repeat(repeat_count) @(negedge hclk);
        $display("[%0t] %s", $time, case_desc);
    endtask

    initial begin
        run_case("Reset", 0,0,1,1,1,0,0,0,32'h0,32'h0,3'b010,2'b00);
        run_case("Idle", 1,1,1,1,1,0,0,0,32'h0,32'h0,3'b010,2'b00);
        run_case("Non-sequential", 1,1,1,1,1,1,0,1,32'h11223344,32'h0,3'b010,2'b00);
        run_case("Idle", 1,1,1,1,1,1,0,0,32'h11223344,32'h0,3'b010,2'b00);
        run_case("Start of burst", 1,1,1,1,1,1,1,1,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst, data_ready=0", 1,1,1,1,1,1,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst, data_ready=0", 1,1,1,1,1,1,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable", 1,0,1,1,1,0,0,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, start=1", 1,0,1,1,1,1,0,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, start=0", 1,0,1,1,1,0,0,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst with different address", 1,1,1,1,1,1,1,1,32'h11223344,32'h1ff4,3'b010,2'b00, 10);
        run_case("Burst, hsize=3'b000", 1,1,1,1,1,1,1,1,32'h11223344,32'h4,3'b000,2'b00, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, burst, hsize=3'b000", 1,0,1,1,1,1,1,0,32'h11223344,32'h4,3'b000,2'b00, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst, offset=2'b01", 1,1,1,1,1,1,1,1,32'h11223344,32'h4,3'b000,2'b01, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, burst, offset=2'b01", 1,0,1,1,1,1,1,0,32'h11223344,32'h4,3'b000,2'b01, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst, offset=2'b10", 1,1,1,1,1,1,1,1,32'h11223344,32'h4,3'b000,2'b10, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, burst, offset=2'b10", 1,0,1,1,1,1,1,0,32'h11223344,32'h4,3'b000,2'b10, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst, offset=2'b11", 1,1,1,1,1,1,1,1,32'h11223344,32'h4,3'b000,2'b11, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, burst, offset=2'b11", 1,0,1,1,1,1,1,0,32'h11223344,32'h4,3'b000,2'b11, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst, hsize=3'b001, offset=2'b10", 1,1,1,1,1,1,1,1,32'h11223344,32'h4,3'b001,2'b10, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, burst, hsize=3'b001, offset=2'b10", 1,0,1,1,1,1,1,0,32'h11223344,32'h4,3'b001,2'b10, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Burst, hsize=3'b001, offset=2'b00", 1,1,1,1,1,1,1,1,32'h11223344,32'h4,3'b001,2'b00, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Write disable, burst, hsize=3'b001, offset=2'b00", 1,0,1,1,1,1,1,0,32'h11223344,32'h4,3'b001,2'b00, 5);
        run_case("Burst, start=0, data_ready=0", 1,1,1,1,1,0,1,0,32'h11223344,32'h4,3'b010,2'b00, 5);
        run_case("Slave 1 done", 1,1,1,1,1,1,1,1,32'h11223344,32'h2004,3'b010,2'b00, 5);
        run_case("Slave 2, readyin2=0", 1,1,1,0,1,1,1,1,32'h11223344,32'h2004,3'b010,2'b00, 5);
        run_case("Slave 2, readyin2=1", 1,1,1,1,1,1,1,1,32'h11223344,32'h2004,3'b010,2'b00, 5);
        run_case("Slave 2, readyin2=0", 1,1,1,0,1,1,1,1,32'h11223344,32'h2004,3'b010,2'b00, 5);
        run_case("Slave 2, start=0", 1,1,1,0,1,0,1,1,32'h11223344,32'h2004,3'b010,2'b00, 5);
        run_case("Slave 3", 1,1,1,0,1,0,0,1,32'h11223344,32'h4004,3'b010,2'b00, 2);
        run_case("Slave 3", 1,1,1,0,1,1,0,1,32'h11223344,32'h4004,3'b010,2'b00, 2);
        run_case("Slave 3, data=0", 1,1,1,0,1,1,0,1,32'h0,32'h4004,3'b010,2'b00, 4);
        run_case("Slave 3", 1,1,1,0,1,0,0,1,32'h11223344,32'h4004,3'b010,2'b00, 2);
        run_case("Slave 3, data=0", 1,1,1,0,1,1,1,1,32'h0,32'h4004,3'b010,2'b00, 4);
        run_case("Slave 3, data=5", 1,1,1,0,1,1,0,1,32'h5,32'h4004,3'b010,2'b00, 4);
        $stop;
    end
endmodule