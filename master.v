module mast (
    input        hwrite_in, hready, hresp, hclk, hresetn, start, burst, data_ready,
    input [31:0] hrdata, haddrin, hwdatain,
    input [2:0]  hsize_in,
    input [1:0]  offset_in,
    output       hwrite,
    output [31:0] haddr, hwdata, hrdata_out,
    output [2:0] hsize,
    output reg [2:0] hburst,
    output [1:0] htrans, offset
);

    // State encoding
    localparam IDLE   = 2'b00,
               NONSEQ = 2'b10,
               BUSY   = 2'b01,
               SEQ    = 2'b11;

    wire exceed;
    reg  [1:0] transmode_cs, transmode_ns;
    reg  [2:0] size;
    reg  [1:0] address_select;
    reg        flag;

    // Output assignments
    assign hrdata_out = hrdata;
    assign hwrite     = hwrite_in;
    assign hwdata     = hwdatain;
    assign hsize      = hsize_in;
    assign htrans     = transmode_cs;
    assign offset     = offset_in;

    address_modify add (
        .address_in(haddrin),
        .burst_size(size),
        .selector(address_select),
        .clk(hclk),
        .address_out(haddr),
        .exceed(exceed),
        .transmode(transmode_cs)
    );

    // State register
    always @(posedge hclk or negedge hresetn) begin
        if (!hresetn)
            transmode_cs <= IDLE;
        else
            transmode_cs <= transmode_ns;
    end

    // Flag logic
    always @(posedge hclk or negedge hresetn) begin
        if (!hresetn)
            flag <= 1'b0;
        else if (start && (data_ready || !hwrite_in) && burst && !flag)
            flag <= 1'b1;
        else
            flag <= 1'b0;
    end

    // Next state logic
    always @(*) begin
        transmode_ns = transmode_cs;
        case (transmode_cs)
            IDLE:
                if (start && (data_ready || !hwrite_in))
                    transmode_ns = NONSEQ;
            NONSEQ: begin
                if (!start || hresp)
                    transmode_ns = IDLE;
                else if (burst && start && (!data_ready && hwrite_in))
                    transmode_ns = BUSY;
                else if (burst && start && (data_ready || !hwrite_in) && flag)
                    transmode_ns = SEQ;
                else if ((burst && start && (data_ready || !hwrite_in))||!hready)
                    transmode_ns = NONSEQ;
            end
            SEQ: begin
                if (!start || hresp || exceed)
                    transmode_ns = IDLE;
                else if (!burst && start && (data_ready || !hwrite_in))
                    transmode_ns = NONSEQ;
                else if (burst && start && (!data_ready && hwrite_in))
                    transmode_ns = BUSY;
                else if (burst && start && (data_ready || !hwrite_in))
                    transmode_ns = SEQ;
            end
            BUSY: begin
                if (!start || hresp)
                    transmode_ns = IDLE;
                else if (!burst && start && (data_ready || !hwrite_in))
                    transmode_ns = NONSEQ;
                else if (burst && start && (data_ready || !hwrite_in))
                    transmode_ns = SEQ;
                else if (burst && start && !data_ready)
                    transmode_ns = BUSY;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        address_select = 2'b00;
        size           = 3'b000;
        hburst         = 3'b000;
        case (transmode_cs)
            NONSEQ, SEQ: begin
                hburst = burst ? 3'b001 : 3'b000;
                if (!hready) begin
                    address_select = 2'b01;
                end else if (burst) begin
                    address_select = 2'b10;
                    case (hsize_in)
                        3'b000: size = 3'b001;
                        3'b001: size = 3'b010;
                        default: size = 3'b100;
                    endcase
                end
            end
            BUSY: begin
                hburst         = 3'b001;
                address_select = 2'b01;
            end
        endcase
    end

endmodule
