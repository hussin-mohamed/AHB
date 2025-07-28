module slave (
    input         hsel, hwrite, hready, readyin, hresetn, hclk,
    input  [31:0] haddr, hwdata,
    input  [2:0]  hsize, hburst,
    input  [1:0]  htrans, add_offset,
    output reg [31:0] hrdata,
    output        hreadyout,
    output reg    hresp
);
    localparam MEM_DEPTH = 2**13;
    reg [7:0] mem [0:MEM_DEPTH-1];
    reg [31:0] address;
    reg [1:0]  transmode, offset;
    reg [2:0]  size;
    reg        sel, write, readyout, flag;

    assign hreadyout = readyout & readyin;

    // State update
    always @(posedge hclk or negedge hresetn) begin
        if (!hresetn) begin
            address   <= 32'h0;
            transmode <= 2'b00;
            write     <= 1'b0;
            offset    <= 2'b00;
            size      <= 3'b000;
            sel       <= 1'b0;
        end else begin
            sel       <= hsel;
            write     <= hwrite;
            address   <= haddr;
            transmode <= htrans;
            offset    <= add_offset;
            size      <= hsize;
        end
    end

    // Write logic
    always @(posedge hclk) begin
        if (hresetn && sel && write && hready && (transmode[1]) && (hwdata != 32'h0)) begin
            case (size)
                3'b010: begin // Word
                    mem[address[12:0]]     <= hwdata[7:0];
                    mem[address[12:0]+1]   <= hwdata[15:8];
                    mem[address[12:0]+2]   <= hwdata[23:16];
                    mem[address[12:0]+3]   <= hwdata[31:24];
                end
                3'b001: begin // Half-word
                    if (offset == 2'b00) begin
                        mem[address[12:0]]   <= hwdata[7:0];
                        mem[address[12:0]+1] <= hwdata[15:8];
                    end else if (offset == 2'b10) begin
                        mem[address[12:0]]   <= hwdata[23:16];
                        mem[address[12:0]+1] <= hwdata[31:24];
                    end
                end
                3'b000: begin // Byte
                    mem[address[12:0]] <= hwdata[{1'b0, offset}*8 +: 8];
                end
                default: begin
                    mem[address[12:0]]     <= hwdata[7:0];
                    mem[address[12:0]+1]   <= hwdata[15:8];
                    mem[address[12:0]+2]   <= hwdata[23:16];
                    mem[address[12:0]+3]   <= hwdata[31:24];
                end
            endcase
        end
    end

    // Response and readyout logic
    always @(posedge hclk or negedge hresetn) begin
        if (!hresetn) begin
            hresp    <= 1'b0;
            readyout <= 1'b1;
            flag     <= 1'b0;
        end else begin
            if (!sel || !write || !transmode[1] && !flag) begin
                hresp    <= 1'b0;
                readyout <= 1'b1;
                flag     <= 1'b0;
            end else if (hwdata == 32'h0 && !flag) begin
                hresp    <= 1'b1;
                readyout <= 1'b0;
                flag     <= 1'b1;
            end else if (flag) begin
                hresp    <= 1'b1;
                readyout <= 1'b1;
                flag     <= 1'b0;
            end
             else begin
                hresp    <= 1'b0;
                readyout <= 1'b1;
                flag     <= 1'b0;
            end
        end
    end

    // Read logic
    always @(*) begin
        hrdata <= 32'h0;
        if (sel && hready && hresetn && !write && transmode[1]) begin
            case (size)
                3'b010: hrdata <= {mem[address[12:0]+3], mem[address[12:0]+2], mem[address[12:0]+1], mem[address[12:0]]};
                3'b001: hrdata <= (offset == 2'b00) ? {16'h0, mem[address[12:0]+1], mem[address[12:0]]}
                                                   : {mem[address[12:0]+1], mem[address[12:0]], 16'h0};
                3'b000: hrdata <= {24'h0, mem[address[12:0]]} << (offset*8);
                default: hrdata <= {mem[address[12:0]+3], mem[address[12:0]+2], mem[address[12:0]+1], mem[address[12:0]]};
            endcase
        end
    end
endmodule
