module address_modify (
    input [31:0] address_in,input [1:0]transmode,input [2:0]burst_size,input [1:0]selector,input clk,output reg [31:0] address_out,output reg exceed
);
    reg [31:0] address_saver;
    reg [31:0] address_burst;

    always @(posedge clk ) begin
        exceed <= 0; // Reset exceed flag
        address_saver <= address_out;
        address_burst <= address_out+burst_size;
        if ((address_out[12:0]+burst_size>=((2**13)-1))&&transmode==2'b11) begin
            exceed<=1; // Reset burst address if it exceeds memory size
            address_burst<=address_out; // Reset burst address to current address
        end
    end
    always @(*) begin
        case (selector)
            2'b00: address_out = address_in; // address input
            2'b01: address_out = address_saver; // preserve the address as if hready is zero
            2'b10: address_out = address_burst; // burst address
            default:address_out = 32'h00000000; // default case, can be modified as needed is in future implement more busrt types 
        endcase
    end
endmodule