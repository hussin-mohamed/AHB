module interconnect (
    input [1:0] sel,input hready1,hclk,hresetn,hready2,hready3,hresp1,hresp2,hresp3,input[31:0]hrdata1,hrdata2,hrdata3,
    output reg [31:0] hrdata,output reg hready,hresp,hsel1, hsel2, hsel3
); 
    reg [1:0] selector,selector_reg;
    always @(*) begin
        case (sel)
            2'b00:begin 
                hsel1 = 1'b1; // Select first slave
                hsel2 = 1'b0; // Select second slave 
                hsel3 = 1'b0; // Select third slave
                selector = 2'b00; // Select first slave 
                end 
            2'b01: begin
                hsel2 = 1'b1; // Select second slave 
                hsel1 = 1'b0; // Select first slave
                hsel3 = 1'b0; // Select third slave
                selector = 2'b01; // Select second slave 
            end
            2'b10: begin
                hsel3 = 1'b1; // Select third slave 
                hsel1 = 1'b0; // Select first slave
                hsel2 = 1'b0; // Select second slave
                selector = 2'b10; // Select third slave 
            end
            default:begin
                hsel1 = 1'b0; // Default case, no slave selected
                hsel2 = 1'b0; // Default case, no slave selected
                hsel3 = 1'b0; // Default case, no slave selected
                selector = 2'b11; // Default selector
            end 
        endcase
    end
    always @(posedge hclk or negedge hresetn) begin
        if(!hresetn) begin
            selector_reg <= 2'b00; // Reset selector to default state
        end else begin
            selector_reg <= selector; // Update selector register
        end
    end
    always @(*) begin
        case (selector_reg)
            2'b00: begin
                hrdata = hrdata1; // Data from first slave
                hready = hready1; // First slave ready
                hresp = hresp1; // error response from first slave
            end
            2'b01: begin
                hrdata = hrdata2; // Data from second slave
                hready = hready2; // Second slave ready
                hresp = hresp2; // error response from second slave
            end
            2'b10: begin
                hrdata = hrdata3; // Data from third slave
                hready = hready3; // Third slave ready
                hresp = hresp3; // error response from third slave
            end
            default:  // Default case when no slave is selected
                begin
                    hrdata = 32'h00000000; // Default data
                    hready = 1'b1; // stay ready
                    hresp = 1'b0; // Error response
                end
        endcase
    end
endmodule